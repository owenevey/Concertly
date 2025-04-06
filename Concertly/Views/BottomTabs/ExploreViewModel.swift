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
    
    @Published var featuredConcertResponse: ApiResponse<Concert> = ApiResponse<Concert>()
    @Published var featuredConcert: Concert?
    
    @Published var suggestedConcertsResponse: ApiResponse<[Concert]> = ApiResponse<[Concert]>()
    @Published var suggestedConcerts: [Concert] = []
    
    @Published var similarConcertsResponse: ApiResponse<[Concert]> = ApiResponse<[Concert]>()
    @Published var similarConcerts: [Concert] = []
    @Published var similarConcertsArtist: String = ""
    
    @Published var famousVenuesResponse: ApiResponse<[Venue]> = ApiResponse<[Venue]>()
    @Published var famousVenues: [Venue] = []
    
    init() {
        trendingConcerts = CoreDataManager.shared.fetchItems(for: ContentCategories.exploreTrending.rawValue, type: Concert.self)
        popularArtists = CoreDataManager.shared.fetchItems(for: ContentCategories.explore.rawValue, type: SuggestedArtist.self)
        popularDestinations = CoreDataManager.shared.fetchItems(type: Destination.self)
        featuredConcert = CoreDataManager.shared.fetchItems(for: ContentCategories.exploreFeatured.rawValue, type: Concert.self).first
        suggestedConcerts = CoreDataManager.shared.fetchItems(for: ContentCategories.exploreSuggested.rawValue, type: Concert.self)
        famousVenues = CoreDataManager.shared.fetchItems(type: Venue.self)
        
        Task {
            await getTrendingConcerts()
            await getSimilarConcerts()
            await getPopularArtists()
            await getPopularDestinations()
            await getFeaturedConcert()
            await getSuggestedConcerts()
            await getFamousVenues()
        }
    }
    
    func getTrendingConcerts() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.trendingConcertsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedConcerts = try await fetchConcerts(category: ContentCategories.exploreTrending.rawValue)
            
            if let concerts = fetchedConcerts.data?.concerts {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.trendingConcerts = concerts
                    self.trendingConcertsResponse = ApiResponse(status: .success, data: concerts)
                    ImagePrefetcher.shared.startPrefetching(urls: concerts.prefix(5).compactMap{ URL(string: $0.imageUrl) })
                }
                
                CoreDataManager.shared.saveItems(concerts, category: ContentCategories.exploreTrending.rawValue)
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
    
    func getPopularArtists() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.popularArtistsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedArtists = try await fetchPopularArtists(category: ContentCategories.explore.rawValue)
            
            if let artists = fetchedArtists.data?.artists {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.popularArtists = artists
                    self.popularArtistsResponse = ApiResponse(status: .success, data: artists)
                    ImagePrefetcher.shared.startPrefetching(urls: artists.prefix(5).compactMap{ URL(string: $0.imageUrl) })
                }
                CoreDataManager.shared.saveItems(artists, category: ContentCategories.explore.rawValue)
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
    
    func getSimilarConcerts() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.similarConcertsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let followingArtists = getFollowingArtists()
            
            if followingArtists.count == 0 {
                return
            }
            
            let fetchedConcerts = try await fetchSimilarConcerts(followingArtists: followingArtists)
            
            if let concerts = fetchedConcerts.data?.concerts, let artist = fetchedConcerts.data?.name {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.similarConcerts = concerts
                    self.similarConcertsArtist = artist
                    self.similarConcertsResponse = ApiResponse(status: .success, data: concerts)
                }
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.similarConcertsResponse = ApiResponse(status: .error, error: "Couldn't fetch concerts")
                }
            }
        } catch {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.similarConcertsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getSuggestedConcerts() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.suggestedConcertsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedConcerts = try await fetchConcerts(category: ContentCategories.exploreSuggested.rawValue)
            
            if let concerts = fetchedConcerts.data?.concerts {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.suggestedConcerts = concerts
                    self.suggestedConcertsResponse = ApiResponse(status: .success, data: concerts)
                    ImagePrefetcher.shared.startPrefetching(urls: concerts.prefix(3).compactMap{ URL(string: $0.imageUrl) })
                }
                CoreDataManager.shared.saveItems(concerts, category: ContentCategories.exploreSuggested.rawValue)
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
    
    func getFeaturedConcert() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.featuredConcertResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedConcert = try await fetchFeaturedConcert(category: ContentCategories.explore.rawValue)
            
            if let concert = fetchedConcert.data?.concert {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.featuredConcert = concert
                    self.featuredConcertResponse = ApiResponse(status: .success, data: concert)
                    ImagePrefetcher.shared.startPrefetching(urls: [URL(string: concert.imageUrl)].compactMap { $0 })
                }
                CoreDataManager.shared.saveItems([concert], category: ContentCategories.exploreFeatured.rawValue)
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.featuredConcertResponse = ApiResponse(status: .error, error: "Couldn't fetch event")
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
                    ImagePrefetcher.shared.startPrefetching(urls: destinations.prefix(3).compactMap{ URL(string: $0.imageUrl) })
                }
                CoreDataManager.shared.saveItems(destinations)
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
                    ImagePrefetcher.shared.startPrefetching(urls: venues.prefix(3).compactMap{ URL(string: $0.imageUrl) })
                }
                CoreDataManager.shared.saveItems(venues)
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
    
    func getFollowingArtists() -> [SuggestedArtist] {
        return CoreDataManager.shared.fetchItems(for: ContentCategories.following.rawValue, type: SuggestedArtist.self, sortKey: "id")
    }
}
