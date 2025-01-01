import SwiftUI
import Combine

@MainActor
class CitySearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var citiesResponse: ApiResponse<CitySearchResponse> = ApiResponse<CitySearchResponse>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard !query.isEmpty else {
                    self?.citiesResponse = ApiResponse(status: .empty)
                    return
                }
                Task {
                    await self?.getSuggestedCities()
                }
            }
            .store(in: &cancellables)
    }
    
    func getSuggestedCities() async {
        withAnimation(.easeInOut) {
            self.citiesResponse = ApiResponse(status: .loading)
        }
    
        do {
            let fetchedCities = try await fetchCitySearchResults(query: searchQuery)
            
            withAnimation(.easeInOut) {
                self.citiesResponse = ApiResponse(status: .success, data: fetchedCities)
            }
            
        } catch {
            print("Error fetching cities: \(error)")
            withAnimation(.easeInOut) {
                self.citiesResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
            
        }
    }
}
