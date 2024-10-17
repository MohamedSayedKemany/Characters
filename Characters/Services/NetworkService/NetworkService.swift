//
//  NetworkService.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 30/09/2024.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func performRequest<T: Decodable>(
        request: APIRequest,
        responseType: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    )
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed(Error)
    case invalidResponse
    case statusCodeError(Int)
}

class NetworkService: NetworkServiceProtocol {
    
    func performRequest<T: Decodable>(
        request: APIRequest,     
        responseType: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let url = request.buildURL() else {
            completion(.failure(.invalidURL))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        if let headers = request.headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let queryParams = request.queryParams {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
            urlRequest.url = urlComponents.url
        }

        if let bodyParams = request.bodyParams {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParams, options: [])
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(.requestFailed(error)))
                return
            }
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                completion(.failure(.statusCodeError(statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }

        task.resume()
    }
}
