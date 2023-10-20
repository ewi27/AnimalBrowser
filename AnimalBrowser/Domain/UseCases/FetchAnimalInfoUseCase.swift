//
//  UseCases.swift
//  AnimalBrowser
//
//  Created by Ewelina on 12/06/2023.
//

protocol FetchAnimalInfoUseCase {
    func execute(query: AnimalQuery,
                 completion: @escaping (Result<Animals, Error>) -> ()?)
}

final class DefaultFetchAnimalInfoUseCase: FetchAnimalInfoUseCase {
    
    private let animalRepository: AnimalRepository
    private let animalSaveQueryRepository: AnimalSaveQueryRepository
    
    init(animalRepository: AnimalRepository = DefaultAnimalRepository(), animalQueriesRepository: AnimalSaveQueryRepository = DefaultAnimalQueryRepository() ) {
        self.animalRepository = animalRepository
        self.animalSaveQueryRepository = animalQueriesRepository
    }
    
    func execute(query: AnimalQuery,
                 completion: @escaping (Result<Animals, Error>) -> ()?) {
        animalRepository.fetchAnimalInfo(query: query, completion: { result in
            if case .success = result {
                self.animalSaveQueryRepository.saveQuery(query: query)  { _ in }
            }
            completion(result)
        })
    }
}
