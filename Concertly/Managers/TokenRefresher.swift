import Foundation

actor TokenRefresher {
    private var isRefreshing = false
    private var handlers: [(Result<String, Error>) -> Void] = []
    private var cachedIdToken: String?

    func refresh(using block: @escaping () async throws -> String) async throws -> String {
        if isRefreshing {
            if let token = cachedIdToken {
                 // If we already have it cached from a previous successful refresh, return it immediately.
                 // This is an optimization for subsequent calls after the initial refresh completes
                 // but before isRefreshing is reset.
                 return token
            }
            return try await withCheckedThrowingContinuation { continuation in
                handlers.append { result in
                    switch result {
                    case .success(let token):
                        continuation.resume(returning: token)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }

        isRefreshing = true
        cachedIdToken = nil

        do {
            let newToken = try await block()
            cachedIdToken = newToken

            for handler in handlers {
                handler(.success(newToken))
            }
            handlers.removeAll()
            isRefreshing = false
            return newToken
        } catch {
            for handler in handlers {
                handler(.failure(error))
            }
            handlers.removeAll()
            isRefreshing = false
            cachedIdToken = nil
            throw error
        }
    }
}
