import SwiftUI
import Combine

@MainActor
class AirportSearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var airportsResponse: ApiResponse<[SuggestedAirport]> = ApiResponse<[SuggestedAirport]>()
    
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
        withAnimation(.easeInOut(duration: 0.2)) {
            self.airportsResponse = ApiResponse(status: .loading)
        }
    
        do {
            let fetchedAirports = try await fetchAirportSearchResults(query: searchQuery)
            
            if let airports = fetchedAirports.data?.suggestedAirports {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.airportsResponse = ApiResponse(status: .success, data: airports)
                }
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.airportsResponse = ApiResponse(status: .error, error: "Couldn't fetch airports")
                }
            }
            
        } catch {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.airportsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
}
