//
//  AnimalRepositoryTests.swift
//  AnimalBrowserTests
//
//  Created by Ewelina on 12/10/2023.
//

import XCTest

@testable import AnimalBrowser
final class AnimalRepositoryTests: XCTestCase {
    
    var dataTransferService: DataTransferServiceSpy!
    var sut: DefaultAnimalRepository!
    
    override func setUp() {
        super.setUp()
        
        dataTransferService = .init()
        sut = DefaultAnimalRepository(dataTransferService: dataTransferService)
    }
    
    func test_fetchAnimalInfoWithSucces() {
        let animalModelToCompare = [AnimalElement(name: "", taxonomy: Taxonomy(kingdom: "", phylum: "", taxonomyClass: "", order: "", family: "", genus: "", scientificName: ""), locations: [], characteristics: Characteristics(prey: "", habitat: "", diet: "", lifestyle: "", location: "", color: "", lifespan: "", weight: ""))]
        var fetchAnimalInfoCallsCount = 0
        
        sut.fetchAnimalInfo(query: AnimalQuery(query: "query")) { result in
            fetchAnimalInfoCallsCount += 1
            switch result {
            case .success(let animals):
                XCTAssertEqual(animals, animalModelToCompare.mapToDomain())
            case .failure(_):
                XCTFail("Fetching data should not fail")
            }
        }
        
        XCTAssertEqual(fetchAnimalInfoCallsCount, 1)
        XCTAssertEqual(self.dataTransferService.dataTransferServiceCallsCount, 1)
    }
    
    func test_fetchAnimalInfoWithFailure() {
        dataTransferService.shouldFailed = true
        var fetchAnimalInfoCallsCount = 0
        var animals = Animals()
        
        sut.fetchAnimalInfo(query: AnimalQuery(query: "query")) { result in
            fetchAnimalInfoCallsCount += 1
            animals = (try? result.get()) ?? []
        }
        
        XCTAssertTrue(animals.isEmpty)
        XCTAssertEqual(fetchAnimalInfoCallsCount, 1)
        XCTAssertEqual(self.dataTransferService.dataTransferServiceCallsCount, 1)
    }
}
