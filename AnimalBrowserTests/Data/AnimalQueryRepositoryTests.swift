//
//  AnimalQueryRepositoryTests.swift
//  AnimalBrowserTests
//
//  Created by Ewelina on 19/10/2023.
//

import XCTest
@testable import AnimalBrowser

final class AnimalQueryRepositoryTests: XCTestCase {
    
    var animalQueryPersistentStorage: AnimalQueryStorageSpy!
    var sut: DefaultAnimalQueryRepository!
    
    override func setUp() {
        super.setUp()
        
        animalQueryPersistentStorage = .init()
        sut = DefaultAnimalQueryRepository(animalQueryPersistentStorage: animalQueryPersistentStorage)
    }
    
    func test_saveQueryWithSuccess() {
        var animalQuery = AnimalQuery(query: "query")
        var saveQueryCallsCount = 0
        
        sut.saveQuery(query: animalQuery) { result in
            saveQueryCallsCount += 1
            switch result {
            case .success(let query):
                XCTAssertEqual(animalQuery, query)
            case .failure(_):
                XCTFail("Should't be failed")
            }
        }
        
        XCTAssertEqual(saveQueryCallsCount, 1)
        XCTAssertEqual(self.animalQueryPersistentStorage.saveQueryCallsCount, 1)
        XCTAssertEqual(animalQuery, animalQueryPersistentStorage.capturedQueryToSave)
    }
    
    func test_saveQueryWithFailure() {
        var animalQuery = AnimalQuery(query: "query")
        var resultQuery: AnimalQuery?
        var saveQueryCallsCount = 0
        animalQueryPersistentStorage.saveQueryShouldFail = true
        
        sut.saveQuery(query: animalQuery) { result in
            saveQueryCallsCount += 1
            switch result {
            case .success(_):
                XCTFail("Fetching data should not be success")
            case .failure(_):
                resultQuery = (try? result.get())
                XCTAssertTrue(resultQuery == nil)
            }
            
            XCTAssertEqual(saveQueryCallsCount, 1)
            XCTAssertEqual(self.animalQueryPersistentStorage.saveQueryCallsCount, 1)
        }
    }
    
    func test_fetchQueriesWithSuccess() {
        var fetchQueriesCallsCount = 0
        
        sut.fetchQueries(queriesCount: 1) { result in
            fetchQueriesCallsCount += 1
            switch result {
            case .success(let queries):
                XCTAssertEqual(self.animalQueryPersistentStorage.queriesToFetch, queries)
            case .failure(_):
                XCTFail("Should't be failed")
            }
        }
        
        XCTAssertEqual(fetchQueriesCallsCount, 1)
        XCTAssertEqual(self.animalQueryPersistentStorage.fetchQueriesCallsCount, 1)
        XCTAssertEqual(self.animalQueryPersistentStorage.capturedQueriesCount, 1)
    }
    
    func test_fetchQueriesWithFailure() {
        var resultQueries: [AnimalQuery]?
        var fetchQueriesCallsCount = 0
        animalQueryPersistentStorage.fetchQueryShouldFail = true
        
        sut.fetchQueries(queriesCount: 1) { result in
            fetchQueriesCallsCount += 1
            switch result {
            case .success(_):
                XCTFail("Fetching data should not be success")
            case .failure(_):
                resultQueries = (try? result.get()) ?? []
                XCTAssertEqual(resultQueries, [])
            }
        }
        
        XCTAssertEqual(fetchQueriesCallsCount, 1)
        XCTAssertEqual(self.animalQueryPersistentStorage.fetchQueriesCallsCount, 1)
        XCTAssertEqual(self.animalQueryPersistentStorage.capturedQueriesCount, 1)
    }
}
