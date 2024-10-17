//
//  CharacterListViewModelTests.swift
//  CharactersTests
//
//  Created by Mohamed Sayed on 17/10/2024.
//

import XCTest
import Combine
@testable import Characters

class CharacterListViewModelTests: XCTestCase {
    
    var viewModel: CharacterListViewModel!
    var mockNetworkService: MockNetworkService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = CharacterListViewModel(networkService: mockNetworkService)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Test: Successful Fetch of Characters
    func testFetchCharactersSuccess() {
        // Given
        let characters = [
            Character(id: 1, name: "Rick Sanchez", species: "Human", status: "Alive", gender: "Male", image: ""),
            Character(id: 2, name: "Morty Smith", species: "Human", status: "Alive", gender: "Male", image: "")
        ]
        
        let mockResponse = CharacterResponse(results: characters)
        mockNetworkService.mockResult = .success(mockResponse)
        
        let expectation = XCTestExpectation(description: "Characters fetched successfully")
        
        // When
        viewModel.fetchCharacters()
        
       // Then
        viewModel.$characters
            .dropFirst()
            .sink { fetchedCharacters in
                XCTAssertEqual(fetchedCharacters.count, 2, "Should have fetched 2 characters.")
                XCTAssertEqual(fetchedCharacters.first?.name, "Rick Sanchez", "First character should be Rick Sanchez.")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Test: Filtering Characters Locally
    func testFilterCharactersLocally() {
        // Given
        viewModel.allCharacters = [
            Character(id: 1, name: "Rick Sanchez", species: "Human", status: "Alive", gender: "Male", image: ""),
            Character(id: 2, name: "Morty Smith", species: "Human", status: "Dead", gender: "Male", image: "")
        ]
        
        //When
        viewModel.filterCharacters(by: "Alive")
        
        // Then
        XCTAssertEqual(viewModel.characters.count, 1, "There should be 1 character with status 'Alive'.")
        XCTAssertEqual(viewModel.characters.first?.name, "Rick Sanchez", "First character should be Rick Sanchez.")
    }
    
    // MARK: - Test: Fetch Characters with API Error
    func testFetchCharactersWithError() {
        // Prepare mock error
        mockNetworkService.mockResult = .failure(.requestFailed(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"])))
        
        let expectation = XCTestExpectation(description: "Error handling for failed fetch")
        
        // Bind to error message
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, "Request failed: Not Found")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Act
        viewModel.fetchCharacters()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Test: Pagination Handling
    func testPaginationHandling() {
        // Given
        let firstPageCharacters = [Character(id: 1, name: "Rick Sanchez", species: "Human", status: "Alive", gender: "Male", image: "")]
        let secondPageCharacters = [Character(id: 2, name: "Morty Smith", species: "Human", status: "Alive", gender: "Male", image: "")]
        
        let firstPageResponse = CharacterResponse(results: firstPageCharacters)
        let secondPageResponse = CharacterResponse(results: secondPageCharacters)
        
        mockNetworkService.mockResult = .success(firstPageResponse)
        mockNetworkService.mockResult = .success(secondPageResponse)
        let firstPageExpectation = XCTestExpectation(description: "First page loaded")
        
        // When
        // Act: First page load
        viewModel.fetchCharacters()
        // Act: Load more (Second page)
        viewModel.fetchCharacters()
        
        // Then
        viewModel.$allCharacters
            .dropFirst()
            .sink { allCharacters in
                XCTAssertEqual(allCharacters.count, 1, "First page should load 1 character.")
                firstPageExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [firstPageExpectation], timeout: 2.0)
    }

}
