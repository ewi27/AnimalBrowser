//
//  AnimalQueryRepositort.swift
//  AnimalBrowser
//
//  Created by Ewelina on 18/07/2023.
//

protocol AnimalSaveQueryRepository {
    func saveQuery(query: AnimalQuery,
                   completion: @escaping (Result<AnimalQuery, Error>) -> Void)
}

protocol AnimalFetchQueriesRepository {
    func fetchQueries(queriesCount: Int,
                      completion: @escaping (Result<[AnimalQuery], Error>) -> Void)
}
