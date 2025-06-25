import Foundation

actor TokenRefresher {
    private var refreshTask: Task<String, Error>? = nil

    func refresh(using block: @escaping () async throws -> String) async throws -> String {
        if let existingTask = refreshTask {
            return try await existingTask.value
        }

        let task = Task { () throws -> String in
            return try await block()
        }

        refreshTask = task

        do {
            let result = try await task.value
            refreshTask = nil
            return result
        } catch {
            refreshTask = nil
            throw error
        }
    }
}

