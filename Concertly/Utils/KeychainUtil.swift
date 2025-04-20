import Foundation
import Security

struct KeychainUtil {
    static func save(_ value: String, forKey key: String) {
        let data = Data(value.utf8)
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary
        
        SecItemDelete(query) // delete existing
        SecItemAdd(query, nil)
    }

    static func get(forKey key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        if let data = result as? Data {
            return String(decoding: data, as: UTF8.self)
        }
        return nil
    }
}
