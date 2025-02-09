import SwiftUI
import Combine

@MainActor
class ExploreSearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var artistsResponse: ApiResponse<[SuggestedArtist]> = ApiResponse<[SuggestedArtist]>()
    
    @Published var recentSearches: [SuggestedArtist] = []
    
    private let coreDataManager = CoreDataManager.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {        
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard !query.isEmpty else {
                    self?.artistsResponse = ApiResponse(status: .empty)
                    return
                }
                Task {
                    await self?.getSuggestedArtists()
                }
            }
            .store(in: &cancellables)
    }
    
    func getSuggestedArtists() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.artistsResponse = ApiResponse(status: .loading)
        }
    
        do {
            let fetchedArtists = try await fetchArtistSearchResults(query: searchQuery)
            
            if let artists = fetchedArtists.data?.suggestedArtists {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.artistsResponse = ApiResponse(status: .success, data: artists)
                }
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.artistsResponse = ApiResponse(status: .error, error: "Couldn't fetch artists")
                }
            }
            
        } catch {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.artistsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getFollowingArtists() {
        recentSearches = coreDataManager.fetchItems(for: "recentSearches", type: SuggestedArtist.self, sortKey: "creationDate")
    }
    
    func saveArtistToRecentSearches(artist: SuggestedArtist) {
        coreDataManager.unSaveArtist(id: artist.id, category: "recentSearches")
        coreDataManager.saveArtist(artist, category: "recentSearches")
    }
}
