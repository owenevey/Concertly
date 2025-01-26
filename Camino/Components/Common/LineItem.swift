import SwiftUI

struct LineItem<T: TripViewModelProtocol>: View {
    
    let item: LineItemType<T>
    let status: Status
    let price: Int
    
    @State private var showSafariView = false
    @State private var currentStatus: Status
    
    init(item: LineItemType<T>, status: Status, price: Int = 0) {
        self.item = item
        self.status = status
        self.price = price
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
            withAnimation(.easeInOut(duration: 0.2)) {
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
    
    static func concertItems(concertViewModel: T, link: String) -> [LineItemType] {
        return [
            .flights(tripViewModel: concertViewModel),
            .hotel(tripViewModel: concertViewModel),
            .ticket(link: link)
        ]
    }
    
    static func destinationItems(destinationViewModel: T) -> [LineItemType] {
        return [
            .flights(tripViewModel: destinationViewModel),
            .hotel(tripViewModel: destinationViewModel),
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
            LineItem(item: LineItemType.flights(tripViewModel: concertViewModel), status: Status.loading, price: 55)
                .padding()
            
            LineItem(item: LineItemType.hotel(tripViewModel: concertViewModel), status: Status.success, price: 100)
                .padding()
            
            LineItem(item: LineItemType<ConcertViewModel>.ticket(link: link), status: Status.success, price: 25)
                .padding()
        }
    }
}



