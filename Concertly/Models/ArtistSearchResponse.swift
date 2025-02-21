import Foundation

struct ArtistSearchResponse: Codable {
    let suggestedArtists: [SuggestedArtist]
}

struct SuggestedArtist: Codable, Identifiable {
    let name: String
    let id: String
    let imageUrl: String
}
