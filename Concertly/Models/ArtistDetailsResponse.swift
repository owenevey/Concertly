import Foundation

struct ArtistDetailsResponse: Codable {
    let artist: Artist
}

struct Artist: Codable, Identifiable {
    let name: String
    let id: String
    let imageUrl: String
    let cardImageUrl: String
    let socials: [Social]
    let concerts: [Concert]
    let description: String
    let similarArtists: [SuggestedArtist]
}

struct Social: Codable, Identifiable {
    let name: String
    let url: String
    var id: String {
        url
    }
}

func determineSocialImage(for social: Social) -> String {
    switch social.name {
    case "Instagram":
        return "instagram"
    case "X":
        return "x"
    case "YouTube":
        return "youtube"
    case "Spotify":
        return "spotify"
    case "Wikipedia":
        return "wikipedia"
    case "Homepage":
        return "safari"
    default:
        return ""
    }
}
