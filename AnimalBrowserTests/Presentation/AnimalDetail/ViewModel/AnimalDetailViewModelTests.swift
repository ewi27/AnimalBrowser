//
//  AnimalDetailViewModelTests.swift
//  AnimalBrowserTests
//
//  Created by Ewelina on 02/10/2023.
//

import XCTest
@testable import AnimalBrowser

final class AnimalDetailViewModelTests: XCTestCase {
    
    //Sut - system under test - to główny punkt testu, który jest analizowany w celu sprawdzenia, czy zachowuje się zgodnie z oczekiwaniami.
    var sut: AnimalDetailViewModel!
    
    let detailModel = DetailModel(taxonomy: AnimalTaxonomy(kingdom: "", phylum: "", taxonomyClass: "", order: "", family: "", genus: "", scientificName: ""), locations: [], characteristics: AnimalCharacteristics(prey: "", habitat: "", diet: "", lifestyle: "", location: "", color: "", lifespan: "", weight: ""))
    var animalTaxonomy: AnimalTaxonomy!
    var animalCharacteristics: AnimalCharacteristics!
    
    //Metoda setUp jest uruchamiana przed każdym testem, co zapewnia, że każdy test ma czyste środowisko i nie jest zależny od innych testów. W metodzie setUp można wykonywać operacje inicjalizacyjne, przygotowywać obiekty testowe i przygotowywać środowisko tak, aby testy były powtarzalne i izolowane od siebie nawzajem.
    override func setUp() {
        super.setUp()
        
        sut = AnimalDetailViewModel(model: detailModel,
                                    actions: .init(showTaxonomy: { self.animalTaxonomy = $0 },
                                                   showCharacteristics: { self.animalCharacteristics = $0 }))
    }
    
    func test_makeSections() {
        let sections: [AnimalDetailSectionList] = [.taxonomy("Click Taxonomy"), .locations(detailModel.locations), .characteristics("Click Characteristics")]
        let result = sut.makeSections()
        
        XCTAssertEqual(sections, result)
    }
    
    func test_numberOfSections() {
        _ = sut.makeSections()
        let numberOfSections = sut.numberOfSections()
        
        XCTAssertEqual(3, numberOfSections)
    }
    
    func test_numberOfCell() {
        _ = sut.makeSections()
        let result = sut.numberOfCell(at: 0)
        let result2 = sut.numberOfCell(at: 1)
        let result3 = sut.numberOfCell(at: 2)
        
        XCTAssertEqual(1, result)
        XCTAssertEqual(0, result2)
        XCTAssertEqual(1, result3)
    }
    
    func test_sectionsTitle() {
        _ = sut.makeSections()
        let title1 = sut.sectionsTitle(at: 0)
        let title2 = sut.sectionsTitle(at: 1)
        let title3 = sut.sectionsTitle(at: 2)
        
        XCTAssertEqual("TAXONOMY", title1)
        XCTAssertEqual("LOCATIONS", title2)
        XCTAssertEqual("CHARACTERISTICS", title3)
    }
    
    func test_pressTaxonomy_called_showTaxonomy() {
        
        sut.pressTaxonomy()
        
        XCTAssertEqual(detailModel.taxonomy, animalTaxonomy)
    }
    
    func test_pressCharacteristics_called_showCharacteristics() {
        
        sut.pressCharacteristics()
        
        XCTAssertEqual(detailModel.characteristics, animalCharacteristics)
    }
}
