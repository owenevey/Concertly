import Foundation
import SwiftUI

@MainActor
final class ExploreViewModel: ObservableObject {
    @Published var trendingConcertsResponse: ApiResponse<[Concert]> = ApiResponse<[Concert]>()
    @Published var trendingConcerts: [Concert] = []
    
    @Published var popularArtistsResponse: ApiResponse<[SuggestedArtist]> = ApiResponse<[SuggestedArtist]>()
    @Published var popularArtists: [SuggestedArtist] = []
    
    @Published var nearbyConcertsResponse: ApiResponse<[Concert]> = ApiResponse<[Concert]>()
    @Published var nearbyConcerts: [Concert] = []
    
    @Published var popularDestinationsResponse: ApiResponse<[Destination]> = ApiResponse<[Destination]>()
    @Published var popularDestinations: [Destination] = []
    
    @Published var featuredEventResponse: ApiResponse<Concert> = ApiResponse<Concert>()
    @Published var featuredEvent: Concert?
    
    @Published var suggestedConcertsResponse: ApiResponse<[Concert]> = ApiResponse<[Concert]>()
    @Published var suggestedConcerts: [Concert] = []
    
    @Published var famousVenuesResponse: ApiResponse<[Venue]> = ApiResponse<[Venue]>()
    @Published var famousVenues: [Venue] = []
    
    func getTrendingConcerts() async {
        withAnimation(.easeInOut(duration: 0.1)) {
            self.trendingConcertsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedConcerts = try await fetchConcerts(category: "explore_trending")
            
            if let concerts = fetchedConcerts.data?.concerts {
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.trendingConcerts = concerts
                    self.trendingConcertsResponse = ApiResponse(status: .success, data: concerts)
                }
            } else {
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.trendingConcertsResponse = ApiResponse(status: .error, error: "Couldn't fetch concerts")
                }
            }
        } catch {
            withAnimation(.easeInOut(duration: 0.1)) {
                self.trendingConcertsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getSuggestedConcerts() async {
        withAnimation(.easeInOut(duration: 0.1)) {
            self.suggestedConcertsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedConcerts = try await fetchConcerts(category: "explore_suggested")
            
            if let concerts = fetchedConcerts.data?.concerts {
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.suggestedConcerts = concerts
                    self.suggestedConcertsResponse = ApiResponse(status: .success, data: concerts)
                }
            } else {
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.suggestedConcertsResponse = ApiResponse(status: .error, error: "Couldn't fetch concerts")
                }
            }
        } catch {
            withAnimation(.easeInOut(duration: 0.1)) {
                self.suggestedConcertsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getPopularArtists() async {
        withAnimation(.easeInOut(duration: 0.1)) {
            self.popularArtistsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedArtists = try await fetchPopularArtists(category: "explore")
            
            if let artists = fetchedArtists.data?.artists {
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.popularArtists = artists
                    self.popularArtistsResponse = ApiResponse(status: .success, data: artists)
                }
            } else {
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.popularArtistsResponse = ApiResponse(status: .error, error: "Couldn't fetch artists")
                }
            }
        } catch {
            withAnimation(.easeInOut(duration: 0.1)) {
                self.popularArtistsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getNearbyConcerts() async {
        withAnimation(.easeInOut(duration: 0.1)) {
            self.nearbyConcertsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedConcerts = try await fetchNearbyConcerts()
            withAnimation(.easeInOut(duration: 0.1)) {
                self.nearbyConcerts = fetchedConcerts.concerts
                self.nearbyConcertsResponse = ApiResponse(status: .success, data: fetchedConcerts.concerts)
            }
        } catch {
            print("Error fetching nearby concerts: \(error)")
            withAnimation(.easeInOut(duration: 0.1)) {
                self.nearbyConcertsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getPopularDestinations() async {
        withAnimation(.easeInOut(duration: 0.1)) {
            self.popularDestinationsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedDestinations = try await fetchPopularDestinations()
            withAnimation(.easeInOut(duration: 0.1)) {
                self.popularDestinations = fetchedDestinations.destinations
                self.popularDestinationsResponse = ApiResponse(status: .success, data: fetchedDestinations.destinations)
            }
        } catch {
            print("Error fetching popular destinations: \(error)")
            withAnimation(.easeInOut(duration: 0.1)) {
                self.popularDestinationsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getFeaturedEvent() async {
        withAnimation(.easeInOut(duration: 0.1)) {
            self.featuredEventResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedEvent = try await fetchFeaturedEvent()
            withAnimation(.easeInOut(duration: 0.1)) {
                self.featuredEvent = fetchedEvent.event
                self.featuredEventResponse = ApiResponse(status: .success, data: fetchedEvent.event)
            }
        } catch {
            print("Error fetching featured event: \(error)")
            withAnimation(.easeInOut(duration: 0.1)) {
                self.featuredEventResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getFamousVenues() async {
        withAnimation(.easeInOut(duration: 0.1)) {
            self.famousVenuesResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedVenues = try await fetchFamousVenues()
            withAnimation(.easeInOut(duration: 0.1)) {
                self.famousVenues = fetchedVenues.venues
                self.famousVenuesResponse = ApiResponse(status: .success, data: fetchedVenues.venues)
            }
        } catch {
            print("Error fetching famous venues: \(error)")
            withAnimation(.easeInOut(duration: 0.1)) {
                self.famousVenuesResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
}
