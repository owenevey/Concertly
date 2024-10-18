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
                .frame(width: 250, height: 150)
                .clipped()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(concert.name)
                        .font(Font.custom("Barlow-Bold", size: 20))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    Text(concert.generalLocation)
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
                .padding(15)
            }
            .frame(width: 250)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.card)
                    .shadow(color: .black.opacity(0.2), radius: 5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack {
        ConcertCard(concert: hotConcerts[0])
    }
}
