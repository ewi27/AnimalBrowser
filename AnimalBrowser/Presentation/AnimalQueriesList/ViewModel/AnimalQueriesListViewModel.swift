//
//  AnimalQueriesListViewModel.swift
//  AnimalBrowser
//
//  Created by Ewelina on 11/08/2023.
//

import Foundation

final class AnimalQueriesListViewModel {
    
    private let fetchAnimalQueriesUseCase: FetchAnimalQueries
    private var queries: [AnimalQuery] = [] {
        didSet {
            self.giveQueries?(queries)
            self.reloadData?()
        }
    }
    var reloadData: (() -> ())?
    var giveQueries: (([AnimalQuery]) -> ())?
    
    init(fetchAnimalQueriesUseCase: FetchAnimalQueries = DefaultFetchAnimalQueriesUseCase()) {
        self.fetchAnimalQueriesUseCase = fetchAnimalQueriesUseCase
    }
    
    private func fetchQueries() {
        fetchAnimalQueriesUseCase.execute { result in
            switch result {
            case .success(let queries):
                self.queries = queries
            case .failure(let error): print(error)
            }
        }
    }
    
    func viewWillAppear() {
        fetchQueries()
    }
    
    func didSelect(query: String) {
        
    }
}
