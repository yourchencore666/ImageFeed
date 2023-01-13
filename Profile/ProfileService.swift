
import Foundation

final class ProfileService {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    fileprivate let profileInfoURLString = "https://api.unsplash.com/me"
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    private(set) var profile: Profile?
    
    static let shared = ProfileService()
    
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        
        let request = makeRequest(token: token)
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                        self.lastToken = nil
                        return
                    }
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
                    self.profile = self.convertProfileResultToProfile(profileResult: jsonData)
                    guard let profile = self.profile else {
                        return
                    }

                    DispatchQueue.main.async {
                        completion(.success(profile))
                        print(profile)
                        self.lastToken = nil

                    }
                } catch let error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                        self.task = nil
                    }
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
    
  
    

}
