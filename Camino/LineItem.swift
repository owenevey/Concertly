import SwiftUI

struct LineItem: View {
    
    let item: LineItemType
    let price: Int
    
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
            Text("$\(price)")
                .font(Font.custom("Barlow-SemiBold", size: 17))
            //                .foregroundStyle(.gray)
        }
        .padding(15)
        .contentShape(RoundedRectangle(cornerRadius: 20))
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.customGray, lineWidth: 2)
        )
    }
}

enum LineItemType {
    
    case flights(fromDate: Binding<Date>, toDate: Binding<Date>, fromAirport: Binding<String>, toAirport: Binding<String>, flightInfo: Binding<FlightInfo>)
    case hotel(fromDate:Binding<Date>, toDate: Binding<Date>)
    case ticket(link: String)
    
    static func allCases(fromDate: Binding<Date>, toDate: Binding<Date>, fromAirport: Binding<String>, toAirport: Binding<String>, flightInfo: Binding<FlightInfo?>, link: String) -> [LineItemType] {
        return [
            .flights(fromDate: fromDate, toDate: toDate, fromAirport: fromAirport, toAirport: toAirport, flightInfo: flightInfo),
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
        case let .flights(fromDate, toDate, fromAirport, toAirport, flightInfo):
            FlightsView(flightData: we)
        case let .hotel(fromDate, toDate):
            HotelsView(fromDate: fromDate, toDate: toDate)
        case let .ticket(link):
            SFSafariView(url: URL(string: link)!)
        }
    }
}


#Preview {
    let fromDate = Binding.constant(Date.now)
    let toDate = Binding.constant(Date.now)
    let fromAirport = Binding.constant("AUS")
    let toAirport = Binding.constant("SYD")
    let flightInfo = Binding.constant(FlightInfo())
    
    return NavigationStack {
        LineItem(item: LineItemType.flights(fromDate: fromDate, toDate: toDate, fromAirport: fromAirport, toAirport: toAirport, flightInfo: flightInfo), price: 55)
            .padding()
    }
}


