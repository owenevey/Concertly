import SwiftUI

class Router: ObservableObject {
    @Published var explorePath = NavigationPath()
    @Published var nearbyPath = NavigationPath()
    @Published var savedPath = NavigationPath()
    @Published var profilePath = NavigationPath()
    
    @Published var selectedTab: Int = 0
        
    func push<T: Hashable>(_ value: T, tab: String) {
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
    
    func handleOpenUrl(url: URL) {
        guard url.scheme == "concertly" else { return }
        guard let host = url.host else { return }
        
        let pathComponents = url.pathComponents
        
        if host == "artist" {
            popToRoot(tab: "Explore")
            selectedTab = 0
            
            let navString = "\(host)/\(pathComponents[1])"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    self.push(navString, tab: "Explore")
                }
        }
        else if host == "saved" {
            popToRoot(tab: "Saved")
            selectedTab = 2
            
            let concertId = pathComponents[1]
            if let concert = CoreDataManager.shared.fetchSavedConcert(id: concertId) {
                push(concert, tab: "Saved")
            }
        }
    }
    
    func reset() {
        selectedTab = 0
        popToRoot(tab: "Explore")
        popToRoot(tab: "Nearby")
        popToRoot(tab: "Saved")
        popToRoot(tab: "Profile")
    }
}

enum Routes: String {
    case notifications
    case exploreSearch
    case homeCity
    case homeAirport
    case deleteAccount
    case login
    case register
}
