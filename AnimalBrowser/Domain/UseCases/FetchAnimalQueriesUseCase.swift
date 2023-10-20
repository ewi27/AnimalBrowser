//
//  FetchAnimalQueriesUseCase.swift
//  AnimalBrowser
//
//  Created by Ewelina on 03/08/2023.
//

import Foundation

protocol FetchAnimalQueriesUseCase {
    func execute(queriesCount: Int,
                 completion: @escaping (Result<[AnimalQuery], Error>) -> Void)
}

final class DefaultFetchAnimalQueriesUseCase: FetchAnimalQueriesUseCase {
    
    private let queriesRepository: AnimalFetchQueriesRepository
    
    init(queriesRepository: AnimalFetchQueriesRepository = DefaultAnimalQueryRepository()) {
        self.queriesRepository = queriesRepository
    }
    
    func execute(queriesCount: Int, completion: @escaping (Result<[AnimalQuery], Error>) -> Void) {
        queriesRepository.fetchQueries(queriesCount: queriesCount, completion: completion)
    }
}
