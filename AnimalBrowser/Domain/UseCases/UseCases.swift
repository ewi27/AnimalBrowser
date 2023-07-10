//
//  UseCases.swift
//  AnimalBrowser
//
//  Created by Ewelina on 12/06/2023.
//

protocol FetchAnimalInfoUseCase {
    func execute(query: AnimalQuery,
                 completion: @escaping (Result<Animal, Error>) -> ()?)
}

final class DefaultFetchAnimalInfoUseCase: FetchAnimalInfoUseCase {
    
    private let animalRepository: AnimalRepository
    
    init(animalRepository: AnimalRepository = DefaultAnimalRepository()) {
        self.animalRepository = animalRepository
    }
    
    func execute(query: AnimalQuery,
                 completion: @escaping (Result<Animal, Error>) -> ()?) {
        animalRepository.fetchAnimalInfo(query: query, completion: completion)
    }
}

