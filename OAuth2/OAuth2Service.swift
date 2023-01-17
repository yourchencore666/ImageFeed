//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Юрченко Артем on 22.12.2022.
//

import Foundation

final class OAuth2Service {
    fileprivate let unsplashAuthorizeTokenURLString = "https://unsplash.com/oauth/token"
    private var lastCode: String?
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private enum NetworkError: Error {
        case codeError
    }
    
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
               if lastCode == code { return }
               task?.cancel()
               lastCode = code
        
        
        let request = makeRequest(code: code)
        let task = self.session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let jsonData):
                    OAuth2TokenStorage().token = jsonData.accessToken
                    completion(.success(jsonData.accessToken))
                    self.task = nil
                case .failure:
                    self.lastCode = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(code: String) -> URLRequest {
        
        var urlComponents = URLComponents(string: unsplashAuthorizeTokenURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "client_secret", value: secretKey),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let url = urlComponents.url else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
