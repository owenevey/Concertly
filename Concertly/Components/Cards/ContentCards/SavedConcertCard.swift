import SwiftUI

struct SavedConcertCard: View {
    @EnvironmentObject var animationManager: AnimationManager
    
    var concert: Concert
    
    var body: some View {
        NavigationLink(value: ZoomConcertLink(concert: concert)) {
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
                        
                        Text(concert.date.shortFormatWithYear(timeZoneIdentifier: concert.timezone))
                            .font(.system(size: 17, type: .Regular))
                            .foregroundStyle(.gray3)
                            .minimumScaleFactor(0.9)
                            .lineLimit(1)
                    }
                    
                    Divider()
                        .frame(height: 1)
                        .overlay(.gray2)
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
                            if let flightsPrice = concert.flightsPrice, flightsPrice != -1 {
                                Text(flightsPrice.asDollarString)
                                    .font(.system(size: 18, type: .Medium))
                            } else {
                                Text("View")
                                    .font(.system(size: 18, type: .Medium))
                            }
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
                            if let hotelsPrice = concert.hotelsPrice, hotelsPrice != -1 {
                                Text(hotelsPrice.asDollarString)
                                    .font(.system(size: 18, type: .Medium))
                            } else {
                                Text("View")
                                    .font(.system(size: 18, type: .Medium))
                            }
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
                .padding([.horizontal, .bottom], 15)
                .padding(.top, 10)
            }
            .frame(width: UIScreen.main.bounds.width - 30)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.foreground)
            )
            .matchedTransitionSource(id: concert.id, in: animationManager.animation) {
                $0
                    .background(.clear)
                    .clipShape(.rect(cornerRadius: 20))
            }
        }
        .buttonStyle(PlainButtonStyle())
//        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 20))
//        .contextMenu {
//            Button {
//                CoreDataManager.shared.unSaveConcert(id: concert.id)
//                NotificationManager.shared.removeConcertReminder(for: concert)
//            } label: {
//                Label("Remove from saved", systemImage: "xmark")
//            }
//        }
    }
}

#Preview {
    NavigationStack {
        VStack {
            Spacer()
            SavedConcertCard(concert: hotConcerts[0])
                .shadow(color: .black.opacity(0.2), radius: 5)
                .padding(15)
            Spacer()
        }
        .background(Color.background)
    }
}
