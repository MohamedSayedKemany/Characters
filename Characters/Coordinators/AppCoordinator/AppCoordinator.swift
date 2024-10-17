//
//  AppCoordinator.swift
//  Characters
//
//  Created by Mohamed Sayed on 16/10/2024.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let characterListCoordinator = CharacterListCoordinator(navigationController: navigationController)
        characterListCoordinator.start()
    }
}

