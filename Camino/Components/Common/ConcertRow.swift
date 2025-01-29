import Foundation
import SwiftUI

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
            return concert.name[0]
        }
    }
    
    var body: some View {
        HStack(spacing: 15) {
            VStack {
                Text(concert.date.dayNumber())
                    .font(.system(size: 23, type: .Medium))
                Text(concert.date.shortMonthFormat())
                    .font(.system(size: 16, type: .Medium))
                    .foregroundStyle(.gray3)
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
    }
}

enum ConcertScreenType {
    case artist
    case venue
    case destination
}

#Preview {
    ConcertRow(concert: hotConcerts[0], screen: .artist)
}
