import Foundation
import SwiftUI

@MainActor
final class GenreViewModel: ObservableObject {
    var genre: MusicGenre
    
    init(genre: MusicGenre) {
        self.genre = genre
    }
    
    @Published var trendingConcertsResponse: ApiResponse<[Concert]> = ApiResponse<[Concert]>()
    @Published var trendingConcerts: [Concert] = []
    
    @Published var popularArtistsResponse: ApiResponse<[SuggestedArtist]> = ApiResponse<[SuggestedArtist]>()
    @Published var popularArtists: [SuggestedArtist] = []
    
    @Published var featuredEventResponse: ApiResponse<Concert> = ApiResponse<Concert>()
    @Published var featuredEvent: Concert?
    
    @Published var suggestedConcertsResponse: ApiResponse<[Concert]> = ApiResponse<[Concert]>()
    @Published var suggestedConcerts: [Concert] = []
    
    
    func getTrendingConcerts() async {
        withAnimation(.easeInOut(duration: 0.1)) {
            self.trendingConcertsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let category = genre.apiLabel + "_trending"
            let fetchedConcerts = try await fetchConcerts(category: category)
            
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
            let category = genre.title.lowercased() + "_suggested"
            let fetchedConcerts = try await fetchConcerts(category: category)
            
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
            let category = genre.title.lowercased()
            let fetchedArtists = try await fetchPopularArtists(category: category)
            
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
    
    func getFeaturedEvent() async {
        withAnimation(.easeInOut(duration: 0.1)) {
            self.featuredEventResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedEvent = try await fetchFeaturedEvent(genre: genre.title)
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

}

