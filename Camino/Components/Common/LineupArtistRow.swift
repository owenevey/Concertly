import SwiftUI

struct LineupArtistRow: View {
    let artist: SuggestedArtist
    
    var body: some View {
        NavigationLink {
            ArtistView(artistID: artist.id)
                .navigationBarHidden(true)
        }
        label: {
            HStack(spacing: 15) {
                ImageLoader(url: artist.imageUrl, contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                    .clipped()
                
                Text(artist.name)
                    .font(.system(size: 20, type: .Regular))
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .padding(.trailing, 5)
            }
            .padding(10)
            .contentShape(Rectangle())
            .background(.gray1)
            .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack {
        LineupArtistRow(artist: SuggestedArtist(name: "Sabrina Carpenter", id: "K8vZ9173-lV", imageUrl: "https://s1.ticketm.net/dam/a/e89/0077a6e2-a82d-4d67-bd68-c47aa3212e89_TABLET_LANDSCAPE_3_2.jpg"))
            .padding()
    }
}
