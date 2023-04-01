//
//  URLSession.swift
//  ImageFeed
//
//  Created by Юрченко Артем on 12.01.2023.
//

import Foundation

extension URLSession {

    //MARK: - Enumerations
    private enum NetworkError: Error {
        case codeError
    }

    //MARK: - Generic method
    func objectTask<T: Decodable> (
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {

        let task = dataTask(with: request, completionHandler: { (data, response, error) in

            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                    return
                }
            }

            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode > 299 {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.codeError))
                    return
                }
            }

            guard let data = data else { return }
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedObject))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        })
        return task
    }
}
