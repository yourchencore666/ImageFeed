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
    private init() {}
    
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    let queue = DispatchQueue(label: "profileImage.service.queue", qos: .unspecified)
    
    func fetchProfileImageURL(username: String, token: String?, completion: @escaping (Result<Void, Error>) -> Void) {
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
            switch result {
            case .success(let decodedObject):
                if let image = decodedObject.profileImage?.image {
                    self.avatarURL = image
                    NotificationCenter.default.post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": image])
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
                print(error)
            }
        }
        self.task = task
        task.resume()
    }
    
    
    
    private func makeRequest(username: String, token: String) -> URLRequest {
        guard let url = URL(string: defaultBaseUrl.absoluteString + "/users/" + username) else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
