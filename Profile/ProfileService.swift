
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
        let task = self.session.objectTask(for: request) { [weak self]
            (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let jsonData):
                    self.profile = self.convertProfileResultToProfile(profileResult: jsonData)
                    guard let profile = self.profile else {return}
                    completion(.success(profile))
                    self.task = nil
                case .failure:
                    self.lastToken = nil
                    return
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
