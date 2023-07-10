//
//  Repository.swift
//  AnimalBrowser
//
//  Created by Ewelina on 12/06/2023.
//

import Foundation

protocol AnimalRepository {
    func fetchAnimalInfo(query: AnimalQuery,
                         completion: @escaping (Result<Animal, Error>) -> ()?)
}
