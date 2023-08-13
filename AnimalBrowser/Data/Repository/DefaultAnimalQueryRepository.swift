//
//  DefaultAnimalQueryRepository.swift
//  AnimalBrowser
//
//  Created by Ewelina on 23/07/2023.
//

import Foundation

final class DefaultAnimalQueryRepository: AnimalQueryRepository {

  private let animalQueryPersistentStorage: AnimalQueryStorage
    
    init(animalQueryPersistentStorage: AnimalQueryStorage = CoreDataAnimalQueriesStorage()) {
        self.animalQueryPersistentStorage = animalQueryPersistentStorage
    }
    
    func saveQuery(query: AnimalQuery, completion: @escaping (Result<AnimalQuery, Error>) -> Void) {
        animalQueryPersistentStorage.saveQuery(query: query, completion: completion)
    }
    
    func fetchQueries(completion: @escaping (Result<[AnimalQuery], Error>) -> Void) {
        animalQueryPersistentStorage.fetchQueries(completion: completion)
    }
}
