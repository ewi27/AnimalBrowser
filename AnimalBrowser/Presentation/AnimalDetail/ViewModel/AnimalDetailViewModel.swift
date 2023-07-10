//
//  AnimalDetailViewModel.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//

import Foundation

class AnimalDetailViewModel {
    
    var model: DetailModel
    var sectionsList: [AnimalDetailSectionList] = [AnimalDetailSectionList]()
    var giveTaxonomy: ((AnimalTaxonomy) -> ())?
    var giveCharacteristics: ((AnimalCharacteristics) -> ())?
    
    init(model: DetailModel) {
        self.model = model
    }
    
    func makeSections() -> [AnimalDetailSectionList] {
        self.sectionsList.append(.taxonomy("Click Taxonomy"))
        self.sectionsList.append(.locations(model.locations))
        self.sectionsList.append(.characteristics("Click Characteristics"))
        return sectionsList
    }
    
    func numberOfSections() -> Int {
        self.sectionsList.count
    }
    
    func numberOfCell(at section: Int) -> Int {
        self.sectionsList[section].cellCount
    }
    
    func sectionsTitle(at section: Int) -> String {
        self.sectionsList[section].sectionTitle
    }
    
    func pressTaxonomy() {
        self.giveTaxonomy?(model.taxonomy)
    }
    
    func pressCharacteristics() {
        self.giveCharacteristics?(model.characteristics)
    }
}
