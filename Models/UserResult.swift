//
//  UserResult.swift
//  ImageFeed
//
//  Created by Юрченко Артем on 16.01.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImages
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeysUserResult.self)
        self.profileImage = try container.decode(ProfileImages.self, forKey: .profile_image)
    }
}

fileprivate enum CodingKeysUserResult: String, CodingKey {
    case profile_image
    
}



struct ProfileImages: Codable {
    
    let small: String
    let medium: String
    let large: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeysForProfileImages.self)
        self.small = try container.decode(String.self, forKey: .small)
        self.medium = try container.decode(String.self, forKey: .medium)
        self.large = try container.decode(String.self, forKey: .large)
    }
}

fileprivate enum CodingKeysForProfileImages: String, CodingKey {
    case small, medium, large
    
}
