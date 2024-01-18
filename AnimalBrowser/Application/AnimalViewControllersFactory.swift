//
//  ViewControllerFactory.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/08/2023.
//

import UIKit
import SwiftUI

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
    
    private func makeAnimalQueriesViewModel(selectingAction: @escaping (AnimalQuery) -> Void) -> AnimalQueriesListViewModel {
        return AnimalQueriesListViewModel(numberOfQueriesToShow: 10, selectingAction: selectingAction)
    }
    
    func makeTaxonomyViewController(model: AnimalTaxonomy) -> UIViewController {
        return TaxonomyViewController(viewModel: makeTaxonomyViewModel(model: model))
    }
    
    private func makeTaxonomyViewModel(model: AnimalTaxonomy) -> TaxonomyViewModel {
        return TaxonomyViewModel(model: model)
    }
    
    func makeCharacteristicsViewController(model: AnimalCharacteristics) -> UIViewController {
        //SwiftUI lub UIKit
        if #available(iOS 17.0, *) {
            let swiftUIView = CharacteristicsViewSwiftUI(viewModelWrapper: self.makeCharacteristicsViewModelWrapper(model: model))
            let hostingVC = UIHostingController(rootView: swiftUIView)
            return hostingVC
        } else {
            return CharacteristicsViewController(viewModel: makeCharacteristicsViewModel(model: model))
        }
    }
    
    private func makeCharacteristicsViewModelWrapper(model: AnimalCharacteristics) -> CharacteristicsViewModelWrapper {
        return CharacteristicsViewModelWrapper(viewModel: makeCharacteristicsViewModel(model: model))
    }
    
    private func makeCharacteristicsViewModel(model: AnimalCharacteristics) -> CharacteristicsViewModel {
        return CharacteristicsViewModel(model: model)
    }
    
    func makeAnimalFlowCoordinator() -> AnimalFlowCoordinator {
        return AnimalFlowCoordinator(navigationController: navigationController, dependencies: self, detailDependencies: self)
    }
}
