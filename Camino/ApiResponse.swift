import Foundation

struct APIResponse<T: Codable>: Codable {
    let statusCode: Int
    let body: T
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case body
    }
}

