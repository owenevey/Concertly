import SwiftUI

struct CustomTabItem: View {
    var imageName: String
    var isActive: Bool
    var body: some View{
        HStack(spacing: 10){
            Spacer()
            Image(systemName: isActive ? "\(imageName).fill" : imageName)
                .resizable()
                .foregroundColor(isActive ? .white : .accentColor)
                .frame(width: 23, height: 23)
            Spacer()
        }
        .frame(width: 90, height: 60)
        .background(isActive ? Color("AccentColor").opacity(0.6) : .clear)
        .cornerRadius(30)
    }
}


enum TabbedItems: Int, CaseIterable{
    case explore = 0
    case trips
    case profile
    
    var iconName: String{
        switch self {
        case .explore:
            return "globe.europe.africa"
        case .trips:
            return "map"
        case .profile:
            return "person"
        }
    }
}
