import Foundation

struct ApiResponse<T: Codable>: Codable {
    var status: Status
    var data: T?
    var error: String?
    
    init(status: Status = .empty, data: T? = nil, error: String? = nil) {
        self.status = status
        self.data = data
        self.error = error
    }
}

enum Status: String, Codable {
    case empty = "empty"
    case loading = "loading"
    case success = "success"
    case error = "error"
}

