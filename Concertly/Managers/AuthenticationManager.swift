import Foundation
import AWSCognitoIdentityProvider

class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private init() { }
    
    private let userPool = AWSCognitoIdentityUserPool(forKey: "UserPool")
    
    private var isRefreshing = false
    private var refreshCompletionHandlers: [(Result<Void, Error>) -> Void] = []
    
    func refreshTokens() async throws {
        if isRefreshing {
            try await withCheckedThrowingContinuation { continuation in
                refreshCompletionHandlers.append { result in
                    switch result {
                    case .success:
                        continuation.resume(returning: ())
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
            return
        }
        
        isRefreshing = true
        print("Authentication service is refreshing tokens...")
        do {
            guard KeychainUtil.get(forKey: "refreshToken") != nil else {
                throw NSError(domain: "NoRefreshToken", code: -1, userInfo: nil)
            }
            
            guard let user = userPool?.currentUser() else {
                throw NSError(domain: "UserNotLoggedIn", code: -1, userInfo: nil)
            }
            
            let task = user.getSession()
            if let session = task.result {
                let accessToken = session.accessToken?.tokenString ?? ""
                let idToken = session.idToken?.tokenString ?? ""
                let refreshToken = session.refreshToken?.tokenString ?? ""
                
                KeychainUtil.save(accessToken, forKey: "accessToken")
                KeychainUtil.save(idToken, forKey: "idToken")
                KeychainUtil.save(refreshToken, forKey: "refreshToken")
                
                notifyRefreshCompletionHandlers(with: .success(()))
            } else {
                throw NSError(domain: "could not refresh session", code: -1, userInfo: nil)
            }
            
        } catch {
            notifyRefreshCompletionHandlers(with: .failure(error))
            throw error
        }
    }
    
    private func notifyRefreshCompletionHandlers(with result: Result<Void, Error>) {
        for handler in refreshCompletionHandlers {
            handler(result)
        }
        refreshCompletionHandlers.removeAll()
        
        isRefreshing = false
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userPool = userPool else {
            completion(.failure(NSError(domain: "UserPoolNotInitialized", code: -1, userInfo: nil)))
            return
        }
        
        let userAttributes = [
            AWSCognitoIdentityUserAttributeType(name: "email", value: email)
        ]
        
        userPool.signUp(email, password: password, userAttributes: userAttributes, validationData: nil).continueWith { task in
            if let error = task.error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
            return nil
        }
    }
    
    func confirmSignUp(email: String, confirmationCode: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userPool = userPool else {
            completion(.failure(NSError(domain: "UserPoolNotInitialized", code: -1, userInfo: nil)))
            return
        }
        
        let user = userPool.getUser(email)
        user.confirmSignUp(confirmationCode).continueWith { task in
            if let error = task.error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
            return nil
        }
    }
    
    func resendConfirmationCode(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userPool = userPool else {
            completion(.failure(NSError(domain: "UserPoolNotInitialized", code: -1, userInfo: nil)))
            return
        }
        
        let user = userPool.getUser(email)
        user.resendConfirmationCode().continueWith { task in
            if let error = task.error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
            return nil
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<AWSCognitoIdentityUserSession, Error>) -> Void) {
        guard let userPool = userPool else {
            completion(.failure(NSError(domain: "UserPoolNotInitialized", code: -1, userInfo: nil)))
            return
        }
        
        let user = userPool.getUser(email)
        user.getSession(email, password: password, validationData: nil).continueWith { task in
            if let error = task.error {
                completion(.failure(error))
            } else if let session = task.result {
                let accessToken = session.accessToken?.tokenString ?? ""
                let idToken = session.idToken?.tokenString ?? ""
                let refreshToken = session.refreshToken?.tokenString ?? ""
                
                KeychainUtil.save(accessToken, forKey: "accessToken")
                KeychainUtil.save(idToken, forKey: "idToken")
                KeychainUtil.save(refreshToken, forKey: "refreshToken")
                
                UserDefaults.standard.set(email, forKey: AppStorageKeys.email.rawValue)
                
                if let idTokenPayload = self.parseJWT(idToken) {
                    if let sub = idTokenPayload["sub"] as? String {
                        UserDefaults.standard.set(sub, forKey: "userId")
                    }
                }
                
                completion(.success(session))
            } else {
                completion(.failure(NSError(domain: "NoSessionReturned", code: -1, userInfo: nil)))
            }
            return nil
        }
    }
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userPool = userPool else {
            completion(.failure(NSError(domain: "UserPoolNotInitialized", code: -1, userInfo: nil)))
            return
        }
        
        let user = userPool.currentUser()
        user?.signOut()
        
        // Clear tokens and sign-in state
        KeychainUtil.delete(forKey: "accessToken")
        KeychainUtil.delete(forKey: "idToken")
        KeychainUtil.delete(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: AppStorageKeys.email.rawValue)
        UserDefaults.standard.removeObject(forKey: AppStorageKeys.isSignedIn.rawValue)
        UserDefaults.standard.removeObject(forKey: AppStorageKeys.hasFinishedOnboarding.rawValue)
        UserDefaults.standard.removeObject(forKey: AppStorageKeys.selectedNotificationPref.rawValue)
        UserDefaults.standard.removeObject(forKey: AppStorageKeys.concertReminders.rawValue)
        UserDefaults.standard.removeObject(forKey: AppStorageKeys.newTourDates.rawValue)
        UserDefaults.standard.removeObject(forKey: AppStorageKeys.homeCity.rawValue)
        UserDefaults.standard.removeObject(forKey: AppStorageKeys.homeLat.rawValue)
        UserDefaults.standard.removeObject(forKey: AppStorageKeys.homeLong.rawValue)
        UserDefaults.standard.removeObject(forKey: AppStorageKeys.homeAirport.rawValue)
        
        CoreDataManager.shared.deleteAllSavedItems()
        
        completion(.success(()))
    }
    
    func forgotPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userPool = userPool else {
            completion(.failure(NSError(domain: "UserPoolNotInitialized", code: -1, userInfo: nil)))
            return
        }
        
        let user = userPool.getUser(email)
        user.forgotPassword().continueWith { task in
            if let error = task.error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
            return nil
        }
    }
    
    func confirmForgotPassword(email: String, confirmationCode: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userPool = userPool else {
            completion(.failure(NSError(domain: "UserPoolNotInitialized", code: -1, userInfo: nil)))
            return
        }
        
        let user = userPool.getUser(email)
        user.confirmForgotPassword(confirmationCode, password: newPassword).continueWith { task in
            if let error = task.error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
            return nil
        }
    }
    
    func parseJWT(_ token: String) -> [String: Any]? {
        let components = token.split(separator: ".")
        if components.count == 3 {
            let base64UrlString = String(components[1])
            let base64 = base64UrlString
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            
            guard let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters),
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return nil
            }
            return json
        }
        return nil
    }
    
    
    func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = userPool?.currentUser() else {
            completion(.failure(NSError(domain: "UserNotLoggedIn", code: -1, userInfo: nil)))
            return
        }

        user.delete().continueWith { task in
            if let error = task.error {
                completion(.failure(error))
            } else {
                
                // Clear tokens and sign-in state
                KeychainUtil.delete(forKey: "accessToken")
                KeychainUtil.delete(forKey: "idToken")
                KeychainUtil.delete(forKey: "refreshToken")
                UserDefaults.standard.removeObject(forKey: AppStorageKeys.email.rawValue)
                UserDefaults.standard.removeObject(forKey: AppStorageKeys.isSignedIn.rawValue)
                UserDefaults.standard.removeObject(forKey: AppStorageKeys.hasFinishedOnboarding.rawValue)
                UserDefaults.standard.removeObject(forKey: AppStorageKeys.selectedNotificationPref.rawValue)
                UserDefaults.standard.removeObject(forKey: AppStorageKeys.concertReminders.rawValue)
                UserDefaults.standard.removeObject(forKey: AppStorageKeys.newTourDates.rawValue)
                UserDefaults.standard.removeObject(forKey: AppStorageKeys.homeCity.rawValue)
                UserDefaults.standard.removeObject(forKey: AppStorageKeys.homeLat.rawValue)
                UserDefaults.standard.removeObject(forKey: AppStorageKeys.homeLong.rawValue)
                UserDefaults.standard.removeObject(forKey: AppStorageKeys.homeAirport.rawValue)
                
                CoreDataManager.shared.deleteAllSavedItems()
                
                completion(.success(()))
            }
            return nil
        }
    }

    
}



func getUserData() async throws {
    let response = try await fetchUserPreferences()
    if let preferences = response.data {
        if preferences.city != nil {
            UserDefaults.standard.set(preferences.city, forKey: AppStorageKeys.homeCity.rawValue)
            UserDefaults.standard.set(preferences.latitude, forKey: AppStorageKeys.homeLat.rawValue)
            UserDefaults.standard.set(preferences.longitude, forKey: AppStorageKeys.homeLong.rawValue)
            UserDefaults.standard.set(preferences.airport, forKey: AppStorageKeys.homeAirport.rawValue)
        } else {
            // They haven't saved preferences
            return
        }
    } else {
        throw NSError(domain: "getUserData preferences failed", code: 1, userInfo: nil)
    }
    
    let artistsResponse = try await fetchFollowedArtists()
    
    if let artistsData = artistsResponse.data {
        if artistsData.count > 0 {
            CoreDataManager.shared.saveItems(artistsData, category: ContentCategories.following.rawValue)
        }
    } else {
        throw NSError(domain: "getUserData artistsResponse failed", code: 1, userInfo: nil)
    }
    
    UserDefaults.standard.set(true, forKey: AppStorageKeys.hasFinishedOnboarding.rawValue)
}
