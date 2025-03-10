import Foundation
import SwiftUI

@MainActor
final class GenreViewModel: ObservableObject {
    var genre: MusicGenre
        
    init(genre: MusicGenre) {
        self.genre = genre
        trendingConcerts = CoreDataManager.shared.fetchItems(for: "\(genre.apiLabel)_trending", type: Concert.self)
        popularArtists = CoreDataManager.shared.fetchItems(for: genre.apiLabel, type: SuggestedArtist.self)
        featuredConcert = CoreDataManager.shared.fetchItems(for: "\(genre.apiLabel)_featured", type: Concert.self).first
        suggestedConcerts = CoreDataManager.shared.fetchItems(for: "\(genre.apiLabel)_suggested", type: Concert.self)
        
        Task {
            await getTrendingConcerts()
            await getPopularArtists()
            await getFeaturedConcert()
            await getSuggestedConcerts()
        }
    }
    
    @Published var trendingConcertsResponse: ApiResponse<[Concert]> = ApiResponse<[Concert]>()
    @Published var trendingConcerts: [Concert] = []
    
    @Published var popularArtistsResponse: ApiResponse<[SuggestedArtist]> = ApiResponse<[SuggestedArtist]>()
    @Published var popularArtists: [SuggestedArtist] = []
    
    @Published var featuredConcertResponse: ApiResponse<Concert> = ApiResponse<Concert>()
    @Published var featuredConcert: Concert?
    
    @Published var suggestedConcertsResponse: ApiResponse<[Concert]> = ApiResponse<[Concert]>()
    @Published var suggestedConcerts: [Concert] = []
    
    
    func getTrendingConcerts() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.trendingConcertsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let category = genre.apiLabel + "_trending"
            let fetchedConcerts = try await fetchConcerts(category: category)
            
            if let concerts = fetchedConcerts.data?.concerts {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.trendingConcerts = concerts
                    self.trendingConcertsResponse = ApiResponse(status: .success, data: concerts)
                }
                CoreDataManager.shared.saveItems(concerts, category: category)
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
            let category = genre.apiLabel + "_suggested"
            let fetchedConcerts = try await fetchConcerts(category: category)
            
            if let concerts = fetchedConcerts.data?.concerts {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.suggestedConcerts = concerts
                    self.suggestedConcertsResponse = ApiResponse(status: .success, data: concerts)
                }
                CoreDataManager.shared.saveItems(concerts, category: category)
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
            let category = genre.apiLabel
            let fetchedArtists = try await fetchPopularArtists(category: category)
            
            if let artists = fetchedArtists.data?.artists {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.popularArtists = artists
                    self.popularArtistsResponse = ApiResponse(status: .success, data: artists)
                }
                CoreDataManager.shared.saveItems(artists, category: genre.apiLabel)
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
            let category = genre.apiLabel
            let fetchedConcert = try await fetchFeaturedConcert(category: category)
            
            if let concert = fetchedConcert.data?.concert {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.featuredConcert = concert
                    self.featuredConcertResponse = ApiResponse(status: .success, data: concert)
                }
                CoreDataManager.shared.saveItems([concert], category: "\(genre.apiLabel)_featured")
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

}

