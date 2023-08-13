//
//  AnimalQueryStorage.swift
//  AnimalBrowser
//
//  Created by Ewelina on 23/07/2023.
//

import Foundation
import CoreData

protocol AnimalQueryStorage {
    func saveQuery(query: AnimalQuery,
                   completion: @escaping (Result<AnimalQuery, Error>) -> Void)
    func fetchQueries(completion: @escaping (Result<[AnimalQuery], Error>) -> Void)
}

final class CoreDataAnimalQueriesStorage: AnimalQueryStorage {
    
    let coreDataStorage = CoreDataStorage()
    
    func saveQuery(query: AnimalQuery,
                   completion: @escaping (Result<AnimalQuery, Error>) -> Void) {
        
        coreDataStorage.performBackgroundTask { context in
            do {
                let entity = AnimalQueryEntity(animalQuery: query, context: context)
                try context.save()
                completion(.success(entity.mapToDomain()))
            }
            catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchQueries(completion: @escaping (Result<[AnimalQuery], Error>) -> Void) {
        
        coreDataStorage.performBackgroundTask { context in
            do {
                let request = AnimalQueryEntity.fetchRequest()
                let result = try context.fetch(request).map { $0.mapToDomain() }
                print(result)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
