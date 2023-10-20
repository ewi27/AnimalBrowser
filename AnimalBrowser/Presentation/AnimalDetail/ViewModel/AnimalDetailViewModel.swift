//
//  AnimalDetailViewModel.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//

struct AnimalDetailViewModelActivities {
    let showTaxonomy: (AnimalTaxonomy) -> Void?
    let showCharacteristics: (AnimalCharacteristics) -> Void?
}

final class AnimalDetailViewModel {
    
    private let actions: AnimalDetailViewModelActivities?
    private let model: DetailModel
    private var sectionsList: [AnimalDetailSectionList] = [AnimalDetailSectionList]()
    
    init(model: DetailModel, actions: AnimalDetailViewModelActivities?) {
        self.model = model
        self.actions = actions
    }
    
    func makeSections() -> [AnimalDetailSectionList] {
        sectionsList.append(.taxonomy("Click Taxonomy"))
        sectionsList.append(.locations(model.locations))
        sectionsList.append(.characteristics("Click Characteristics"))
        return sectionsList
    }
    
    func numberOfSections() -> Int {
        sectionsList.count
    }
    
    func numberOfCell(at section: Int) -> Int {
        sectionsList[section].cellCount
    }
    
    func sectionsTitle(at section: Int) -> String {
        sectionsList[section].sectionTitle
    }
    
    func pressTaxonomy() {
        actions?.showTaxonomy(model.taxonomy)
    }
    
    func pressCharacteristics() {
        actions?.showCharacteristics(model.characteristics)
    }
}
