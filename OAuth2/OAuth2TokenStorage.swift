//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Юрченко Артем on 22.12.2022.
//

import Foundation

final class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case bearerToken
    }
    
    var token: String? {
        get {
            return userDefaults.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.bearerToken.rawValue)
        }
    }
}
