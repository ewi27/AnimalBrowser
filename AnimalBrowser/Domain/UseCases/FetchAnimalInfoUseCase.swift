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
    private let animalQueriesRepository: AnimalQueryRepository
    
    init(animalRepository: AnimalRepository = DefaultAnimalRepository(), animalQueriesRepository: AnimalQueryRepository = DefaultAnimalQueryRepository() ) {
        self.animalRepository = animalRepository
        self.animalQueriesRepository = animalQueriesRepository
    }
    
    func execute(query: AnimalQuery,
                 completion: @escaping (Result<Animal, Error>) -> ()?) {
        animalRepository.fetchAnimalInfo(query: query, completion: { result in
            if case .success = result {
                self.animalQueriesRepository.saveQuery(query: query)  { _ in }
            }
            completion(result)
        })
    }
}
