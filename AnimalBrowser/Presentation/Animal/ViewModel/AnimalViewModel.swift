//
//  AnimalViewModel.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//

//dzialania informujace AnimalFlowCoordinator, kiedy wyswietlic inne widoki; struct zeby moc ew. dodac kolejne akcje

import Foundation

struct AnimalViewModelActivities {
    let showAnimalDetails: (DetailModel) -> Void
    let showAnimalQueriesList: (@escaping (_ selectingAction: AnimalQuery) -> Void) -> Void
    let closeAnimalQueriesList: () -> Void?
}

final class AnimalViewModel {
    
    private var viewModelActivities: AnimalViewModelActivities?
    private var fetchAnimalInfoUseCase: FetchAnimalInfoUseCase
    private var sectionsList: [AnimalSectionList] = [AnimalSectionList]() {
        didSet {
            self.giveSections?(sectionsList)
            self.reloadData?()
        }
    }
    private var animalModel: Animals = Animals()
    private var detailModel: [DetailModel] = [DetailModel]()
    var reloadData: (() -> ())?
    var giveSections: (([AnimalSectionList]) -> ())?
    var startActivityIndicator: (() -> ())?
    var stopActivityIndicator: (() -> ())?
    var giveError: ((String) -> ())?
    var giveSearchBarQuery: ((String) -> ())?
    let searchBarPlaceholderText = "SEARCH ANIMAL"
    private let queue: DispatchQueueType
    
    init(viewModelActivities: AnimalViewModelActivities? = nil, fetchAnimalInfoUseCase: FetchAnimalInfoUseCase = DefaultFetchAnimalInfoUseCase(),
         queue: DispatchQueueType = DispatchQueue.main) {
        self.viewModelActivities = viewModelActivities
        self.fetchAnimalInfoUseCase = fetchAnimalInfoUseCase
        self.queue = queue
    }
    
    func didSearch(query: String) {
        giveSearchBarQuery?(query)
        clearList()
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
    
    private func clearList() {
        sectionsList.removeAll()
    }
    
    private func tappedAnimalQuery(animalQuery: AnimalQuery) {
        giveSearchBarQuery?(animalQuery.query)
        clearList()
        startActivityIndicator?()
        fetchData(query: animalQuery)
    }
    
    private func fetchData(query: AnimalQuery) {
        fetchAnimalInfoUseCase.execute(query: query) { result in
            self.queue.async {
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
    
    private func setupSections(model: Animals) {
        sectionsList.append(.animalName(model.map { $0.name }))
    }
    
    private func setupDetailSections(model: Animals) {
        detailModel = model.map { element in
            DetailModel.init(taxonomy: element.taxonomy, locations: element.locations, characteristics: element.characteristics)
        }
    }
}
