//
//  AnimalQueryStorage.swift
//  AnimalBrowser
//
//  Created by Ewelina on 23/07/2023.
//

import CoreData

protocol AnimalQueryStorage {
    func saveQuery(query: AnimalQuery,
                   completion: @escaping (Result<AnimalQuery, Error>) -> Void)
    func fetchQueries(queriesCount: Int, completion: @escaping (Result<[AnimalQuery], Error>) -> Void)
}

final class CoreDataAnimalQueriesStorage: AnimalQueryStorage {
    
    let queriesCount: Int
    let coreDataStorage = CoreDataStorage()
    
    init(queriesCount: Int) {
        self.queriesCount = queriesCount
    }
    
    //pobranie listy zapytań z bazy danych Core Data oraz mapowanie ich na obiekty domwenowe
    func fetchQueries(queriesCount: Int,
                      completion: @escaping (Result<[AnimalQuery], Error>) -> Void) {
        
        coreDataStorage.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = AnimalQueryEntity.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: #keyPath(AnimalQueryEntity.createdAt), ascending: false)]
                request.fetchLimit = queriesCount
                let result = try context.fetch(request).map { $0.mapToDomain() }
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    //zapisywanie zapytań do bazy danych
    func saveQuery(query: AnimalQuery,
                   completion: @escaping (Result<AnimalQuery, Error>) -> Void) {
        
        coreDataStorage.performBackgroundTask { [weak self] context in
            guard let self = self else {return}
            do {
                try self.clean(for: query, context: context)
                let entity = AnimalQueryEntity(animalQuery: query, context: context)
                try context.save()
                completion(.success(entity.mapToDomain()))
            }
            catch {
                completion(.failure(error))
            }
        }
    }
} 

extension CoreDataAnimalQueriesStorage {
    
    private func clean(for query: AnimalQuery,
                       context: NSManagedObjectContext) throws {
        //zapytanie aby pobrac AnimalQueryEntity z bazy danych
        let request: NSFetchRequest = AnimalQueryEntity.fetchRequest()
        //ustalenie sortowania wynikow wg daty
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(AnimalQueryEntity.createdAt), ascending: false)]
        //pobranie wyników
        var result = try context.fetch(request)
        //wywołanie funkcji: usuwanie zdublowanych oraz nadmiarowych zapytań
        removeDuplicateQueries(query: query, queries: &result, context: context)
        removeQueries(limit: queriesCount - 1, queries: result, context: context)
    }
    
    private func removeDuplicateQueries(query: AnimalQuery,
                                        queries: inout [AnimalQueryEntity],
                                        context: NSManagedObjectContext) {
        //encje w tablicy queries, które maja takie same zapytanie jak query, są usuwane z kontekstu Core Data dzięki context.delete
        queries.filter {$0.query == query.query}.forEach {context.delete($0)}
        //usunięte encje są również usuwane z tablicy queries
        queries.removeAll {$0.query == query.query}
    }
    
    private func removeQueries(limit: Int,
                               queries: [AnimalQueryEntity],
                               context: NSManagedObjectContext) {
        //jeśli liczba encji w tablicy queries przekroczy queriesCount - 1, to funkcja usuwa nadmiarowe encje z kontekstu
        guard queries.count > limit else {return}
        queries.suffix(queries.count - limit).forEach {context.delete($0)}
    }
}
