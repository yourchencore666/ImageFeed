//
//  Profile.swift
//  ImageFeed
//
//  Created by Юрченко Артем on 13.01.2023.
//

import Foundation

private enum CodingKeysForProfileResult: String, CodingKey {
    case username, first_name, last_name, bio
}

struct ProfileResult: Codable {
    let userName: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeysForProfileResult.self)
        userName = try container.decode(String.self, forKey: .username)
        firstName = try container.decode(String.self, forKey: .first_name)
        lastName = try container.decode(String.self, forKey: .last_name)
        bio = try container.decode(String.self, forKey: .bio)
    }
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
    
    init(username: String, name: String, loginName: String, bio: String) {
        self.username = username
        self.name = name
        self.loginName = loginName
        self.bio = bio
    }
}
