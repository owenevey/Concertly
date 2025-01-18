import Foundation
import SwiftUI

struct ConcertRow: View {
    
    var concert: Concert
    var screen: String
    
    var title: String {
        if screen == "artist" {
            return concert.cityName
        } else if screen == "destination" {
            return concert.artistName
        } else if screen == "venue" {
            return concert.artistName
        }
        return ""
    }
    
    var subtitle: String {
        if screen == "artist" {
            return concert.venueName
        } else if screen == "destination" {
            return concert.name
        } else if screen == "venue" {
            return concert.name
        }
        return ""
    }
    
    var body: some View {
        HStack(spacing: 15) {
            VStack {
                Text(concert.dateTime.dayNumber())
                    .font(.system(size: 23, type: .Medium))
                Text(concert.dateTime.shortMonthFormat())
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
                    .minimumScaleFactor(0.75)
                
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

#Preview {
    ConcertRow(concert: hotConcerts[0], screen: "artist")
}
