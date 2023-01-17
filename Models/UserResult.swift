struct UserResult: Codable {
    let profileImage: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let profileImage: [String: String]
    
    init(decodedData: UserResult) {
        self.profileImage = decodedData.profileImage
    }
}
