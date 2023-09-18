//
//  DefaultAnimalQueryRepository.swift
//  AnimalBrowser
//
//  Created by Ewelina on 23/07/2023.
//

import Foundation

final class DefaultAnimalQueryRepository: AnimalQueryRepository {
    
    private let animalQueryPersistentStorage: AnimalQueryStorage
    
    init(animalQueryPersistentStorage: AnimalQueryStorage = CoreDataAnimalQueriesStorage(queriesCount: 10)) {
        self.animalQueryPersistentStorage = animalQueryPersistentStorage
    }
    
    func saveQuery(query: AnimalQuery, completion: @escaping (Result<AnimalQuery, Error>) -> Void) {
        animalQueryPersistentStorage.saveQuery(query: query, completion: completion)
    }
    
    func fetchQueries(queriesCount: Int, completion: @escaping (Result<[AnimalQuery], Error>) -> Void) {
        animalQueryPersistentStorage.fetchQueries(queriesCount: queriesCount, completion: completion)
    }
}
