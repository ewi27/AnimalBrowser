//
//  AnimalQueriesListViewModel.swift
//  AnimalBrowser
//
//  Created by Ewelina on 11/08/2023.
//

final class AnimalQueriesListViewModel {
    
    private let fetchAnimalQueriesUseCase: FetchAnimalQueriesUseCase
    private let numberOfQueriesToShow: Int
    private var queries: [AnimalQuery] = [] {
        didSet {
            self.giveQueries?(queries)
            self.reloadData?()
        }
    }
    var reloadData: (() -> ())?
    var giveQueries: (([AnimalQuery]) -> ())?
    var selectingAction: ((AnimalQuery) -> Void)?
    
    init(fetchAnimalQueriesUseCase: FetchAnimalQueriesUseCase = DefaultFetchAnimalQueriesUseCase(),
         numberOfQueriesToShow: Int,
         selectingAction: ((AnimalQuery) -> Void)?) {
        self.fetchAnimalQueriesUseCase = fetchAnimalQueriesUseCase
        self.numberOfQueriesToShow = numberOfQueriesToShow
        self.selectingAction = selectingAction
    }
    
    func viewWillAppear() {
        fetchQueries()
    }
    
    func didSelect(query: String) {
        selectingAction?(AnimalQuery(query: query))
    }
    
    private func fetchQueries() {
        self.fetchAnimalQueriesUseCase.execute(queriesCount: numberOfQueriesToShow) { result in
            switch result {
            case .success(let queries):
                self.queries = queries
            case .failure(_):
                break
            }
        }
    }
}
