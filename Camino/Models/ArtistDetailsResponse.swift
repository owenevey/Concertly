import Foundation

struct ArtistDetailsResponse: Codable {
    let artistDetails: Artist
}

struct Artist: Codable, Identifiable {
    let name: String
    let id: String
    let imageUrl: String
    let socials: [Social]
    let concerts: [Concert]
    let bio: String
    let similarArtists: [SuggestedArtist]
}

struct Social: Codable {
    let name: String
    let url: String
}
