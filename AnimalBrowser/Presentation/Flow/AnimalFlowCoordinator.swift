//
//  AnimalFlowCoordinator.swift
//  AnimalBrowser
//
//  Created by Ewelina on 14/08/2023.
// przeplyw viewControllerow zwiazany z wyszukiwaniem zwierzat: wpychanie vC z detalami o zwierzeciu, vC z sugestiami zapytan oraz vC glownego; komunikacja z view modelem glownego vc

import UIKit

protocol AnimalFlowCoordinatorDependencies {
    func makeAnimalViewController(actions: AnimalViewModelActivities) -> AnimalListViewController
    func makeAnimalDetailViewController(detail: DetailModel, actions: AnimalDetailViewModelActivities) -> UIViewController
    func makeAnimalQueriesViewController(selectingAction: @escaping (AnimalQuery) -> Void) -> UIViewController
}

protocol AnimalDetailFlowCoordinatorDependencies {
    func makeTaxonomyViewController(model: AnimalTaxonomy) -> UIViewController
    func makeCharacteristicsViewController(model: AnimalCharacteristics) -> UIViewController
}

final class AnimalFlowCoordinator {
    
    private var navigationController: UINavigationController
    private var dependencies: AnimalFlowCoordinatorDependencies
    private var detailDependencies: AnimalDetailFlowCoordinatorDependencies
    private var mainVC: AnimalListViewController?
    private var queriesListVC: UIViewController?
    
    init(navigationController: UINavigationController, dependencies: AnimalFlowCoordinatorDependencies, detailDependencies: AnimalDetailFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.detailDependencies = detailDependencies
    }
    
    func start() {
        let actions = AnimalViewModelActivities(showAnimalDetails: showAnimalDetails,
                                                showAnimalQueriesList: showAnimalQueriesList,
                                                closeAnimalQueriesList: closeAnimalQueriesList
        )
        let vc = dependencies.makeAnimalViewController(actions: actions)
        self.navigationController.pushViewController(vc, animated: false)
        mainVC = vc
    }
    
    private func showAnimalDetails(detail: DetailModel) {
        let vc = dependencies.makeAnimalDetailViewController(detail: detail, actions: makeDetailActions())
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    private func showAnimalQueriesList(selecingAction: @escaping (AnimalQuery) -> Void) {
        guard let moviesListViewController = mainVC else {return}
        let container = moviesListViewController.queriesContainer
        let vc = dependencies.makeAnimalQueriesViewController(selectingAction: selecingAction)
        moviesListViewController.add(child: vc, container: container)
        queriesListVC = vc
        if queriesListVC != nil {
            print("nie jest nilek")
        }
        container.isHidden = false
    }
    
    private func closeAnimalQueriesList() {
        queriesListVC?.removeFromParent()
        queriesListVC?.view.removeFromSuperview()
        queriesListVC = nil
        mainVC?.queriesContainer.isHidden = true
    }
    
    private func makeDetailActions() -> AnimalDetailViewModelActivities {
        let actions = AnimalDetailViewModelActivities(showTaxonomy: showTaxonomy,
                                                      showCharacteristics: showCharacteristics)
        return actions
    }
    
    private func showTaxonomy(model: AnimalTaxonomy) {
        let vc = detailDependencies.makeTaxonomyViewController(model: model)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    private func showCharacteristics(model: AnimalCharacteristics) {
        let vc = detailDependencies.makeCharacteristicsViewController(model: model)
        self.navigationController.pushViewController(vc, animated: true)
    }
}
