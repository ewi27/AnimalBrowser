//
//  AnimalModel.swift
//  AnimalBrowser
//
//  Created by Ewelina on 16/06/2023.
//
// Modele, na które dane sa dekodowane, plus funkcje mapujace je na modele domenowe.

import Foundation

typealias AnimalModel = [AnimalElement]

struct AnimalElement: Decodable {
    let name: String
    let taxonomy: Taxonomy
    let locations: [String]
    let characteristics: Characteristics
}

struct Characteristics: Decodable {
    let prey: String?
    let habitat: String?
    let diet: String?
    let lifestyle: String?
    let location: String?
    let color: String?
    let lifespan: String?
    let weight: String?
    
    enum CodingKeys: String, CodingKey {
        case prey, habitat, diet, lifestyle, location, color, lifespan, weight
    }
}

struct Taxonomy: Decodable {
    let kingdom, phylum, taxonomyClass: String
    let order, family, genus, scientificName: String?
    
    enum CodingKeys: String, CodingKey {
        case kingdom, phylum
        case taxonomyClass = "class"
        case order, family, genus
        case scientificName = "scientific_name"
    }
}

extension AnimalModel {
    func mapToDomain() -> Animals {
        let model = self.map { element in
            Animal.init(name: element.name,
                                   taxonomy: element.taxonomy.mapToTaxonomy(),
                                   locations: element.locations,
                                   characteristics: element.characteristics.mapToCharacteristics())
        }
        return model
    }
}

extension Characteristics {
    func mapToCharacteristics() -> AnimalCharacteristics {
        return (.init(prey: prey,
                      habitat: habitat,
                      diet: diet,
                      lifestyle: lifestyle,
                      location: location,
                      color: color,
                      lifespan: lifespan,
                      weight: weight))
    }
}

extension Taxonomy {
    func mapToTaxonomy() -> AnimalTaxonomy {
        return (.init(kingdom: kingdom,
                      phylum: phylum,
                      taxonomyClass: taxonomyClass,
                      order: order,
                      family: family,
                      genus: genus,
                      scientificName: scientificName))
    }
}
