//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Юрченко Артем on 16.01.2023.
//

import Foundation

final class ProfileImageService {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    private(set) var avatarURL: String?
    private let token = OAuth2TokenStorage().token
    
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    let queue = DispatchQueue(label: "profileImage.service.queue", qos: .unspecified)
    
    func fetchProfileImageURL(_ username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        
        guard let token = token else {
            return
        }
        
        let request = makeRequest(username: username, token: token)
        let task = session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            self.queue.async {
                switch result {
                case .success(let result):
                    self.avatarURL = result.profileImage.small
                    completion(.success(result.profileImage.small))
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            }
        }
        task.resume()
    }
    
    
    
    private func makeRequest(username: String, token: String) -> URLRequest {
        guard let url = URL(string: defaultBaseUrl.absoluteString + "/me") else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func setAvatarUrlString(avatarUrl: String) {
        avatarURL = avatarUrl
    }
    
}
