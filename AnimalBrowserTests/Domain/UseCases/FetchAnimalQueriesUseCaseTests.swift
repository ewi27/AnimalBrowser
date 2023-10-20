//
//  FetchAnimalQueriesUseCase.swift
//  AnimalBrowserTests
//
//  Created by Ewelina on 06/10/2023.
//

import XCTest
@testable import AnimalBrowser

final class FetchAnimalQueriesUseCaseTests: XCTestCase {
    
    var sut: FetchAnimalQueriesUseCase!
    var animalFetchQueriesRepository: AnimalFetchQueriesRepositoryMock!
    
    override func setUp() {
        super.setUp()
        
        animalFetchQueriesRepository = .init()
        sut = DefaultFetchAnimalQueriesUseCase(queriesRepository: animalFetchQueriesRepository)
    }
    
    func test_fetchAnimalQueriesUseCaseExecuted_withSuccess() {
        var fetchAnimalQueriesUseCaseCallsCount = 0
        
        sut.execute(queriesCount: 1) { result in
            switch result {
            case .success(let queries):
                fetchAnimalQueriesUseCaseCallsCount += 1
                XCTAssertEqual(self.animalFetchQueriesRepository.resultAnimalQueries, queries)
                XCTAssertEqual(self.animalFetchQueriesRepository.fetchCallsCount, 1)
            case .failure(_):
                XCTFail("Fetching data should not fail")
            }
        }
        
        XCTAssertEqual(fetchAnimalQueriesUseCaseCallsCount, 1)
        XCTAssertEqual(self.animalFetchQueriesRepository.capturedQueriesCount, 1)
    }
    
    func test_fetchAnimalQueriesUseCaseExecuted_withFailure() {
        var fetchAnimalQueriesUseCaseCallsCount = 0
        var queries = [AnimalQuery]()
        animalFetchQueriesRepository.shouldFail = true
        
        sut.execute(queriesCount: 1) { result in
            fetchAnimalQueriesUseCaseCallsCount += 1
            queries = (try? result.get()) ?? []
        }
        
        XCTAssertTrue(queries.isEmpty)
        XCTAssertEqual(self.animalFetchQueriesRepository.fetchCallsCount, 1)
        XCTAssertEqual(fetchAnimalQueriesUseCaseCallsCount, 1)
    }
}

class AnimalFetchQueriesRepositoryMock: AnimalFetchQueriesRepository {
    var resultAnimalQueries = [AnimalQuery(query: "query")]
    enum TestError: Error {
        case myError
    }
    var fetchCallsCount = 0
    var capturedQueriesCount: Int?
    var shouldFail = false
    
    func fetchQueries(queriesCount: Int,
                      completion: @escaping (Result<[AnimalQuery], Error>) -> Void) {
        fetchCallsCount += 1
        capturedQueriesCount = queriesCount
        if shouldFail {
            completion(.failure(TestError.myError))
        } else {
            completion(.success(resultAnimalQueries))
        }
    }
}
