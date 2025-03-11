import Foundation
import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var followingArtists: [SuggestedArtist] = []
        
    init() {
        getFollowingArtists()
    }
    
    func getFollowingArtists() {
        followingArtists = CoreDataManager.shared.fetchItems(for: ContentCategories.following.rawValue, type: SuggestedArtist.self)
    }
    
}
