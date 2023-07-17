//
//  DefaultAnimalRepository.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//
// repozytorium - agregacja zrodel danych (np zdalne, lokalne) oraz mapowanie na modele domenowe

import Foundation

class DefaultAnimalRepository: AnimalRepository {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService = DefaultDataTransferService()) {
        self.dataTransferService = dataTransferService
    }
    
    func fetchAnimalInfo(query: AnimalQuery, completion: @escaping (Result<Animal, Error>) -> ()?) {
        
        let requestDTO = AnimalRequestQuery(name: query.query)
        let endpoint = AnimalAPIEndpoint().makeEndpoint(requestQuery: requestDTO)
        
        dataTransferService.request(endpoint: endpoint) { (result: Result<AnimalModel, Error>) in
            switch result {
            case .success(let model):
                completion(.success(model.mapToDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
