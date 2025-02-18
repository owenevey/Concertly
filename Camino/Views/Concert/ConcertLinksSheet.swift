import SwiftUI

struct ConcertLinksSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var links: [(String, String)]
    @Binding var showSheet: Bool
    
    @State private var selectedLink: String?
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Links")
                    .font(.system(size: 20, type: .SemiBold))

                Spacer()
                BackButton(showBackground: true, showX: true)
            }
            
            ForEach(0..<links.count, id: \.self) { index in
                Button(action: {
                    selectedLink = links[index].1
                }) {
                    HStack {
                        Text(links[index].0.capitalizedWords())
                            .font(.system(size: 17, type: .Regular))
                        Spacer()
                        Image(systemName: "arrow.up.forward.square")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                
                if index < links.count - 1 {
                    Divider()
                        .frame(height: 2)
                        .overlay(.gray1)
                }
            }
        }
        .padding(15)
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
    let links = [
        ("American Express Presents BST Hyde Park - Olivia Rodrigo", "https://www.ticketmaster.de/event/sabrina-carpenter-short-n-sweet-%7C-all-in-package-tickets/549837?language=en-us"),
        ("Olivia Rodrigo - Official Premium and Hotel Experiences", "https://www.ticketmaster.de/event/sabrina-carpenter-short-n-sweet-tour-%7C-premium-seat-tickets/549833?language=en-us"),
        ("SABRINA CARPENTER: SHORT N' SWEET TOUR", "https://www.ticketmaster.de/event/sabrina-carpenter-short-n-sweet-tour-tickets/549035?language=en-us"),
        ("SABRINA CARPENTER: SHORT N´ SWEET TOUR | Logen Seat", "https://www.ticketmaster.de/event/sabrina-carpenter-short-n-sweet-tour-%7C-logen-seat-tickets/549241?language=en-us")
    ]
    ConcertLinksSheet(links: links, showSheet: .constant(true))
        .border(.black)
}
