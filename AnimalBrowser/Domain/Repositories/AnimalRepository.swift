//
//  Repository.swift
//  AnimalBrowser
//
//  Created by Ewelina on 12/06/2023.
//

protocol AnimalRepository {
    func fetchAnimalInfo(query: AnimalQuery,
                         completion: @escaping (Result<Animals, Error>) -> ()?)
}
