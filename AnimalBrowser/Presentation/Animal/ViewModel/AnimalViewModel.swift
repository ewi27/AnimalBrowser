//
//  AnimalViewModel.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//

import Foundation

final class AnimalViewModel {
    
    private var fetchAnimalInfoUseCase: FetchAnimalInfoUseCase
    var sectionsList: [AnimalSectionList] = [AnimalSectionList]() {
        didSet {
            self.giveSections?(sectionsList)
            self.reloadData?()
        }
    }
    var animalModel: Animal = Animal()
    var detailModel: [DetailModel] = [DetailModel]()
    var reloadData: (() -> ())?
    var giveSections: (([AnimalSectionList]) -> ())?
    var giveDetailSections: ((DetailModel) -> ())?
    var startActivityIndicator: (() -> ())?
    var stopActivityIndicator: (() -> ())?
    
    init(fetchAnimalInfoUseCase: FetchAnimalInfoUseCase = DefaultFetchAnimalInfoUseCase()) {
        self.fetchAnimalInfoUseCase = fetchAnimalInfoUseCase
    }
    
    func didSearch(query: String) {
        startActivityIndicator?()
        fetchData(query: AnimalQuery(query: query))
    }
    
    func pressName(section: Int, row: Int) {
        switch sectionsList[section] {
        case .animalName:
            giveDetailSections?(detailModel[row])
        }
    }
    
    func clearTable() {
        sectionsList.removeAll()
    }
    
    private func fetchData(query: AnimalQuery) {
        fetchAnimalInfoUseCase.execute(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.setupSections(model: model)
                    self.setupDetailSections(model: model)
                    self.stopActivityIndicator?()
                case .failure(let error): print(error)
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
