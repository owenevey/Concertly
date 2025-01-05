import Foundation

struct GamesResponse: Codable {
    let games: [Game]
}

struct Game: Codable, Identifiable {
    let league: String
    let id: String
    let url: String
    let homeTeam: String
    let awayTeam: String
    let homeTeamColor: String
    let awayTeamColor: String
    let dateTime: Date
    let minPrice: Double
    let maxPrice: Double
    let venueName: String
    let venueAddress: String
    let cityName: String
    let latitude: Double
    let longitude: Double
}
