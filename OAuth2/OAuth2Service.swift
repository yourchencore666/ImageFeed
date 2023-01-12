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
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                    return
                }
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.codeError))
                    return
                }
            }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(response.accessToken))
                        self.task = nil
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                        self.lastCode = nil
                    }
                }
            }
        }
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
