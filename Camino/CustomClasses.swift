import Foundation


struct Place {
    let id = UUID()
    var name: String
    var country: String
    var countryFlag: String
    var imageString: String
    var description: String
}

struct Game {
    let id = UUID()
    var homeTeamName: String
    var awayTeamName: String
    var homeTeamLogo: String
    var awayTeamLogo: String
    var leagueLogo: String
    var date: String
    var location: String
    var country: String
}

class ogConcert {
    let id = UUID()
    var artist: String
    var artistPhoto: String
    var date: String
    var location: String
    var country: String
    var countryFlag: String
    
    init(artist: String, artistPhoto: String, date: String, location: String, country: String, countryFlag: String) {
        self.artist = artist
        self.artistPhoto = artistPhoto
        self.date = date
        self.location = location
        self.country = country
        self.countryFlag = countryFlag
    }
}

var suggestedPlaces = [
    Place(name: "Rio De Janeiro", country: "Brazil", countryFlag: "🇧🇷", imageString: "rio", description: "Where vibrant culture meets breathtaking beaches"),
    Place(name: "Taj Mahal", country: "India", countryFlag: "🇮🇳", imageString: "tajMahal", description: "A symbol of eternal love in marble"),
    Place(name: "ZhangJiaJie", country: "China", countryFlag: "🇨🇳", imageString: "zhangJiaJie", description: "Nature's towering masterpiece of mist and mystery"),
    Place(name: "London", country: "England", countryFlag: "🏴󠁧󠁢󠁥󠁮󠁧󠁿", imageString: "london", description: "A timeless blend of history and modernity"),
    Place(name: "Cape Town", country: "South Africa", countryFlag: "🇿🇦", imageString: "capeTown", description: "Where oceans and mountains converge"),
    Place(name: "Santa Monica", country: "USA", countryFlag: "🇺🇸", imageString: "santaMonica", description: "Sun, surf, and iconic pier vibes"),
    Place(name: "Tokyo", country: "Japan", countryFlag: "🇯🇵", imageString: "tokyo", description: "A dynamic fusion of tradition and innovation")
]


var upcomingGames = [
    Game(homeTeamName: "CHE", awayTeamName: "ARS", homeTeamLogo: "chelsea", awayTeamLogo: "arsenal", leagueLogo: "premierLeague", date: "Mon Sept 30", location: "Stamford Bridge", country: "England"),
    Game(homeTeamName: "NAP", awayTeamName: "INT", homeTeamLogo: "napoli", awayTeamLogo: "interMilan", leagueLogo: "serieA", date: "Tue Oct 21", location: "Maradona Stadium", country: "Italy"),
    Game(homeTeamName: "MSU", awayTeamName: "USC", homeTeamLogo: "michiganState", awayTeamLogo: "usc", leagueLogo: "bigTen", date: "Sat Oct 5", location: "Spartan Stadium", country: "USA"),
    Game(homeTeamName: "MUN", awayTeamName: "FUL", homeTeamLogo: "manUtd", awayTeamLogo: "fulham", leagueLogo: "premierLeague", date: "Sat Oct 21", location: "Old Trafford", country: "England")
]


var trendingConcerts = [
    ogConcert(artist: "Blink 182", artistPhoto: "blink182", date: "Fri Oct 12", location: "Zilker Park", country: "USA", countryFlag: "🇺🇸"),
    ogConcert(artist: "Morgan Wallen", artistPhoto: "morganWallen", date: "Thu Nov 10", location: "Neyland Stadium", country: "USA", countryFlag: "🇺🇸"),
    ogConcert(artist: "U2", artistPhoto: "u2", date: "Fri Oct 21", location: "Anfield", country: "England", countryFlag: "🏴󠁧󠁢󠁥󠁮󠁧󠁿"),
    ogConcert(artist: "Dua Lipa", artistPhoto: "duaLipa", date: "Sat November 2", location: "Johan Cruijff ArenA", country: "Netherlands", countryFlag: "🇳🇱"),
    ogConcert(artist: "Coldplay", artistPhoto: "coldplay", date: "Sat Sep 29", location: "Estadio River Plate", country: "Argentina", countryFlag: "🇦🇷"),
    ogConcert(artist: "Drake", artistPhoto: "drake", date: "Wed Dec 4", location: "Mercedes Benz Stadium", country: "USA", countryFlag: "🇺🇸"),
    ogConcert(artist: "Maroon 5", artistPhoto: "maroon5", date: "Fri Oct 30", location: "Petco Park", country: "USA", countryFlag: "🇺🇸")
]

var hotConcerts = [
    Concert(name: "Charli XCX", id: "G5diZbFRelxnG", url: "https://www.ticketmaster.com/charli-xcx-troye-sivan-present-sweat-new-york-new-york-09-23-2024/event/3B00608BC2AE2A8C", imageUrl: "https://s1.ticketm.net/dam/a/f2b/220a2ab5-5dc4-4c55-b39b-f61564286f2b_SOURCE", dateTime: Date.now, minPrice: 49.5, maxPrice: 179.5, venue: Venue(name: "Madison Square Garden", country: "United States of America", latitude: "40.7497062", longitude: "-73.9916006"))]
