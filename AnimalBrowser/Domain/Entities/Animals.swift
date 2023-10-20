//
//  Animal.swift
//  AnimalBrowser
//
//  Created by Ewelina on 12/06/2023.
//

typealias Animals = [Animal]

struct Animal: Equatable {
    let name: String
    let taxonomy: AnimalTaxonomy
    let locations: [String]
    let characteristics: AnimalCharacteristics
}

struct AnimalCharacteristics: Equatable {
    let prey: String?
    let habitat: String?
    let diet: String?
    let lifestyle: String?
    let location: String?
    let color: String?
    let lifespan: String?
    let weight: String?
}

struct AnimalTaxonomy: Equatable {
    let kingdom: String
    let phylum: String
    let taxonomyClass: String
    let order: String?
    let family: String?
    let genus: String?
    let scientificName: String?
}
