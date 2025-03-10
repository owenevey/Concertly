import SwiftUI

struct NotificationRow: View {
    let notification: SavedNotification
    
    var imageString: String {
        if notification.type == "artist" {
            return "person.fill"
        } else {
            return "music.microphone"
        }
    }
    
    var titleString: String {
        if notification.type == "artist" {
            return "New Tour Dates"
        } else {
            return "Concert Reminder"
        }
    }
    
    var bodyString: String {
        if notification.type == "artist" {
            return "\(notification.artistName) announced new concerts"
        } else {
            return "\(notification.artistName) performs soon"
        }
    }
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: imageString)
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
            
            VStack {
                Text(titleString)
                    .font(.system(size: 17, type: .SemiBold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(bodyString)
                    .font(.system(size: 17, type: .Regular))
                    .lineLimit(2, reservesSpace: false)
                    .minimumScaleFactor(0.9)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(notification.date.shortFormat())
                    .font(.system(size: 15, type: .Regular))
                    .foregroundStyle(.gray3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 15))
                .fontWeight(.semibold)
                .padding(.trailing, 5)
        }
        .padding(15)
        .contentShape(Rectangle())
        .onTapGesture {
            if let url = URL(string: notification.deepLink) {
                DispatchQueue.main.async {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
}

#Preview {
    NavigationStack {
        VStack(spacing: 0) {
            Spacer()
            ForEach(0 ..< 5) { item in
                NotificationRow(notification: SavedNotification(type: ContentCategories.saved.rawValue, artistName: "Sabrina Carpenter", deepLink: "", date: Date()))
                Divider()
                    .padding(.horizontal)
            }
            Spacer()
        }
        .background(Color.background)
    }
}
