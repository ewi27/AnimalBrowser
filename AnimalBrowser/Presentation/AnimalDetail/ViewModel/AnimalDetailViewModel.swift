//
//  AnimalDetailViewModel.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//

import Foundation

final class AnimalDetailViewModel {
    
    private let model: DetailModel
    private var sectionsList: [AnimalDetailSectionList] = [AnimalDetailSectionList]()
    var giveTaxonomy: ((AnimalTaxonomy) -> ())?
    var giveCharacteristics: ((AnimalCharacteristics) -> ())?
    
    init(model: DetailModel) {
        self.model = model
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
        giveTaxonomy?(model.taxonomy)
    }
    
    func pressCharacteristics() {
        giveCharacteristics?(model.characteristics)
    }
}
