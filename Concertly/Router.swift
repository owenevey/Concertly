import SwiftUI

class Router: ObservableObject {
    @Published var explorePath = NavigationPath()
    @Published var nearbyPath = NavigationPath()
    @Published var savedPath = NavigationPath()
    @Published var profilePath = NavigationPath()
    
    @Published var selectedTab: Int = 0
    
    func push(_ value: String, tab: String) {
        switch tab {
        case "Explore":
            explorePath.append(value)
        case "Nearby":
            nearbyPath.append(value)
        case "Saved":
            savedPath.append(value)
        case "Profile":
            profilePath.append(value)
        default:
            break
        }
    }
    
    func pushMultiple(_ values: [String], tab: String) {
        for value in values {
            push(value, tab: tab)
        }
    }
    
    func pop(tab: String) {
        switch tab {
        case "Explore":
            if !explorePath.isEmpty { explorePath.removeLast() }
        case "Nearby":
            if !nearbyPath.isEmpty { nearbyPath.removeLast() }
        case "Saved":
            if !savedPath.isEmpty { savedPath.removeLast() }
        case "Profile":
            if !profilePath.isEmpty { profilePath.removeLast() }
        default:
            break
        }
    }
    
    func popToRoot(tab: String) {
        switch tab {
        case "Explore":
            explorePath.removeLast(explorePath.count)
        case "Nearby":
            nearbyPath.removeLast(nearbyPath.count)
        case "Saved":
            savedPath.removeLast(savedPath.count)
        case "Profile":
            profilePath.removeLast(profilePath.count)
        default:
            break
        }
    }
}
