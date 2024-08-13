import Foundation
import SwiftKeychainWrapper

final class AccessTokenStorage {
    static let shared = AccessTokenStorage()
    private let keyChain = KeychainWrapper.standard
    private let key = "accessToken"
    var accessToken: String? {
        get {
            return keyChain.string(forKey: key)
        }
        
        set {
            if let token = newValue {
                let isSuccess = keyChain.set(token, forKey: key)
                guard isSuccess else {
                    print("[AccessTokenStorage set]: KeyChain error - Unable to save access token")
                    return
                }
            } else {
                keyChain.removeObject(forKey: key)
            }
        }
    }
}
