import SwiftUI

struct LineItem: View {
    
    let item: LineItemType
    let price: Double
    
    @State private var showSafariView = false
    
    var body: some View {
        Group {
            if case .ticket = item {
                Button(action: {
                    showSafariView.toggle()
                }) {
                    lineItemContent
                }
                .sheet(isPresented: $showSafariView) {
                    if case let .ticket(link) = item {
                        SFSafariView(url: URL(string: link)!)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                NavigationLink(destination: item.destinationView.navigationBarHidden(true)) {
                    lineItemContent
                    
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    var lineItemContent: some View {
        HStack(spacing: 15) {
            Circle()
                .fill(.accent)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: item.iconName)
                        .font(Font.custom("Barlow-SemiBold", size: 17))
                        .foregroundStyle(.white)
                )
            Text("\(item.title):")
                .font(Font.custom("Barlow-SemiBold", size: 17))
            Spacer()
            Text("$\(String(format: "%.0f", price))")
                .font(Font.custom("Barlow-SemiBold", size: 17))
                .foregroundStyle(.gray)
        }
        .padding(15)
        .contentShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.card, lineWidth: 2)
        )
    }
}

enum LineItemType {
    
    case flights(fromDate: Date?, toDate: Date?)
    case hotel(fromDate: Date?, toDate: Date?)
    case ticket(link: String)
    
    static func allCases(fromDate: Date?, toDate: Date?, link: String) -> [LineItemType] {
        return [
            .flights(fromDate: fromDate, toDate: toDate),
            .hotel(fromDate: fromDate, toDate: toDate),
            .ticket(link: link)
        ]
    }
    
    var title: String {
        switch self {
        case .flights:
            return "Flights"
        case .hotel:
            return "Hotel"
        case .ticket:
            return "Ticket"
        }
    }
    
    var iconName: String {
        switch self {
        case .flights:
            return "airplane"
        case .hotel:
            return "bed.double.fill"
        case .ticket:
            return "ticket.fill"
        }
    }
    
    @ViewBuilder
    var destinationView: some View {
        switch self {
        case let .flights(fromDate, toDate):
            FlightsView(fromDate: fromDate, toDate: toDate)
        case let .hotel(fromDate, toDate):
            HotelsView(fromDate: fromDate, toDate: toDate)
        case let .ticket(link):
            SFSafariView(url: URL(string: link)!)
        }
    }
}


#Preview {
    LineItem(item: LineItemType.flights(fromDate: nil, toDate: nil), price: 55)
    
}


