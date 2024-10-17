//
//  CharacterListCoordinator.swift
//  Characters
//
//  Created by Mohamed Sayed on 16/10/2024.
//

import UIKit
import SwiftUI

class CharacterListCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let characterListViewController = CharacterListViewController()
        characterListViewController.coordinator = self
        navigationController.pushViewController(characterListViewController, animated: true)
    }
    
    func showCharacterDetail(character: Character) {
        let detailView = UIHostingController(rootView: CharacterDetailView(character: character))
        navigationController.pushViewController(detailView, animated: true)
    }
}

