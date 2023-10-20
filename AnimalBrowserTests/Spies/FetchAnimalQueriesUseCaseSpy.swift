//
//  FetchAnimalQueryUseCaseSpy.swift
//  AnimalBrowserTests
//
//  Created by Ewelina on 05/10/2023.
//

@testable import AnimalBrowser

final class FetchAnimalQueriesUseCaseSpy: FetchAnimalQueriesUseCase {
    
    var executeCallsCount = 0
    var executeReceivedArguments: (queriesCount: Int, result: (Result<[AnimalBrowser.AnimalQuery], Error>) -> Void)?
    var resultIsFailure = false
    
    func execute(queriesCount: Int, completion: @escaping (Result<[AnimalBrowser.AnimalQuery], Error>) -> Void) {
        
        self.executeCallsCount += 1
        self.executeReceivedArguments = (queriesCount: queriesCount, result: completion)
    }
}
