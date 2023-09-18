//
//  ViewControllerFactory.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/08/2023.
//

import UIKit

final class AnimalViewControllersFactory: AnimalFlowCoordinatorDependencies, AnimalDetailFlowCoordinatorDependencies {
    
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func makeAnimalViewController(actions: AnimalViewModelActivities) -> AnimalListViewController {
        return AnimalListViewController(viewModel: makeAnimalViewModel(actions: actions))
    }
    
    private func makeAnimalViewModel(actions: AnimalViewModelActivities) -> AnimalViewModel {
        return AnimalViewModel(viewModelActivities: actions)
    }
    
    func makeAnimalDetailViewController(detail: DetailModel, actions: AnimalDetailViewModelActivities) -> UIViewController {
        AnimalDetailViewController(viewModel: makeDetailViewModel(detail: detail, actions: actions))
        //  AnimalDetailViewController(viewModel: AnimalDetailViewModel(model: detail, actions: actions))
    }
    
    private func makeDetailViewModel(detail: DetailModel, actions: AnimalDetailViewModelActivities) -> AnimalDetailViewModel {
        return AnimalDetailViewModel(model: detail, actions: actions)
    }
    
    func makeAnimalQueriesViewController(selectingAction: @escaping (AnimalQuery) -> Void) -> UIViewController {
        let vc = UIStoryboard(name: "AnimalQueriesStoryboard", bundle: nil).instantiateViewController(identifier: "storyboard") { coder in
            return AnimalQueriesViewController(coder: coder, viewModel: self.makeAnimalQueriesViewModel(selectingAction: selectingAction))
        }
        return vc
    }
    
    func makeAnimalQueriesViewModel(selectingAction: @escaping (AnimalQuery) -> Void) -> AnimalQueriesListViewModel {
        return AnimalQueriesListViewModel(numberOfQueriesToShow: 10, selectingAction: selectingAction)
    }
    
    func makeAnimalFlowCoordinator() -> AnimalFlowCoordinator {
        return AnimalFlowCoordinator(navigationController: navigationController, dependencies: self, detailDependencies: self)
    }
    
    func makeTaxonomyViewController(model: AnimalTaxonomy) -> UIViewController {
        return TaxonomyViewController(viewModel: TaxonomyViewModel(model: model))
    }
    
    func makeCharacteristicsViewController(model: AnimalCharacteristics) -> UIViewController {
        return CharacteristicsViewController(viewModel: CharacteristicsViewModel(model: model))
    }
}
