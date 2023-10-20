//
//  AnimalQueriesListTests.swift
//  AnimalBrowserTests
//
//  Created by Ewelina on 05/10/2023.
//

import XCTest
@testable import AnimalBrowser

final class AnimalQueriesListTests: XCTestCase {
    
    var sut: AnimalQueriesListViewModel!
    var fetchAnimalQueryUseCase: FetchAnimalQueriesUseCaseSpy!
    var selectingAnimalQuery: AnimalQuery!
    let testQueriesArray = [AnimalQuery(query: "query")]
    enum error: Error {
        case myError
    }
    
    override func setUp() {
        super.setUp()
        
        fetchAnimalQueryUseCase = .init()
        sut = AnimalQueriesListViewModel(fetchAnimalQueriesUseCase: fetchAnimalQueryUseCase,
                                         numberOfQueriesToShow: 5,
                                         selectingAction: { self.selectingAnimalQuery = $0 })
    }
    
    func test_viewWillAppear_called_fetchAnimalQueriesUseCase() {
        
        sut.viewWillAppear()
        
        XCTAssertEqual(fetchAnimalQueryUseCase.executeCallsCount, 1)
        XCTAssertEqual(fetchAnimalQueryUseCase.executeReceivedArguments?.queriesCount, 5)
    }
    
    func test_viewWillAppear_called_giveQueriesAndReloadData_fromFetchAnimalQueriesUseCase_withSucces() {
        var giveQueriesCallsCount = 0
        var giveQueriesWithArgument = [[AnimalQuery]]()
        var reloadDataCallsCount = 0
        
        sut.giveQueries = {
            giveQueriesCallsCount += 1
            giveQueriesWithArgument.append($0)
        }
        sut.reloadData = {
            reloadDataCallsCount += 1
        }
        sut.viewWillAppear()
        fetchAnimalQueryUseCase.executeReceivedArguments?.result(.success(testQueriesArray))
        
        XCTAssertEqual(giveQueriesCallsCount, 1)
        XCTAssertEqual(giveQueriesWithArgument, [[AnimalQuery(query: "query")]])
        XCTAssertEqual(reloadDataCallsCount, 1)
    }
    
    func test_viewWillAppear_called_fetchQueries_fromFetchAnimalQueriesUseCase_withFailure() {
        
        sut.viewWillAppear()
        fetchAnimalQueryUseCase.executeReceivedArguments?.result(.failure(error.myError))
    }
    
    func test_didSelect_calledselectingAction() {
        var selectinActionCallsCount = 0
        var selectingActionWithArgument = [AnimalQuery]()
        
        sut.selectingAction = {
            selectinActionCallsCount += 1
            selectingActionWithArgument.append($0)
        }
        sut.didSelect(query: "query")
        
        XCTAssertEqual(selectinActionCallsCount, 1)
        XCTAssertEqual(selectingActionWithArgument, [AnimalQuery(query: "query")])
    }
}
