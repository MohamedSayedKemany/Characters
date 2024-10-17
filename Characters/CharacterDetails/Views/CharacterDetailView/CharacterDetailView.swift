//
//  CharacterDetailView.swift
//  Characters
//
//  Created by Mohamed Sayed on 14/10/2024.
//

import SwiftUI

import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    
    var body: some View {
        VStack(alignment: .leading) {
            if let image = character.image, let imageUrl = URL(string: image) {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: 400)
                } placeholder: {
                    VStack(alignment: .center) {
                        Spacer()
                        HStack(alignment: .center) {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
            
            VStack {
                HStack {
                    Text(character.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Spacer()
                    Text(character.status)
                        .padding(3)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                HStack {
                    Text(character.species)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    Text(character.gender)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    CharacterDetailView(character: Character(id: 1, name: "Johnny Depp", species: "Human", status: "Alive", gender: "Male", image: "https://rickandmortyapi.com/api/character/avatar/183.jpeg"))
}
