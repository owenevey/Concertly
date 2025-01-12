import SwiftUI
import Combine

@MainActor
class ExploreSearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var artistsResponse: ApiResponse<ArtistSearchResponse> = ApiResponse<ArtistSearchResponse>()
    
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
        withAnimation(.easeInOut) {
            self.artistsResponse = ApiResponse(status: .loading)
        }
    
        do {
            let fetchedArtists = try await fetchArtistSearchResults(query: searchQuery)
            
            withAnimation(.easeInOut) {
                self.artistsResponse = ApiResponse(status: .success, data: fetchedArtists)
            }
            
        } catch {
            print("Error fetching search results: \(error)")
            withAnimation(.easeInOut) {
                self.artistsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
            
        }
    }
}
