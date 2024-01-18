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

/*
 Mapowanie modelu zgodnego z Decodable na model domenowy jest często używane z kilku powodów:
 Separacja warstw: W aplikacjach stosujących architekturę Clean lub podobne, mapowanie modeli pomaga w utrzymaniu oddzielenia warstw. Model domenowy jest używany w logice biznesowej i jest niezależny od struktury danych z bazy lub zewnętrznego źródła.
 Elastyczność i czytelność: Model domenowy może być dostosowany do potrzeb aplikacji lub logiki biznesowej. Czasami modele pochodzące bezpośrednio z bazy danych mogą zawierać więcej informacji niż potrzebne w warstwie logiki biznesowej. Mapowanie umożliwia filtrowanie danych i wybieranie tylko potrzebnych informacji.
 Testowalność: Model domenowy może być łatwiej testowany. Uproszczona struktura może być bardziej elastyczna i bardziej odpowiednia do testowania jednostkowego w warstwie logiki biznesowej.
 Uniezależnienie od warstwy danych: Model domenowy jest niezależny od struktury bazy danych lub API. Jeśli źródło danych ulegnie zmianie, jedyną konieczną modyfikacją będzie mapowanie na warstwę domenową, a nie bezpośrednie zmiany w logice biznesowej.
 Wprowadzenie warstwy mapowania pomaga w tworzeniu bardziej elastycznej i łatwiejszej do utrzymania aplikacji. Pomaga to także w zachowaniu czystości kodu i separacji warstw, co ma kluczowe znaczenie w większych projektach aplikacji.
 */
