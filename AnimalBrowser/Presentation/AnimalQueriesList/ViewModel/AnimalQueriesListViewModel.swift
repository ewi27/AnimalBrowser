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
    var selectingAction: ((AnimalQuery) -> Void)?
    
    init(fetchAnimalQueriesUseCase: FetchAnimalQueries = DefaultFetchAnimalQueriesUseCase(), selectingAction: ((AnimalQuery) -> Void)? = nil) {
        self.fetchAnimalQueriesUseCase = fetchAnimalQueriesUseCase
        self.selectingAction = selectingAction
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
        selectingAction?(AnimalQuery(query: query))
    }
}
