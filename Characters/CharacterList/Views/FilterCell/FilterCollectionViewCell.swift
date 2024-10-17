//
//  FilterCollectionViewCell.swift
//  Characters
//
//  Created by Mohamed Sayed on 14/10/2024.
//

import UIKit
import SwiftUI

class FilterCollectionViewCell: UICollectionViewCell {
    private var hostingController: UIHostingController<FilterCellView>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHostingController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHostingController() {
        let initialSwiftUIView = FilterCellView(title: "", isSelected: false)
        hostingController = UIHostingController(rootView: initialSwiftUIView)
        
        if let hostingView = hostingController?.view {
            hostingView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(hostingView)
            
            NSLayoutConstraint.activate([
                hostingView.topAnchor.constraint(equalTo: contentView.topAnchor),
                hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                hostingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hostingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }
    }
    
    func configure(with title: String, isSelected: Bool) {
        hostingController?.rootView = FilterCellView(title: title, isSelected: isSelected)
    }
    
    override var isSelected: Bool {
        didSet {
            hostingController?.rootView = FilterCellView(
                title: hostingController?.rootView.title ?? "",
                isSelected: isSelected
            )
        }
    }
}
