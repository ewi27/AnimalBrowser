//
//  AnimalQueryStorageSpy.swift
//  AnimalBrowserTests
//
//  Created by Ewelina on 20/10/2023.
//

@testable import AnimalBrowser

final class AnimalQueryStorageSpy: AnimalQueryStorage {
    var capturedQueryToSave: AnimalQuery?
    var queriesToFetch = [AnimalQuery(query: "query")]
    var capturedQueriesCount: Int?
    enum TestError: Error {
        case myError
    }
    var saveQueryShouldFail = false
    var fetchQueryShouldFail = false
    var saveQueryCallsCount = 0
    var fetchQueriesCallsCount = 0
    
    func saveQuery(query: AnimalBrowser.AnimalQuery, completion: @escaping (Result<AnimalBrowser.AnimalQuery, Error>) -> Void) {
        saveQueryCallsCount += 1
        capturedQueryToSave = query
        if saveQueryShouldFail {
            completion(.failure(TestError.myError))
        } else {
            completion(.success(query))
        }
    }
    
    func fetchQueries(queriesCount: Int, completion: @escaping (Result<[AnimalBrowser.AnimalQuery], Error>) -> Void) {
        fetchQueriesCallsCount += 1
        capturedQueriesCount = queriesCount
        if fetchQueryShouldFail {
            completion(.failure(TestError.myError))
        } else {
            completion(.success(queriesToFetch))
        }
    }
}
