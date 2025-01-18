import Foundation
import SwiftUI

@MainActor
final class ExploreViewModel: ObservableObject {
    @Published var trendingConcertsResponse: ApiResponse<[Concert]> = ApiResponse<[Concert]>()
    @Published var trendingConcerts: [Concert] = []
    
    @Published var popularArtistsResponse: ApiResponse<[SuggestedArtist]> = ApiResponse<[SuggestedArtist]>()
    @Published var popularArtists: [SuggestedArtist] = []
    
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
            let fetchedConcerts = try await fetchSuggestedConcerts()
            withAnimation(.easeInOut(duration: 0.1)) {
                self.trendingConcerts = fetchedConcerts.concerts
                self.trendingConcertsResponse = ApiResponse(status: .success, data: fetchedConcerts.concerts)
            }
        } catch {
            print("Error fetching trending concerts: \(error)")
            withAnimation(.easeInOut(duration: 0.1)) {
                self.trendingConcertsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getPopularArtists() async {
        withAnimation(.easeInOut(duration: 0.1)) {
            self.popularArtistsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedArtists = try await fetchPopularArtists()
            withAnimation(.easeInOut(duration: 0.1)) {
                self.popularArtists = fetchedArtists.artists
                self.popularArtistsResponse = ApiResponse(status: .success, data: fetchedArtists.artists)
            }
        } catch {
            print("Error fetching popular artists: \(error)")
            withAnimation(.easeInOut(duration: 0.1)) {
                self.popularArtistsResponse = ApiResponse(status: .error, error: error.localizedDescription)
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

    func getSuggestedConcerts() async {
        withAnimation(.easeInOut(duration: 0.1)) {
            self.suggestedConcertsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedConcerts = try await fetchSuggestedConcerts()
            withAnimation(.easeInOut(duration: 0.1)) {
                self.suggestedConcerts = fetchedConcerts.concerts.reversed()
                self.suggestedConcertsResponse = ApiResponse(status: .success, data: fetchedConcerts.concerts)
            }
        } catch {
            print("Error fetching suggested concerts: \(error)")
            withAnimation(.easeInOut(duration: 0.1)) {
                self.suggestedConcertsResponse = ApiResponse(status: .error, error: error.localizedDescription)
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
