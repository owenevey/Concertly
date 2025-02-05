import Foundation
import SwiftUI

@MainActor
final class ExploreViewModel: ObservableObject {
    private let coreDataManager = CoreDataManager.shared
    
    @Published var trendingConcertsResponse: ApiResponse<[Concert]> = ApiResponse<[Concert]>()
    @Published var trendingConcerts: [Concert] = []
    
    @Published var popularArtistsResponse: ApiResponse<[SuggestedArtist]> = ApiResponse<[SuggestedArtist]>()
    @Published var popularArtists: [SuggestedArtist] = []
    
    @Published var popularDestinationsResponse: ApiResponse<[Destination]> = ApiResponse<[Destination]>()
    @Published var popularDestinations: [Destination] = []
    
    @Published var featuredConcertResponse: ApiResponse<Concert> = ApiResponse<Concert>()
    @Published var featuredConcert: Concert?
    
    @Published var suggestedConcertsResponse: ApiResponse<[Concert]> = ApiResponse<[Concert]>()
    @Published var suggestedConcerts: [Concert] = []
    
    @Published var famousVenuesResponse: ApiResponse<[Venue]> = ApiResponse<[Venue]>()
    @Published var famousVenues: [Venue] = []
    
    init() {
        trendingConcerts = coreDataManager.fetchItems(for: "explore_trending")
        featuredConcert = coreDataManager.fetchItems(for: "explore_featured").first
        suggestedConcerts = coreDataManager.fetchItems(for: "explore_suggested")
    }
    
    func getTrendingConcerts() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.trendingConcertsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedConcerts = try await fetchConcerts(category: "explore_trending")
            
            if let concerts = fetchedConcerts.data?.concerts {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.trendingConcerts = concerts
                    self.trendingConcertsResponse = ApiResponse(status: .success, data: concerts)
                }
                coreDataManager.saveItems(concerts, category: "explore_trending")
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.trendingConcertsResponse = ApiResponse(status: .error, error: "Couldn't fetch concerts")
                }
            }
        } catch {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.trendingConcertsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getSuggestedConcerts() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.suggestedConcertsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedConcerts = try await fetchConcerts(category: "explore_suggested")
            
            if let concerts = fetchedConcerts.data?.concerts {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.suggestedConcerts = concerts
                    self.suggestedConcertsResponse = ApiResponse(status: .success, data: concerts)
                }
                coreDataManager.saveItems(concerts, category: "explore_suggested")
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.suggestedConcertsResponse = ApiResponse(status: .error, error: "Couldn't fetch concerts")
                }
            }
        } catch {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.suggestedConcertsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getPopularArtists() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.popularArtistsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedArtists = try await fetchPopularArtists(category: "explore")
            
            if let artists = fetchedArtists.data?.artists {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.popularArtists = artists
                    self.popularArtistsResponse = ApiResponse(status: .success, data: artists)
                }
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.popularArtistsResponse = ApiResponse(status: .error, error: "Couldn't fetch artists")
                }
            }
        } catch {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.popularArtistsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getFeaturedConcert() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.featuredConcertResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedConcert = try await fetchFeaturedConcert(category: "explore")
            
            if let concert = fetchedConcert.data?.concert {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.featuredConcert = concert
                    self.featuredConcertResponse = ApiResponse(status: .success, data: concert)
                }
                coreDataManager.saveItems([concert], category: "explore_featured")
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.featuredConcertResponse = ApiResponse(status: .error, error: "Couldn't fetch concert")
                }
            }
        } catch {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.featuredConcertResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getPopularDestinations() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.popularDestinationsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedDestinations = try await fetchPopularDestinations()
            
            if let destinations = fetchedDestinations.data?.destinations {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.popularDestinations = destinations
                    self.popularDestinationsResponse = ApiResponse(status: .success, data: destinations)
                }
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.popularDestinationsResponse = ApiResponse(status: .error, error: "Couldn't fetch destinations")
                }
            }
        } catch {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.popularDestinationsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getFamousVenues() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.famousVenuesResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedDestinations = try await fetchFamousVenues()
            
            if let venues = fetchedDestinations.data?.venues {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.famousVenues = venues
                    self.famousVenuesResponse = ApiResponse(status: .success, data: venues)
                }
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.famousVenuesResponse = ApiResponse(status: .error, error: "Couldn't fetch venues")
                }
            }
        } catch {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.famousVenuesResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
}
