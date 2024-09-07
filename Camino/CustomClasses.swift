import Foundation


class SuggestedPlace {
    let id = UUID()
    var name: String
    var country: String
    var countryFlag: String
    var imageString: String
    var description: String
    
    
    init(name: String, country: String, countryFlag: String, imageString: String, description: String) {
        self.name = name
        self.country = country
        self.countryFlag = countryFlag
        self.imageString = imageString
        self.description = description
    }
}

var suggestedPlaces = [
    SuggestedPlace(name: "Rio De Janeiro", country: "Brazil", countryFlag: "🇧🇷", imageString: "rio", description: "Where vibrant culture meets breathtaking beaches"),
    SuggestedPlace(name: "Taj Mahal", country: "India", countryFlag: "🇮🇳", imageString: "tajMahal", description: "A symbol of eternal love in marble"),
    SuggestedPlace(name: "ZhangJiaJie", country: "China", countryFlag: "🇨🇳", imageString: "zhangJiaJie", description: "Nature's towering masterpiece of mist and mystery"),
    SuggestedPlace(name: "London", country: "England", countryFlag: "🏴󠁧󠁢󠁥󠁮󠁧󠁿", imageString: "london", description: "A timeless blend of history and modernity"),
    SuggestedPlace(name: "Cape Town", country: "South Africa", countryFlag: "🇿🇦", imageString: "capeTown", description: "Where oceans and mountains converge"),
    SuggestedPlace(name: "Santa Monica", country: "USA", countryFlag: "🇺🇸", imageString: "santaMonica", description: "Sun, surf, and iconic pier vibes"),
    SuggestedPlace(name: "Tokyo", country: "Japan", countryFlag: "🇯🇵", imageString: "tokyo", description: "A dynamic fusion of tradition and innovation")
    
]
