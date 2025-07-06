import Foundation

actor TokenRefresher {
    private var refreshTask: Task<Void, Error>? = nil

    func refresh(using block: @escaping () async throws -> Void) async throws {
        if let existingTask = refreshTask {
            return try await existingTask.value
        }

        let task = Task {
            try await block()
        }

        refreshTask = task

        do {
            try await task.value
            refreshTask = nil
        } catch {
            refreshTask = nil
            throw error
        }
    }
}


