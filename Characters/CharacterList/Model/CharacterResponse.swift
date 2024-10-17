//
//  CharacterResponse.swift
//  Characters
//
//  Created by Mohamed Sayed on 14/10/2024.
//

import Foundation

struct CharacterResponse: Decodable {
    let results: [Character]
}

struct Character: Decodable {
    let id: Int
    let name: String
    let species: String
    let status: String
    let gender: String
    let image: String?
}
