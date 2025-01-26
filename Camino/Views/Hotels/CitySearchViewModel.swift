import SwiftUI
import Combine

@MainActor
class CitySearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var citiesResponse: ApiResponse<[SuggestedCity]> = ApiResponse<[SuggestedCity]>()
    
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
        withAnimation(.easeInOut(duration: 0.2)) {
            self.citiesResponse = ApiResponse(status: .loading)
        }
    
        do {
            let fetchedCities = try await fetchCitySearchResults(query: searchQuery)
            
            if let cities = fetchedCities.data?.suggestedCities {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.citiesResponse = ApiResponse(status: .success, data: cities)
                }
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.citiesResponse = ApiResponse(status: .error, error: "Couldn't fetch cities")
                }
            }
            
        } catch {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.citiesResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
}
