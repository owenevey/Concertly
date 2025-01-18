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
        withAnimation(.easeInOut) {
            self.trendingConcertsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedConcerts = try await fetchSuggestedConcerts(genre: genre.title)
            withAnimation(.easeInOut) {
                self.trendingConcerts = fetchedConcerts.concerts
                self.trendingConcertsResponse = ApiResponse(status: .success, data: fetchedConcerts.concerts)
            }
        } catch {
            print("Error fetching trending concerts: \(error)")
            withAnimation(.easeInOut) {
                self.trendingConcertsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getPopularArtists() async {
        withAnimation(.easeInOut) {
            self.popularArtistsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedArtists = try await fetchPopularArtists(genre: genre.title)
            withAnimation(.easeInOut) {
                self.popularArtists = fetchedArtists.artists
                self.popularArtistsResponse = ApiResponse(status: .success, data: fetchedArtists.artists)
            }
        } catch {
            print("Error fetching popular artists: \(error)")
            withAnimation(.easeInOut) {
                self.popularArtistsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getFeaturedEvent() async {
        withAnimation(.easeInOut) {
            self.featuredEventResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedEvent = try await fetchFeaturedEvent(genre: genre.title)
            withAnimation(.easeInOut) {
                self.featuredEvent = fetchedEvent.event
                self.featuredEventResponse = ApiResponse(status: .success, data: fetchedEvent.event)
            }
        } catch {
            print("Error fetching featured event: \(error)")
            withAnimation(.easeInOut) {
                self.featuredEventResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getSuggestedConcerts() async {
        withAnimation(.easeInOut) {
            self.suggestedConcertsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedConcerts = try await fetchSuggestedConcerts(genre: genre.title)
            withAnimation(.easeInOut) {
                self.suggestedConcerts = fetchedConcerts.concerts.reversed()
                self.suggestedConcertsResponse = ApiResponse(status: .success, data: fetchedConcerts.concerts)
            }
        } catch {
            print("Error fetching suggested concerts: \(error)")
            withAnimation(.easeInOut) {
                self.suggestedConcertsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
}

