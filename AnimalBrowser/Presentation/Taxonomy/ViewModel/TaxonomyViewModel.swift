//
//  TaxonomyViewModel.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//

import Foundation

final class TaxonomyViewModel {
    
    private var model: AnimalTaxonomy
    var update: ((TaxonomyView.Model) -> ())?
    
    init(model: AnimalTaxonomy) {
        self.model = model
    }
    
    func viewDidLoad() {
        self.update?(prepareTaxonomy(model: model))
    }
    
    private func prepareTaxonomy(model: AnimalTaxonomy) -> TaxonomyView.Model {
        return .init(
            kingdomText: model.kingdom,
            phylumText: model.phylum,
            taxonomyClassText: model.taxonomyClass,
            orderText: model.order,
            familyText: model.family,
            genusText: model.genus,
            scientificNameText: model.scientificName)
    }
}
