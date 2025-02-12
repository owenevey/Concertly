import Foundation

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    
    @Published var username: String = ""
    @Published var password: String = ""

    func login() {
        // Replace with real authentication logic
        if username == "username" && password == "password" {
            isAuthenticated = true
        }
    }

    func logout() {
        isAuthenticated = false
    }
}
