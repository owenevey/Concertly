import SwiftUI

struct NearbyConcertCard: View {
    @EnvironmentObject var animationManager: AnimationManager
    
    var concert: Concert
    
    var body: some View {
        NavigationLink(value: ZoomConcertLink(concert: concert)) {
            HStack(spacing: 0) {
                ImageLoader(url: concert.imageUrl, contentMode: .fill)
                    .frame(width: 150, height: 120)
                    .clipped()
                                
                VStack(alignment: .leading, spacing: 5) {
                    Text(concert.artistName)
                        .font(.system(size: 20, type: .SemiBold))
                        .minimumScaleFactor(0.9)
                        .lineLimit(1)
                    
                    Text(concert.date.shortFormatWithYear(timeZoneIdentifier: concert.timezone))
                        .font(.system(size: 17, type: .Regular))
                        .foregroundStyle(.gray3)
                        .minimumScaleFactor(0.9)
                        .lineLimit(1)
                    
                    Text(concert.venueName)
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
            .matchedTransitionSource(id: concert.id, in: animationManager.animation) {
                $0
                    .background(.clear)
                    .clipShape(.rect(cornerRadius: 20))
            }
        }
        .buttonStyle(PlainButtonStyle())
//        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 20))
//        .contextMenu {
//            let isSaved = CoreDataManager.shared.isConcertSaved(id: concert.id)
//            if isSaved {
//                Button {
//                    CoreDataManager.shared.unSaveConcert(id: concert.id)
//                    NotificationManager.shared.removeConcertReminder(for: concert)
//                } label: {
//                    Label("Remove from saved", systemImage: "xmark")
//                }
//            }
//            else {
//                Button {
//                    CoreDataManager.shared.saveConcert(concert)
//                    let concertRemindersPreference = UserDefaults.standard.integer(forKey: AppStorageKeys.concertReminders.rawValue)
//                    
//                    if concertRemindersPreference != 0 {
//                        NotificationManager.shared.scheduleConcertReminder(for: concert, daysBefore: concertRemindersPreference)
//                    }
//                } label: {
//                    Label("Save", systemImage: "bookmark.fill")
//                }
//            }
//        }
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
