import Foundation

enum concertRemindersEnum: Int {
    case dayBefore = 1
    case weekBefore = 7
    case off = 0
}

enum AppStorageKeys: String {
    case hasSeenOnboarding
    case theme
    case concertReminders
    case newTourDates
    case pushNotificationToken
    case homeCity
    case homeLat
    case homeLong
    case homeAirport
}

enum ContentCategories: String {
    case explore = "explore"
    case exploreTrending = "explore_trending"
    case exploreFeatured = "explore_featured"
    case exploreSuggested = "explore_suggested"
    case following = "following"
    case nearby = "nearby"
    case saved = "saved"
}
