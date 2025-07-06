import Foundation
import AWSCognitoIdentityProvider

class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private init() { }
    
    private let userPool = AWSCognitoIdentityUserPool(forKey: "UserPool")
    
    private let refresher = TokenRefresher()
    
    func refreshTokens() async throws {
        try await refresher.refresh {
            guard KeychainUtil.get(forKey: "refreshToken") != nil else {
                throw NSError(domain: "NoRefreshToken", code: -1)
            }

            guard let user = self.userPool?.currentUser() else {
                throw NSError(domain: "UserNotLoggedIn", code: -1)
            }

            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                user.getSession().continueWith { task in
                    if let error = task.error {
                        continuation.resume(throwing: error)
                        return nil
                    }

                    guard let session = task.result else {
                        continuation.resume(throwing: NSError(domain: "NoSession", code: -1))
                        return nil
                    }

                    let accessToken = session.accessToken?.tokenString ?? ""
                    let idToken = session.idToken?.tokenString ?? ""
                    let refreshToken = session.refreshToken?.tokenString ?? ""

                    KeychainUtil.save(accessToken, forKey: "accessToken")
                    KeychainUtil.save(idToken, forKey: "idToken")
                    KeychainUtil.save(refreshToken, forKey: "refreshToken")

                    continuation.resume()
                    return nil
                }
            }

        }
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
                
                KeychainUtil.save(accessToken, forKey: AppStorageKeys.accessToken.rawValue)
                KeychainUtil.save(idToken, forKey: AppStorageKeys.idToken.rawValue)
                KeychainUtil.save(refreshToken, forKey: AppStorageKeys.refreshToken.rawValue)
                
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
        
        clearLocalUserData()
        
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
                completion(.success(()))
            }
            return nil
        }
    }
}

func getUserData() async throws -> Bool {
    let response = try await fetchUserPreferences()
    if let preferences = response.data {
        if preferences.city != nil {
            UserDefaults.standard.set(preferences.city, forKey: AppStorageKeys.homeCity.rawValue)
            UserDefaults.standard.set(preferences.latitude, forKey: AppStorageKeys.homeLat.rawValue)
            UserDefaults.standard.set(preferences.longitude, forKey: AppStorageKeys.homeLong.rawValue)
            UserDefaults.standard.set(preferences.airport, forKey: AppStorageKeys.homeAirport.rawValue)
        } else {
            // They haven't saved preferences
            return false
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
        
    return true
}

func clearOnlyAuthData() {
    KeychainUtil.delete(forKey: AppStorageKeys.accessToken.rawValue)
    KeychainUtil.delete(forKey: AppStorageKeys.idToken.rawValue)
    KeychainUtil.delete(forKey: AppStorageKeys.refreshToken.rawValue)
    UserDefaults.standard.removeObject(forKey: AppStorageKeys.email.rawValue)
    UserDefaults.standard.removeObject(forKey: AppStorageKeys.selectedNotificationPref.rawValue)
}


func clearLocalUserData() {
    KeychainUtil.delete(forKey: AppStorageKeys.accessToken.rawValue)
    KeychainUtil.delete(forKey: AppStorageKeys.idToken.rawValue)
    KeychainUtil.delete(forKey: AppStorageKeys.refreshToken.rawValue)
    UserDefaults.standard.removeObject(forKey: AppStorageKeys.email.rawValue)
    UserDefaults.standard.removeObject(forKey: AppStorageKeys.selectedNotificationPref.rawValue)
    UserDefaults.standard.removeObject(forKey: AppStorageKeys.theme.rawValue)
    UserDefaults.standard.removeObject(forKey: AppStorageKeys.concertReminders.rawValue)
    UserDefaults.standard.removeObject(forKey: AppStorageKeys.newTourDates.rawValue)
    UserDefaults.standard.removeObject(forKey: AppStorageKeys.homeCity.rawValue)
    UserDefaults.standard.removeObject(forKey: AppStorageKeys.homeLat.rawValue)
    UserDefaults.standard.removeObject(forKey: AppStorageKeys.homeLong.rawValue)
    UserDefaults.standard.removeObject(forKey: AppStorageKeys.homeAirport.rawValue)
    UserDefaults.standard.removeObject(forKey: AppStorageKeys.lastCheckedImages.rawValue)
    
    CoreDataManager.shared.deleteAllSavedItems()
}
