import SwiftUI

struct NotificationSelectionView: View {
        
    private let notificationManager = NotificationManager.shared
    
    @AppStorage(AppStorageKeys.selectedNotificationPref.rawValue) private var selectedNotificationPref = false
    @AppStorage(AppStorageKeys.authStatus.rawValue) private var authStatus = AuthStatus.guest
    
    private func onTapDone(isNotificationsEnabled: Bool) {
        selectedNotificationPref = true
        UserDefaults.standard.set(true, forKey: AppStorageKeys.isPushNotificationsAuthorized.rawValue)
        UserDefaults.standard.set(isNotificationsEnabled ? 1 : 0, forKey: AppStorageKeys.concertReminders.rawValue)
    }
    
    
    var body: some View {
        VStack(spacing: 20) {
            Image(.kanyeOnPhone)
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 300)
                .cornerRadius(20)
                .clipped()
                .padding(.bottom, 10)
                
            Text("Never miss out.")
                .font(.system(size: 25, type: .SemiBold))
            
            Text("We'll notify you when your favorite artists announce new dates, or when you want concert reminders.")
                .font(.system(size: 17, type: .Regular))
                .padding(.horizontal, 30)
                .multilineTextAlignment(.center)
            
            ConcertlyButton(label: "Notify me") {
                if UserDefaults.standard.string(forKey: AppStorageKeys.pushNotificationToken.rawValue) != nil {
                    onTapDone(isNotificationsEnabled: true)
                    Task { await NotificationManager.shared.updateNewTourDateNotifications() }
                } else {
                    notificationManager.requestPermission(completion: onTapDone)
                }
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
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    NotificationSelectionView()
}
