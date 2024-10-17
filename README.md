# Rick and Morty Character Viewer

## Overview
This is an iOS application that fetches and displays a list of characters from the Rick and Morty API. The application supports pagination, filtering characters by status (Alive, Dead, Unknown), and shows character details in a separate view. The app is built using MVVM architecture and integrates SwiftUI views within UIKit using UIHostingController.

## Table of Contents
- Features
- Architecture
- Setup
- Dependencies
- Testing
  
## Features
1. Character List: Displays a paginated list of characters from the Rick and Morty API.
2. Character Filters: Filter characters by status (Alive, Dead, Unknown) using a collection view.
3. Character Details: A detailed view of selected characters displaying their name, status, species, and gender.
4. Pagination: Automatically loads more characters when the user scrolls to the bottom of the list or when the table view does not have enough content to fill the screen initially.
5. Error Handling: Handles network errors gracefully by showing error messages when something goes wrong.
6. Unit Tests: Tests for ViewModel logic, including fetching data, filtering, and pagination.
   
## Architecture
The application follows the MVVM (Model-View-ViewModel) design pattern, ensuring separation of concerns and making the code easier to maintain and test.

- Model: Defines the character data model that corresponds to the API response.
- ViewModel: Manages the business logic of fetching characters, handling pagination, and applying filters.
- View: The UI is a mixture of UIKit and SwiftUI, where SwiftUI views are embedded in UITableViewCells using UIHostingController.

## Setup
   1. **Prerequisites**
      - Xcode 12+
      - iOS 16+
      - 
   2. **Installation**
        - Clone the Repository   
           ```bash
            git clone https://github.com/MohamedSayedKemany/Characters.git
           cd Characters
           ```
       - Open the Xcode project:
          ```bash
            open Characters.xcodeproj
           ```
       - Build and run the project using Xcode.

## Running the App
 - Press the "Run" button in Xcode or use the shortcut Cmd + R.
 - The app will start on your selected simulator or connected device.

## Dependencies
 - No dependencies

## Testing
## Unit Tests
Unit tests are written for the CharacterListViewModel, covering:

 - Fetching Characters: Tests for fetching characters from the API.
 - Filtering: Tests for locally filtering characters by their status.
 - Pagination: Ensures that pagination is handled correctly.
 - Error Handling: Verifies error handling and ensures the error messages are displayed when necessary.

## Running Tests
  1. Open Xcode.
  2. Select the target RickAndMortyAppTests.
  3. Press Cmd + U to run the unit tests.
