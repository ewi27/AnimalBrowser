//
//  FetchAnimalInfoUseCaseTests.swift
//  AnimalBrowserTests
//
//  Created by Ewelina on 09/10/2023.
//

import XCTest
@testable import AnimalBrowser

final class FetchAnimalInfoUseCaseTests: XCTestCase {
    
    var sut: DefaultFetchAnimalInfoUseCase!
    var animalRepositoryMock: AnimalRepositoryMock!
    var animalSaveQueryRepositoryMock: AnimalSaveQueryRepositoryMock!
    
    override func setUp() {
        super.setUp()
        
        animalRepositoryMock = AnimalRepositoryMock()
        animalSaveQueryRepositoryMock = AnimalSaveQueryRepositoryMock()
        sut = DefaultFetchAnimalInfoUseCase(animalRepository: animalRepositoryMock,
                                                               animalQueriesRepository: animalSaveQueryRepositoryMock)
    }
    
    func test_fetchAnimalInfoUseCaseExecuted_withSuccessfullyFetchesAnimalsForQuery_AndSaveQuery() {
        var fetchAnimalInfoUseCaseExecuteCallsCount = 0
        
        sut.execute(query: AnimalQuery(query: "query")) { result in
            fetchAnimalInfoUseCaseExecuteCallsCount += 1
            switch result {
            case .success(let animals):
                XCTAssertEqual(self.animalRepositoryMock.testAnimals, animals)
            case .failure(_):
                XCTFail("Fetching data should not fail")
            }
        }
        
        XCTAssertEqual(self.animalRepositoryMock.fetchAnimalInfoCallsCount, 1)
        XCTAssertEqual(self.animalSaveQueryRepositoryMock.saveQueryCallsCount, 1)
        XCTAssertEqual(self.animalRepositoryMock.capturedQuery, AnimalQuery(query: "query"))
        XCTAssertEqual(self.animalSaveQueryRepositoryMock.capturedQuery, AnimalQuery(query: "query"))
    }
    
    func test_fetchAnimalInfoUseCaseExecuted_withFailedFetchesAnimalsForQuery_AndQueryNotSaved() {
        var fetchAnimalInfoUseCaseExecuteCallsCount = 0
        var animals = [Animal]()
        animalRepositoryMock.shouldFail = true
        
        sut.execute(query: AnimalQuery(query: "query")) { result in
            fetchAnimalInfoUseCaseExecuteCallsCount += 1
            switch result {
            case .success(_):
                XCTFail("Fetching data should not be success")
            case .failure(_):
                animals = (try? result.get()) ?? []
            }
        }
        
        XCTAssertTrue(animals.isEmpty)
        XCTAssertEqual(fetchAnimalInfoUseCaseExecuteCallsCount, 1)
        XCTAssertEqual(self.animalRepositoryMock.fetchAnimalInfoCallsCount, 1)
        XCTAssertEqual(self.animalSaveQueryRepositoryMock.saveQueryCallsCount, 0)
        XCTAssertEqual(self.animalRepositoryMock.capturedQuery, AnimalQuery(query: "query"))
        XCTAssertEqual(self.animalSaveQueryRepositoryMock.capturedQuery, nil)
    }
}

class AnimalRepositoryMock: AnimalRepository {
    var fetchAnimalInfoCallsCount = 0
    var testAnimals = [Animal(name: "", taxonomy: AnimalTaxonomy(kingdom: "", phylum: "", taxonomyClass: "", order: "", family: "", genus: "", scientificName: ""), locations: [], characteristics: AnimalCharacteristics(prey: "", habitat: "", diet: "", lifestyle: "", location: "", color: "", lifespan: "", weight: ""))]
    enum TestError: Error {
        case myError
    }
    var capturedQuery: AnimalQuery?
    var shouldFail = false
    
    func fetchAnimalInfo(query: AnimalBrowser.AnimalQuery,
                         completion: @escaping (Result<AnimalBrowser.Animals, Error>) -> ()?) {
        fetchAnimalInfoCallsCount += 1
        capturedQuery = query
        if shouldFail {
            completion(.failure(TestError.myError))
        } else {
            completion(.success(testAnimals))
        }
    }
}

class AnimalSaveQueryRepositoryMock: AnimalSaveQueryRepository {
    var saveQueryCallsCount = 0
    enum TestError: Error {
        case myError
    }
    var capturedQuery: AnimalQuery?
    var shouldFail = false
    
    func saveQuery(query: AnimalBrowser.AnimalQuery,
                   completion: @escaping (Result<AnimalBrowser.AnimalQuery, Error>) -> Void) {
        saveQueryCallsCount += 1
        capturedQuery = query
        if shouldFail {
            completion(.failure(TestError.myError))
        } else {
            completion(.success(query))
        }
    }
}
