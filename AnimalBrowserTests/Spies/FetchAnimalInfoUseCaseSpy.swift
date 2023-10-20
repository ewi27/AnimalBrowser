//
//  FetchAnimalInfoUseCaseSpy.swift
//  AnimalBrowserTests
//
//  Created by Ewelina on 27/09/2023.
//

@testable import AnimalBrowser

final class FetchAnimalInfoUseCaseSpy: FetchAnimalInfoUseCase {
    
    var executeCallsCount = 0
    var executeReceivedArguments: (query: AnimalQuery, result: (Result<Animals, Error>) -> ()?)?
    
    func execute(query: AnimalQuery,
                 completion: @escaping (Result<Animals, Error>) -> ()?) {
        self.executeCallsCount += 1
        self.executeReceivedArguments = (query: query, result: completion)
    }
}
