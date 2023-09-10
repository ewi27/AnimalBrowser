//
//  AppFlowCoordinator.swift
//  AnimalBrowser
//
//  Created by Ewelina on 13/08/2023.
//

import UIKit

final class AppFlowCoordinator {
    
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let factory = AnimalViewControllersFactory(navigationController: navigationController)
        let animalFlow = factory.makeAnimalFlowCoordinator()
        animalFlow.start()
    }
}
