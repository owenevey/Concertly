import Foundation

struct FollowRequestBody: Codable {
    let followRequest: FollowRequest
}

struct FollowRequest: Codable {
    let artistId: String
    let pushNotificationToken: String
    let follow: Bool
}

