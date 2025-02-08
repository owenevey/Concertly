import Foundation
import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var followingArtists: [SuggestedArtist] = []
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        followingArtists = coreDataManager.fetchItems(for: "following", type: SuggestedArtist.self, sortKey: "id")

        getFollowingArtists()
    }
    
    func getFollowingArtists() {
        followingArtists = coreDataManager.fetchItems(for: "following", type: SuggestedArtist.self, sortKey: "id")
    }
    
}
