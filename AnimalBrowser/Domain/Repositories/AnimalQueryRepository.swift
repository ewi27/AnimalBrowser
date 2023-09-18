//
//  AnimalQueryRepositort.swift
//  AnimalBrowser
//
//  Created by Ewelina on 18/07/2023.
//

import Foundation

protocol AnimalQueryRepository {
    func saveQuery(query: AnimalQuery,
                   completion: @escaping (Result<AnimalQuery, Error>) -> Void)
    func fetchQueries(queriesCount: Int,
                      completion: @escaping (Result<[AnimalQuery], Error>) -> Void)
}

