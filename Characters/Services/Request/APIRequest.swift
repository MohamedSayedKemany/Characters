//
//  APIRequest.swift
//  Characters
//
//  Created by Mohamed Sayed on 16/10/2024.
//

import Foundation

// Struct to represent any API request
struct APIRequest {
    let baseURL: String = Constants.baseURL
    let path: String
    let method: HTTPMethod
    let queryParams: [String: String]?
    let bodyParams: [String: Any]?
    let headers: [String: String]?

    // Helper to build the full URL with query parameters
    func buildURL() -> URL? {
        let urlString = baseURL + path
        let url = URL(string: urlString)
        
        return url
    }
}
