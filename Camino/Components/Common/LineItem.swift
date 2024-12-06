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
                        .font(.system(size: 16))
                        .foregroundStyle(.white)
                )
            Text("\(item.title):")
                .font(.system(size: 18, type: .Medium))
            Spacer()
            HStack {
                Text("$\(price)")
                    .font(.system(size: 18, type: .Medium))
                Image(systemName: "chevron.right")
                    .font(.system(size: 15))
            }
            
        }
        .padding(15)
        .contentShape(RoundedRectangle(cornerRadius: 20))
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.customGray.opacity(0.5))
        )
    }
}

enum LineItemType {
    
    case flights(concertViewModel: ConcertViewModel)
    case hotel(concertViewModel: ConcertViewModel)
    case ticket(link: String)
    
    static func allCases(concertViewModel: ConcertViewModel, link: String) -> [LineItemType] {
        return [
            .flights(concertViewModel: concertViewModel),
            .hotel(concertViewModel: concertViewModel),
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
        case let .flights(concertViewModel):
            FlightsView(concertViewModel: concertViewModel)
        case let .hotel(concertViewModel):
            HotelsView(concertViewModel: concertViewModel)
        case let .ticket(link):
            SFSafariView(url: URL(string: link)!)
        }
    }
}


import SwiftUI

#Preview {
    let concertViewModel = ConcertViewModel(concert: hotConcerts[0])
    let link = "https://example.com" // Example link for ticket
    
    NavigationStack {
        LineItem(item: LineItemType.flights(concertViewModel: concertViewModel), price: 55)
            .padding()
        
        LineItem(item: LineItemType.hotel(concertViewModel: concertViewModel), price: 100)
            .padding()
        
        LineItem(item: LineItemType.ticket(link: link), price: 25)
            .padding()
    }
}



