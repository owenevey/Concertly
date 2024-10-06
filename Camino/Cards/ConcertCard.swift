import SwiftUI

struct ConcertCard: View {
    
    
    var concert: Concert
    
    var body: some View {
        NavigationLink{
            ConcertView(concert: concert)
                .navigationBarHidden(true)
        }
        label: {
            VStack(alignment: .leading, spacing: 0) {
                AsyncImage(url: URL(string: concert.imageUrl)) { image in
                    image
                        .resizable()
                } placeholder: {
                    Image(systemName: "photo.fill")
                }
                .scaledToFill()
                .frame(width: 234, height: 150)
                .cornerRadius(17)
                .clipped()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(concert.name)
                        .font(Font.custom("Barlow-Bold", size: 20))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    Text(concert.venue.country)
                        .font(Font.custom("Barlow-SemiBold", size: 16))
                        .foregroundStyle(.gray)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    Text(concert.dateTime.formatted(date: .abbreviated, time: .omitted))
                        .font(Font.custom("Barlow-SemiBold", size: 16))
                        .foregroundStyle(.gray)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                }
                .padding(10)
            }
            .padding(8)
            .frame(width: 250)
            .background (
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color("Card"))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ConcertCard(concert: hotConcerts[0])
}
