//
//  CharacterListViewModel.swift
//  Characters
//
//  Created by Mohamed Sayed on 14/10/2024.
//

import Foundation
import Combine

class CharacterListViewModel: ObservableObject {
    
    // Published properties to notify the View
    @Published var characters: [Character] = []
    @Published var allCharacters: [Character] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Services and state variables
    private let networkService: NetworkServiceProtocol?
    private var currentPage = 1
    private var isLastPage = false
    private var filterStatus: String?
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Fetch Characters with Pagination
    func fetchCharacters(by status: String? = nil) {
        guard !isLoading && !isLastPage else { return }
        
        isLoading = true
        
        // Create API Request
        let queryParams = ["page": "\(currentPage)"]
        let request = APIRequest(
            path: "character",
            method: .get,
            queryParams: queryParams,
            bodyParams: nil,
            headers: nil
        )
        
        // Perform network request
        networkService?.performRequest(request: request, responseType: CharacterResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    // Append new characters and update filters
                    self?.allCharacters.append(contentsOf: response.results)
                    self?.filterCharacters(by: status)
                    
                    self?.isLastPage = response.results.isEmpty
                    self?.currentPage += 1
                    
                case .failure(let error):
                    self?.errorMessage = self?.handleError(error: error)
                }
                self?.isLoading = false
            }
        }
    }
    
    // MARK: - Filter Characters Locally
    func filterCharacters(by status: String?) {
        if let status = status, !status.isEmpty {
            characters = allCharacters.filter { $0.status.lowercased() == status.lowercased() }
        } else {
            characters = allCharacters
        }
    }
    
    // MARK: - Handle API Errors
    private func handleError(error: APIError) -> String {
        switch error {
        case .invalidURL:
            return "Invalid URL."
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .decodingFailed:
            return "Failed to decode response."
        case .invalidResponse:
            return "Invalid response from server."
        case .statusCodeError(let code):
            return "Server returned status code \(code)."
        }
    }
}
