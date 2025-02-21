import Foundation

struct SuggestedConcertsResponse: Codable {
    let name: String
    let concerts: [Concert]
}

struct SuggestedArtistsRequest: Encodable {
    let artists: [SuggestedArtist]
}
