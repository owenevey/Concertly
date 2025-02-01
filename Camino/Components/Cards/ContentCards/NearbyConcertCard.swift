import SwiftUI

struct NearbyConcertCard: View {
    @Namespace private var namespace
    let id = "UIElement"
    
    var concert: Concert
    
    var body: some View {
        NavigationLink {
            ConcertView(concert: concert)
                .navigationTransition(.zoom(sourceID: id, in: namespace))
        }
        label: {
            HStack(spacing: 0) {
                ImageLoader(url: concert.imageUrl, contentMode: .fill)
                    .frame(width: 150, height: 120)
                    .clipped()
                                
                VStack(alignment: .leading, spacing: 5) {
                    Text(concert.artistName)
                        .font(.system(size: 20, type: .SemiBold))
                        .minimumScaleFactor(0.9)
                        .lineLimit(1)
                    
                    Text(concert.venueName)
                        .font(.system(size: 17, type: .Regular))
                        .foregroundStyle(.gray3)
                        .minimumScaleFactor(0.9)
                        .lineLimit(1)
                    
                    Text(concert.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 17, type: .Regular))
                        .foregroundStyle(.gray3)
                        .minimumScaleFactor(0.9)
                        .lineLimit(1)
                }
                .padding(15)
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width - 30)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.foreground)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .matchedTransitionSource(id: id, in: namespace)
    }
}

#Preview {
    NavigationStack {
        VStack {
            Spacer()
            NearbyConcertCard(concert: hotConcerts[0])
                .shadow(color: .black.opacity(0.2), radius: 5)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
    }
    
}
