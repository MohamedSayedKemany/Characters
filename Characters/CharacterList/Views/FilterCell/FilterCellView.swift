//
//  FilterCellView.swift
//  Characters
//
//  Created by Mohamed Sayed on 14/10/2024.
//

import SwiftUI

struct FilterCellView: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .padding(8)
            .frame(width: 100, height: 40)
            .background(isSelected ? Color.blue : Color.gray)
            .foregroundColor(isSelected ? .black : .white)
            .cornerRadius(10)
            .fixedSize(horizontal: true, vertical: false)
    }
}


#Preview {
    FilterCellView(title: "unknown", isSelected: false)
}
