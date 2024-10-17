//
//  CharacterCellView.swift
//  Characters
//
//  Created by Mohamed Sayed on 16/10/2024.
//

import SwiftUI

struct CharacterCellView: View {
    let character: Character
    
    var body: some View {
        HStack(alignment: .top) {
            if let image = character.image, let imageUrl = URL(string: image) {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .padding([.vertical, .leading], 10)
                } placeholder: {
                    VStack(alignment: .center) {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    
                }
            }
            
            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.headline)
                Text(character.species)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding([.vertical, .leading], 10)
            
            Spacer()
        }
       
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray, lineWidth: 1)
        )
    }
}


#Preview {
    CharacterCellView(character: Character(id: 1, name: "james", species: "", status: "", gender: "", image: ""))
}
