//
//  Coordinator.swift
//  Characters
//
//  Created by Mohamed Sayed on 16/10/2024.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
}

