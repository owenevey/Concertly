import SwiftUI

struct CustomTabItem: View {
    
    var imageName: String
    var isActive: Bool
    
    var body: some View{
        Image(systemName: isActive ? "\(imageName).fill" : imageName)
            .resizable()
            .foregroundColor(isActive ? .white : .accentColor)
            .frame(width: 23, height: 23)
            .frame(width: 80, height: 50)
            .background(isActive ? .accent : .clear)
            .cornerRadius(25)
    }
}

enum TabbedItems: Int, CaseIterable {
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
