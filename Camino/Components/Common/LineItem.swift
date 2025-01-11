import SwiftUI

struct LineItem<T: TripViewModelProtocol>: View {
    
    let item: LineItemType<T>
    let price: Int
    let status: Status
    
    @State private var showSafariView = false
    @State private var currentStatus: Status
    
    init(item: LineItemType<T>, price: Int, status: Status) {
        self.item = item
        self.price = price
        self.status = status
        _currentStatus = State(initialValue: status)
    }
    
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
                        if let url = URL(string: link) {
                            SFSafariView(url: url)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                if status == Status.success {
                    NavigationLink(destination: item.destinationView.navigationBarHidden(true)) {
                        lineItemContent
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                else {
                    lineItemContent
                }
                
            }
        }
        .onChange(of: status) { oldStatus, newStatus in
            withAnimation(.easeInOut) {
                currentStatus = newStatus
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
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                )
            Text("\(item.title):")
                .font(.system(size: 18, type: .Medium))
            Spacer()
            HStack {
                if currentStatus == .loading || currentStatus == .empty {
                    CircleLoadingView(ringSize: 20)
                        .padding(.trailing, 10)
                }
                else if currentStatus == .success {
                    if case .ticket = item {
                        Text("View")
                            .font(.system(size: 18, type: .Medium))
                    } else {
                        Text("$\(price)")
                            .font(.system(size: 18, type: .Medium))
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                }
                else if currentStatus == .error {
                    Text("Error")
                        .font(.system(size: 18, type: .Medium))
                }
            }
            .transition(.opacity)
        }
        .padding(15)
        .contentShape(RoundedRectangle(cornerRadius: 20))
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.gray1)
        )
    }
}

enum LineItemType<T: TripViewModelProtocol> {
    
    case flights(tripViewModel: T)
    case hotel(tripViewModel: T)
    case ticket(link: String)
    
    static func eventItems(eventViewModel: T, link: String) -> [LineItemType] {
        return [
            .flights(tripViewModel: eventViewModel),
            .hotel(tripViewModel: eventViewModel),
            .ticket(link: link)
        ]
    }
    
    static func placeItems(placeViewModel: T) -> [LineItemType] {
        return [
            .flights(tripViewModel: placeViewModel),
            .hotel(tripViewModel: placeViewModel),
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
        case let .flights(tripViewModel):
            FlightsView(tripViewModel: tripViewModel)
        case let .hotel(tripViewModel):
            HotelsView(tripViewModel: tripViewModel)
        case let .ticket(link):
            SFSafariView(url: URL(string: link)!)
        }
    }
}


#Preview {
    let concertViewModel = ConcertViewModel(concert: hotConcerts[0])
    let link = "https://example.com"
    
    NavigationStack {
        VStack(spacing: 20) {
            LineItem(item: LineItemType.flights(tripViewModel: concertViewModel), price: 55, status: Status.loading)
                .padding()
            
            LineItem(item: LineItemType.hotel(tripViewModel: concertViewModel), price: 100, status: Status.success)
                .padding()
            
            LineItem(item: LineItemType<ConcertViewModel>.ticket(link: link), price: 25, status: Status.success)
                .padding()
        }
    }
}



