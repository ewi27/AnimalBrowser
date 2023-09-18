//
//  AnimalViewModel.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//

import Foundation

//dzialania informujace AnimalFlowCoordinator, kiedy wyswietlic inne widoki; struct zeby moc ew. dodac kolejne akcje
struct AnimalViewModelActivities {
    let showAnimalDetails: (DetailModel) -> Void
    let showAnimalQueriesList: (@escaping (_ selectingAction: AnimalQuery) -> Void) -> Void
    let closeAnimalQueriesList: () -> Void?
}

final class AnimalViewModel {
    
    private var viewModelActivities: AnimalViewModelActivities?
    private var fetchAnimalInfoUseCase: FetchAnimalInfoUseCase
    var sectionsList: [AnimalSectionList] = [AnimalSectionList]() {
        didSet {
            self.giveSections?(sectionsList)
            self.reloadData?()
        }
    }
    var queriesContainerHide: (() -> ())?
    var animalModel: Animal = Animal()
    var detailModel: [DetailModel] = [DetailModel]()
    var reloadData: (() -> ())?
    var giveSections: (([AnimalSectionList]) -> ())?
    var startActivityIndicator: (() -> ())?
    var stopActivityIndicator: (() -> ())?
    var giveError: ((String) -> ())?
    let searchBarPlaceholderText = "SEARCH ANIMAL"
    
    init(viewModelActivities: AnimalViewModelActivities? = nil, fetchAnimalInfoUseCase: FetchAnimalInfoUseCase = DefaultFetchAnimalInfoUseCase()) {
        self.viewModelActivities = viewModelActivities
        self.fetchAnimalInfoUseCase = fetchAnimalInfoUseCase
    }
    
    func didSearch(query: String) {
        clearTable()
        startActivityIndicator?()
        fetchData(query: AnimalQuery(query: query))
    }
    
    func pressName(section: Int, row: Int) {
        switch sectionsList[section] {
        case .animalName:
            viewModelActivities?.showAnimalDetails(detailModel[row])
        }
    }
    
    func showAnimalQueriesListVC() {
        viewModelActivities?.showAnimalQueriesList(tappedAnimalQuery(animalQuery:))
    }
    
    func closeAnimalQueriesListVC() {
        viewModelActivities?.closeAnimalQueriesList()
    }
    
    private func clearTable() {
        sectionsList.removeAll()
    }
    
    private func tappedAnimalQuery(animalQuery: AnimalQuery) {
        startActivityIndicator?()
        clearTable()
        fetchData(query: animalQuery)
        queriesContainerHide?()
    }
    
    private func fetchData(query: AnimalQuery) {
        fetchAnimalInfoUseCase.execute(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.isEmpty {
                        self.giveError?("Searched word doesn't exist")
                    }
                    self.setupSections(model: model)
                    self.setupDetailSections(model: model)
                    self.stopActivityIndicator?()
                case .failure(let error):
                    self.stopActivityIndicator?()
                    self.giveError?(error.localizedDescription)
                }
            }
        }
    }
    
    private func setupSections(model: Animal) {
        let names = model.map { $0.name }
        sectionsList.append(.animalName(names))
    }
    
    private func setupDetailSections(model: Animal) {
        detailModel = model.map { element in
            DetailModel.init(taxonomy: element.taxonomy, locations: element.locations, characteristics: element.characteristics)
        }
    }
}
