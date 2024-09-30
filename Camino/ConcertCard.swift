import SwiftUI

struct ConcertCard: View {
    
    var concert: ogConcert
    
    var body: some View {
        
        NavigationLink{
            Text(concert.artist)
        }
        label: {
            VStack(alignment: .leading, spacing: 0) {
                Image(concert.artistPhoto)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 234, height: 150)
                    .cornerRadius(17)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(concert.artist)
                        .font(Font.custom("Barlow-Bold", size: 20))
                        .lineLimit(1)
                    
                    Text("\(concert.location), \(concert.country)")
                        .font(Font.custom("Barlow-SemiBold", size: 16))
                        .foregroundStyle(.gray)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    Text(concert.date)
                        .font(Font.custom("Barlow-SemiBold", size: 16))
                        .foregroundStyle(.gray)
                    
                }
                .padding(10)
            }
            .padding(8)
            .frame(width: 250)
            
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color("Card"))
            )
        }.buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ConcertCard(concert: trendingConcerts[0])
}
