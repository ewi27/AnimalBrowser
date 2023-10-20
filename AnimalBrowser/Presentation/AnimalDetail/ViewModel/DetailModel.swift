//
//  DetailModel.swift
//  AnimalBrowser
//
//  Created by Ewelina on 04/07/2023.
//

struct DetailModel: Equatable {
    static func == (lhs: DetailModel, rhs: DetailModel) -> Bool {
        return lhs.taxonomy == rhs.taxonomy &&
               lhs.locations == rhs.locations &&
               lhs.characteristics == rhs.characteristics
    }
    
    let taxonomy: AnimalTaxonomy
    let locations: [String]
    let characteristics: AnimalCharacteristics
}
