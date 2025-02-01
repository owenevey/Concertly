import SwiftUI

struct LineItem<T: TripViewModelProtocol>: View {
    
    let item: LineItemType<T>
    let status: Status
    let price: Int
    
    private var selectedLinks: [(String, String)] = []
    @State private var showSheet = false
    @State private var isSafariView = false
    
    @State var detentHeight: CGFloat = 400
    @State private var currentStatus: Status
    
    init(item: LineItemType<T>, status: Status, price: Int = 0) {
        self.item = item
        self.status = status
        self.price = price
        _currentStatus = State(initialValue: status)
        
        if case let .ticket(links) = item {
            selectedLinks = links
        }
    }
    
    var body: some View {
        Group {
            if case .ticket = item {
                Button(action: {
                    showSheet.toggle()
                }) {
                    lineItemContent
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                if status == Status.success {
                    NavigationLink(destination: item.destinationView) {
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
        .sheet(isPresented: $showSheet) {
            if selectedLinks.count == 1, let url = URL(string: selectedLinks.first?.1 ?? "") {
                SFSafariView(url: url)
            } else {
                ConcertLinksSheet(links: selectedLinks, showSheet: $showSheet)
                    .readHeight()
                    .onPreferenceChange(BottomSheetHeightPreferenceKey.self) { height in
                        if let height {
                            self.detentHeight = height
                        }
                    }
                    .presentationDetents([.height(self.detentHeight)])
                    .presentationBackground(Color.background)
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
    case ticket(links: [(String, String)])
    
    static func concertItems(concertViewModel: T, links: [(String, String)]) -> [LineItemType] {
        return [
            .flights(tripViewModel: concertViewModel),
            .hotel(tripViewModel: concertViewModel),
            .ticket(links: links)
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
        case let .ticket(links):
            EmptyView()
        }
    }
}


#Preview {
    let concertViewModel = ConcertViewModel(concert: hotConcerts[0])
    let links = [("first", "https://example.com")]
    
    NavigationStack {
        VStack(spacing: 10) {
            Spacer()
            LineItem(item: LineItemType.flights(tripViewModel: concertViewModel), status: Status.loading, price: 55)
            
            LineItem(item: LineItemType.hotel(tripViewModel: concertViewModel), status: Status.success, price: 100)
            
            LineItem(item: LineItemType<ConcertViewModel>.ticket(links: links), status: Status.success, price: 25)
            Spacer()
        }
        .padding(15)
        .background(Color.background)
    }
}



