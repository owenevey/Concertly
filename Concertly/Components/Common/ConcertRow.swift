import Foundation
import SwiftUI
import FirebaseAnalytics

struct ConcertRow: View {
    
    var concert: Concert
    var screen: ConcertScreenType
    
    var title: String {
        switch screen {
        case .artist:
            return concert.cityName
        case .destination:
            return concert.artistName
        case .venue:
            return concert.artistName
        }
    }
    
    var subtitle: String {
        switch screen {
        case .artist:
            return  concert.venueName
        case .destination:
            return concert.venueName
        case .venue:
            return concert.names[0]
        }
    }
    
    var body: some View {
        HStack(spacing: 15) {
            VStack {
                Text(concert.date.shortMonthFormat(timeZoneIdentifier: concert.timezone))
                    .font(.system(size: 16, type: .Medium))
                    .foregroundStyle(.gray3)
                Text(concert.date.dayNumber(timeZoneIdentifier: concert.timezone))
                    .font(.system(size: 23, type: .Medium))
            }
            .frame(width: 60, height: 60)
            .background(Color.background)
            .cornerRadius(10)
            
            VStack {
                Text(title)
                    .font(.system(size: 18, type: .Medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                
                Text(subtitle)
                    .font(.system(size: 16, type: .Medium))
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 15))
                .fontWeight(.semibold)
                .padding(.trailing)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(5)
        .background(Color.gray1)
        .cornerRadius(15)
        .simultaneousGesture(TapGesture().onEnded {
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemID: "id-\(concert.id)",
                AnalyticsParameterItemName: "\(concert.artistName), \(concert.names.first ?? "no name")",
              AnalyticsParameterContentType: "cont",
            ])
        })
    }
}

enum ConcertScreenType {
    case artist
    case venue
    case destination
}

#Preview {
    ConcertRow(concert: hotConcerts[0], screen: .artist)
        .padding()
}
