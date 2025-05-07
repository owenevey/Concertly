import Foundation

enum concertRemindersEnum: Int {
    case dayBefore = 1
    case weekBefore = 7
    case off = 0
}

enum AppStorageKeys: String {
    case email
    case isSignedIn
    case minimumVersion
    case hasFinishedOnboarding
    case selectedNotificationPref
    case theme
    case concertReminders
    case isPushNotificationsOn
    case newTourDates
    case pushNotificationToken
    case homeCity
    case homeLat
    case homeLong
    case homeAirport
    case concertViewCount
    case lastCheckedImages
}

enum ContentCategories: String {
    case explore = "explore"
    case exploreTrending = "explore_trending"
    case exploreFeatured = "explore_featured"
    case exploreSuggested = "explore_suggested"
    case following = "following"
    case recentSearches = "recentSearches"
    case nearby = "nearby"
    case saved = "saved"
}
