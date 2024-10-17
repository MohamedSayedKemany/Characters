//
//  MockNetworkService.swift
//  CharactersTests
//
//  Created by Mohamed Sayed on 17/10/2024.
//

import Foundation
import Combine
@testable import Characters

class MockNetworkService: NetworkServiceProtocol {
    
    var mockResult: Result<CharacterResponse, APIError>?
    
    func performRequest<T>(request: APIRequest, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) where T : Decodable {
        // Simulate API Response
        if let mockResult = mockResult as? Result<T, APIError> {
            completion(mockResult)
        }
    }
}
