import SwiftUI

struct SavedConcertCard: View {
    @Namespace private var namespace
    let id = "UIElement"
    
    var concert: Concert
    
    var body: some View {
        NavigationLink {
            ConcertView(concert: concert)
                .navigationTransition(.zoom(sourceID: id, in: namespace))
        }
        label: {
            VStack(alignment: .leading, spacing: 0) {
                ImageLoader(url: concert.imageUrl, contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 30, height: 170)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(concert.artistName)
                        .font(.system(size: 20, type: .SemiBold))
                        .minimumScaleFactor(0.9)
                        .lineLimit(1)
                    
                    HStack {
                        Text(concert.cityName)
                            .font(.system(size: 17, type: .Regular))
                            .foregroundStyle(.gray3)
                            .minimumScaleFactor(0.9)
                            .lineLimit(1)
                        
                        Text("|")
                            .font(.system(size: 17, type: .Regular))
                            .foregroundStyle(.gray3)
                        
                        Text(concert.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.system(size: 17, type: .Regular))
                            .foregroundStyle(.gray3)
                            .minimumScaleFactor(0.9)
                            .lineLimit(1)
                    }
                    
                    Divider()
                        .frame(height: 2)
                        .padding(.vertical, 5)
                    
                    HStack {
                        HStack {
                            Circle()
                                .fill(.accent)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Image(systemName: "airplane")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.white)
                                        .fontWeight(.semibold)
                                )
                            Text("$654")
                                .font(.system(size: 18, type: .Medium))
                        }
                        
                        Spacer()
                        
                        HStack {
                            Circle()
                                .fill(.accent)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Image(systemName: "bed.double.fill")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.white)
                                        .fontWeight(.semibold)
                                )
                            Text("$318")
                                .font(.system(size: 18, type: .Medium))
                        }
                        
                        Spacer()
                        
                        HStack {
                            Circle()
                                .fill(.accent)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Image(systemName: "ticket.fill")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.white)
                                        .fontWeight(.semibold)
                                )
                            Text("View")
                                .font(.system(size: 18, type: .Medium))
                        }
                    }
                }
                .padding(15)
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
        SavedConcertCard(concert: hotConcerts[0])
            .shadow(color: .black.opacity(0.2), radius: 5)
            .padding(15)
    }
}
