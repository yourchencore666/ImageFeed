
import Foundation

final class ProfileService {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    fileprivate let profileInfoURLString = "https://api.unsplash.com/me"
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        
        let request = makeRequest(token: token)
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                
                if let error = error {
                    completion(.failure(error))
                    self.lastToken = nil
                    return
                }
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode > 299 {
                    completion(.failure(NetworkError.codeError))
                    self.lastToken = nil
                    return
                    
                }
                
                guard let data = data else { return }
                
                do {
                    let jsonData = try JSONDecoder().decode(ProfileResult.self, from: data)
                    let profile = self.convertProfileResultToProfile(profileResult: jsonData)
                    completion(.success(profile))
                    self.task = nil
                    
                } catch let error {
                    completion(.failure(error))
                    self.lastToken = nil
                    
                }
            }
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeRequest(token: String) -> URLRequest {
        guard let url = URL(string: defaultBaseUrl.absoluteString + "/me") else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
   private func convertProfileResultToProfile(profileResult: ProfileResult) -> Profile {
        return Profile(
            username: profileResult.userName ?? "",
            name: (profileResult.firstName ?? "") + " " + (profileResult.lastName ?? ""),
            loginName: "@" + (profileResult.userName ?? ""),
            bio: profileResult.bio ?? ""
        )
    }
    
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
}
