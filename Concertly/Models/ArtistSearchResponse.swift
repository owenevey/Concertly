import Foundation

struct ArtistSearchResponse: Codable {
    let suggestedArtists: [SuggestedArtist]
}

struct SuggestedArtist: Codable, Identifiable, Equatable, Hashable {
    let name: String
    let id: String
    var imageUrl: String
    let localImageName: String?
    
    init(name: String, id: String, imageUrl: String, localImageName: String? = nil) {
            self.name = name
            self.id = id
            self.imageUrl = imageUrl
            self.localImageName = localImageName
        }
}
