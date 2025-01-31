import SwiftUI

struct ConcertLinksSheet: View {
    
    var links: [(String, String)]
    
    @State private var selectedLink: String?
    
    var body: some View {
        VStack(spacing: 20) {
            
            ForEach(0..<links.count, id: \.self) { index in
                Button(action: {
                    selectedLink = links[index].1
                }) {
                    HStack {
                        Text(links[index].0.capitalizedWords())
                            .font(.system(size: 17, type: .Regular))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 17, weight: .semibold))
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                if index < links.count - 1 {
                    Divider()
                        .frame(height: 1)
                        .overlay(.gray1)
                }
            }
        }
        .padding(15)
        .padding(.vertical, 15)
        .background(Color.background)
        
        
        .sheet(isPresented: Binding<Bool>(
            get: { selectedLink != nil },
            set: { isPresented in
                if !isPresented {
                    selectedLink = nil
                }
            }
        )) {
            if let url = URL(string: selectedLink!) {
                SFSafariView(url: url)
            }
        }
    }
}

#Preview {
    var links = [
        ("SABRINA CARPENTER: SHORT N´ SWEET | All-In Package", "https://www.ticketmaster.de/event/sabrina-carpenter-short-n-sweet-%7C-all-in-package-tickets/549837?language=en-us"),
        ("SABRINA CARPENTER: SHORT N´ SWEET TOUR | Premium Seat", "https://www.ticketmaster.de/event/sabrina-carpenter-short-n-sweet-tour-%7C-premium-seat-tickets/549833?language=en-us"),
        ("SABRINA CARPENTER: SHORT N' SWEET TOUR", "https://www.ticketmaster.de/event/sabrina-carpenter-short-n-sweet-tour-tickets/549035?language=en-us"),
        ("SABRINA CARPENTER: SHORT N´ SWEET TOUR | Logen Seat", "https://www.ticketmaster.de/event/sabrina-carpenter-short-n-sweet-tour-%7C-logen-seat-tickets/549241?language=en-us")
    ]
    ConcertLinksSheet(links: links)
}
