import Foundation
import AWSCognitoIdentityProvider

class AuthenticationService {
    
    static let shared = AuthenticationService()
    
    private init() { }
    
    private let userPool = AWSCognitoIdentityUserPool(forKey: "UserPool")
    
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
                print("AWS ERROR", error)
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
            return nil
        }
    }
    
    func confirmSignUp(email: String, password: String, confirmationCode: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userPool = userPool else {
            completion(.failure(NSError(domain: "UserPoolNotInitialized", code: -1, userInfo: nil)))
            return
        }
        
        let user = userPool.getUser(email)
        user.confirmSignUp(confirmationCode).continueWith { task in
            if let error = task.error {
                completion(.failure(error))
            } else {
                self.signIn(email: email, password: password, completion: { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let signInError):
                        completion(.failure(signInError))
                    }
                })
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
                
                UserDefaults.standard.set(true, forKey: AppStorageKeys.isSignedIn.rawValue)
                
                completion(.success(session))
            } else {
                // If no session is returned, handle that case
                completion(.failure(NSError(domain: "NoSessionReturned", code: -1, userInfo: nil)))
            }
            return nil
        }
    }
    
    
}
