import SwiftUI

struct NotificationSelectionView: View {
    
    private let notificationManager = NotificationManager.shared
    
    @AppStorage(AppStorageKeys.selectedNotificationPref.rawValue) private var selectedNotificationPref = false
    
    private func onTapDone(isNotificationsEnabled: Bool) {
        selectedNotificationPref = true
        UserDefaults.standard.set(isNotificationsEnabled ? 1 : 0, forKey: AppStorageKeys.concertReminders.rawValue)
        UserDefaults.standard.set(isNotificationsEnabled, forKey: AppStorageKeys.newTourDates.rawValue)
    }
    
    
    var body: some View {
        VStack(spacing: 20) {
            Image(.sza)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 250)
                .clipped()
                .padding(.bottom, 30)
            
            Text("Never miss out.")
                .font(.system(size: 25, type: .SemiBold))
            
            Text("We'll notify you when your favorite artists announce new dates, or when you want concert reminders.")
                .font(.system(size: 17, type: .Regular))
                .padding(.horizontal, 30)
                .multilineTextAlignment(.center)
            
            ConcertlyButton(label: "Notify me") {
                notificationManager.requestPermission(completion: onTapDone)
            }
            .frame(width: 200)
            
            Button {
                onTapDone(isNotificationsEnabled: false)
            } label: {
                Text("No thanks")
                    .font(.system(size: 17, type: .Regular))
                    .foregroundStyle(.gray3)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .navigationBarHidden(true)
        .disableSwipeBack(true)
    }
}

#Preview {
    NotificationSelectionView()
}
