import SwiftUI

struct ConcertCard: View {
    @Namespace private var namespace
    let id = "UIElement"
    
    
    var concert: Concert
    
    var body: some View {
        NavigationLink {
            ConcertView(concert: concert)
                .navigationBarHidden(true)
                .navigationTransition(.zoom(sourceID: id, in: namespace))
        }
        label: {
            VStack(alignment: .leading, spacing: 0) {
                AsyncImage(url: URL(string: concert.imageUrl)) { image in
                    image
                        .resizable()
                } placeholder: {
                    Color.foreground
                        .frame(width: 250, height: 250)
                }
                .scaledToFill()
                .frame(width: 250, height: 150)
                .clipped()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(concert.artistName)
                        .font(.system(size: 20, type: .SemiBold))
//                        .minimumScaleFactor(0.75)
                        .lineLimit(1)
                    
                    Text(concert.cityName)
                        .font(.system(size: 16, type: .Regular))
                        .foregroundStyle(.gray3)
//                        .minimumScaleFactor(0.75)
                        .lineLimit(1)
                    
                    Text(concert.dateTime.formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 16, type: .Regular))
                        .foregroundStyle(.gray3)
                        .minimumScaleFactor(0.75)
                        .lineLimit(1)
                    
                }
                .padding(15)
            }
            .frame(width: 250)
//            .frame(height: 250)
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
        ConcertCard(concert: hotConcerts[0])
            .shadow(color: .black.opacity(0.2), radius: 5)
    }
}
