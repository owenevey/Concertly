import Foundation

enum Secrets {
    static var clientId: String {
        guard let val = ProcessInfo.processInfo.environment["COGNITO_CLIENT_ID"] else {
            fatalError("Missing COGNITO_CLIENT_ID in environment")
        }
        return val
    }

    static var poolId: String {
        guard let val = ProcessInfo.processInfo.environment["COGNITO_POOL_ID"] else {
            fatalError("Missing COGNITO_POOL_ID in environment")
        }
        return val
    }
}
