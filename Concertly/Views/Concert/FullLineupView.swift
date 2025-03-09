import SwiftUI

struct FullLineupView: View {
    @Environment(\.dismiss) var dismiss
    
    var lineup: [SuggestedArtist]
    
    var title: String = "Lineup"
    
    @State private var showHeaderBorder: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    BackButton()
                    
                    Text(title)
                        .font(.system(size: 30, type: .SemiBold))
                }
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .frame(height: 1.5)
                    .overlay(.gray2)
                    .opacity(showHeaderBorder ? 1 : 0)
                    .animation(.linear(duration: 0.1), value: showHeaderBorder)
            }
            .background(Color.background)
            
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(lineup) { artist in
                        LineupArtistRow(artist: artist)
                    }
                }
                .padding([.horizontal, .bottom], 15)
            }
            .background(Color.background)
            .onScrollGeometryChange(for: CGFloat.self) { geo in
                return geo.contentOffset.y
            } action: { oldValue, newValue in
                showHeaderBorder = newValue > 0
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        FullLineupView(lineup: hotConcerts[0].lineup)
    }
}
