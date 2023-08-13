//
//  FetchAnimalQueriesUseCase.swift
//  AnimalBrowser
//
//  Created by Ewelina on 03/08/2023.
//

import Foundation

protocol FetchAnimalQueries {
    func execute(completion: @escaping (Result<[AnimalQuery], Error>) -> Void)
}

final class DefaultFetchAnimalQueriesUseCase: FetchAnimalQueries {
    
    private let queriesRepository: AnimalQueryRepository
    
    init(queriesRepository: AnimalQueryRepository = DefaultAnimalQueryRepository()) {
        self.queriesRepository = queriesRepository
    }
    
    func execute(completion: @escaping (Result<[AnimalQuery], Error>) -> Void) {
        queriesRepository.fetchQueries(completion: completion)
    }
}
