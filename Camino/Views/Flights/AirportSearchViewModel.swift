import SwiftUI
import Combine

@MainActor
class AirportSearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var airportsResponse: ApiResponse<AirportSearchResponse> = ApiResponse<AirportSearchResponse>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard !query.isEmpty else {
                    self?.airportsResponse = ApiResponse(status: .empty)
                    return
                }
                Task {
                    await self?.getSuggestedAirports()
                }
            }
            .store(in: &cancellables)
    }
    
    func getSuggestedAirports() async {
        withAnimation(.easeInOut) {
            self.airportsResponse = ApiResponse(status: .loading)
        }
    
        do {
            let fetchedAirports = try await fetchAirportSearchResults(query: searchQuery)
            
            withAnimation(.easeInOut) {
                self.airportsResponse = ApiResponse(status: .success, data: fetchedAirports)
            }
            
        } catch {
            print("Error fetching airports: \(error)")
            withAnimation(.easeInOut) {
                self.airportsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
            
        }
    }
}
