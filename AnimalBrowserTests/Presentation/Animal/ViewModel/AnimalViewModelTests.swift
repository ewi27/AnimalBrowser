//
//  AnimalViewModelTests.swift
//  AnimalBrowserTests
//
//  Created by Ewelina on 27/09/2023.
//

import XCTest
@testable import AnimalBrowser

class AnimalViewModelTests: XCTestCase {
    
    var sut: AnimalViewModel!
    
    var showAnimalDetailsCalled: DetailModel?
    var showAnimalQueriesListCalled: ((_ selectingAction: AnimalQuery) -> Void?)?
    var closeAnimalQueriesListCalled = false
    
    let testAnimal = Animal(name: "testName", taxonomy: .init(kingdom: "", phylum: "", taxonomyClass: "", order: "", family: "", genus: "", scientificName: ""), locations: [], characteristics: .init(prey: "", habitat: "", diet: "", lifestyle: "", location: "", color: "", lifespan: "", weight: ""))
    
    var fetchAnimalInfoUseCase: FetchAnimalInfoUseCaseSpy!
    
    enum error: Error {
        case myError
    }
    
    override func setUp() {
        super.setUp()
        
        fetchAnimalInfoUseCase = .init()
        sut = AnimalViewModel(
            viewModelActivities: .init(showAnimalDetails: {
                self.showAnimalDetailsCalled = $0
            }, showAnimalQueriesList: {
                self.showAnimalQueriesListCalled = $0
            }, closeAnimalQueriesList: {
                self.closeAnimalQueriesListCalled = true
            }),
            fetchAnimalInfoUseCase: fetchAnimalInfoUseCase,
            queue: DispatchQueueTypeMock()
        )
    }
    
    func test_didSearch_calledGiveSearchBarQuery_withCorrectQuery() {
        var giveSearchBarQueryResultCalledWithArgument = ""
        var giveSearchBarQueryResultCallsCount = 0
        
        sut.giveSearchBarQuery = {
            giveSearchBarQueryResultCalledWithArgument = $0
            giveSearchBarQueryResultCallsCount += 1
        }
        
        sut.didSearch(query: "test")
        
        XCTAssertEqual(giveSearchBarQueryResultCalledWithArgument, "test")
        XCTAssertEqual(giveSearchBarQueryResultCallsCount, 1)
    }
    
    func test_didSearch_called_giveSections_and_reloadData() {
        var giveSectionsCallsCount = 0
        var giveSectionsCalledWithArguments = [[AnimalSectionList]]()
        var reloadDataCallsCount = 0
        
        sut.giveSections = {
            giveSectionsCallsCount += 1
            giveSectionsCalledWithArguments.append($0)
        }
        sut.reloadData = {
            reloadDataCallsCount += 1
        }
        
        sut.didSearch(query: "test")
        
        XCTAssertEqual(giveSectionsCallsCount, 1)
        XCTAssertEqual(giveSectionsCalledWithArguments, [[]])
        XCTAssertEqual(reloadDataCallsCount, 1)
    }
    
    func test_didSearch_startActivityIndicator() {
        var activityIndicatorCallsCount = 0
        
        sut.startActivityIndicator = {
            activityIndicatorCallsCount += 1
        }
        
        sut.didSearch(query: "test")
        
        XCTAssertEqual(activityIndicatorCallsCount, 1)
    }
    
    func test_didSearch_calledExecute_onFetchAnimalInfoUseCase() {
        
        sut.didSearch(query: "test")
        
        XCTAssertEqual(fetchAnimalInfoUseCase.executeCallsCount, 1)
        XCTAssertEqual(fetchAnimalInfoUseCase.executeReceivedArguments?.query.query, "test")
    }
    
    func test_didSearch_calledExecute_withSuccessWithEmptyAnimals_from_fetchAnimalInfoUseCase() {
        var giveErrorCallsCount = 0
        var giveErrorCalledWithArguments = [String]()
        
        sut.giveError = {
            giveErrorCallsCount += 1
            giveErrorCalledWithArguments.append($0)
        }
        
        self.sut.didSearch(query: "test")
        fetchAnimalInfoUseCase.executeReceivedArguments?.result(.success([]))
        
        XCTAssertEqual(giveErrorCallsCount, 1)
        XCTAssertEqual(giveErrorCalledWithArguments, ["Searched word doesn't exist"])
    }
    
    func test_didSearch_calledExecute_withSuccessAnimals_from_fetchAnimalInfoUseCase_setupSections() {
        var giveSectionsCallsCount = 0
        var giveSectionsWithArgument = [[AnimalSectionList]]()
        var reloadDataCallsCount = 0
        
        sut.giveSections = {
            giveSectionsCallsCount += 1
            giveSectionsWithArgument.append($0)
        }
        sut.reloadData = {
            reloadDataCallsCount += 1
        }
        
        sut.didSearch(query: "test")
        fetchAnimalInfoUseCase.executeReceivedArguments?.result(.success([testAnimal]))
        
        //2 razy bo clearList po drodze tez to wywoluje
        XCTAssertEqual(giveSectionsCallsCount, 2)
        XCTAssertEqual(giveSectionsWithArgument, [[],[AnimalSectionList.animalName([testAnimal.name])]])
        XCTAssertEqual(reloadDataCallsCount, 2)
    }
    
    func test_pressName_called_showAnimalDetails() {
    
        sut.didSearch(query: "test")
        fetchAnimalInfoUseCase.executeReceivedArguments?.result(.success([testAnimal]))
        sut.pressName(section: 0, row: 0)
        let result = DetailModel(taxonomy: testAnimal.taxonomy,
                                 locations: testAnimal.locations,
                                 characteristics: testAnimal.characteristics)
 
        XCTAssertEqual(showAnimalDetailsCalled, result)
    }
    
    func test_didSearch_calledExecute_withSuccesFromAnimals_stopActivityIndicator() {
        var stopActivityIndicatorCallsCount = 0
        
        sut.stopActivityIndicator = {
            stopActivityIndicatorCallsCount += 1
        }
        
        sut.didSearch(query: "test")
        fetchAnimalInfoUseCase.executeReceivedArguments?.result(.success([testAnimal]))
        
        XCTAssertEqual(stopActivityIndicatorCallsCount, 1)
    }
    
    func test_didSearch_calledExecute_withFailureFromAnimals_stopActivityIndicator() {
        var stopActivityIndicatorCallsCount = 0
        
        sut.stopActivityIndicator = {
            stopActivityIndicatorCallsCount += 1
        }
        
        sut.didSearch(query: "test")
        fetchAnimalInfoUseCase.executeReceivedArguments?.result(.failure(error.myError))
        
        XCTAssertEqual(stopActivityIndicatorCallsCount, 1)
    }
    
    func test_didSearch_calledExecute_withFailureFromAnimals_giveError() {
        var giveErrorCallsCount = 0
        var giveErrorCalledWithArguments = [String]()
        
        sut.giveError = {
            giveErrorCallsCount += 1
            giveErrorCalledWithArguments.append($0)
        }
        
        sut.didSearch(query: "test")
        fetchAnimalInfoUseCase.executeReceivedArguments?.result(.failure(error.myError))
        
        XCTAssertEqual(giveErrorCallsCount, 1)
        XCTAssertEqual(giveErrorCalledWithArguments, [error.myError.localizedDescription])
    }
    
    
    func test_closeAnimalQueriesListVC_callsCount_closeAnimalQueriesList() {
        sut.closeAnimalQueriesListVC()
        
        XCTAssertEqual(true, closeAnimalQueriesListCalled)
    }
    
    func test_showAnimalQueriesListVC_called_giveSearchBarQuery() {
        let animalQuery = AnimalQuery(query: "query")
        var giveSearchBarCallsCout = 0
        var giveSearchBarWithArguments = ""
        
        sut.giveSearchBarQuery = {
            giveSearchBarCallsCout += 1
            giveSearchBarWithArguments = $0
        }
        sut.showAnimalQueriesListVC()
        showAnimalQueriesListCalled?(animalQuery)
        
        XCTAssertEqual(giveSearchBarCallsCout, 1)
        XCTAssertEqual(giveSearchBarWithArguments, "query")
    }
    
    func test_showAnimalQueriesListVC_called_giveSections_and_reloadData() {
        let animalQuery = AnimalQuery(query: "query")
        var giveSectionsCallsCount = 0
        var giveSectionsWithArgument = [[AnimalSectionList]]()
        var reloadDataCallsCount = 0
        
        sut.giveSections = {
            giveSectionsCallsCount += 1
            giveSectionsWithArgument.append($0)
        }
        sut.reloadData = {
            reloadDataCallsCount += 1
        }
        sut.showAnimalQueriesListVC()
        showAnimalQueriesListCalled?(animalQuery)
        
        XCTAssertEqual(giveSectionsCallsCount, 1)
        XCTAssertEqual(giveSectionsWithArgument, [[]])
        XCTAssertEqual(reloadDataCallsCount, 1)
    }
    
    func test_showAnimalQueriesListVC_called_startActivityIndicator() {
        let animalQuery = AnimalQuery(query: "query")
        var activityIndicatorCallsCount = 0
        
        sut.startActivityIndicator = {
            activityIndicatorCallsCount += 1
        }
        sut.showAnimalQueriesListVC()
        showAnimalQueriesListCalled?(animalQuery)
        
        XCTAssertEqual(activityIndicatorCallsCount, 1)
    }
    
    func test_showAnimalQueriesListVC_calledExecute_withSuccesEmptyAnimals_fromFetchAnimalInfoUseCase() {
        let animalQuery = AnimalQuery(query: "query")
        var giveErrorCallsCount = 0
        var giveErrorWithArgument = [String]()
        
        sut.giveError = {
            giveErrorCallsCount += 1
            giveErrorWithArgument.append($0)    //skąd
        }
        sut.showAnimalQueriesListVC()
        showAnimalQueriesListCalled?(animalQuery)
        fetchAnimalInfoUseCase.executeReceivedArguments?.result(.success([]))
        
        XCTAssertEqual(giveErrorCallsCount, 1)
        XCTAssertEqual(giveErrorWithArgument,["Searched word doesn't exist"])
    }
    
    func test_showAnimalQueriesListVC_called_giveSectionsAndReloadData_withSuccesAnimals_fromFetchAnimalInfoUseCase() {
        let animalQuery = AnimalQuery(query: "query")
        var giveSectionsCallsCount = 0
        var giveSectionsWithArgument = [[AnimalSectionList]]()
        var reloadDataCallsCount = 0
        
        sut.giveSections = {
            giveSectionsCallsCount += 1
            giveSectionsWithArgument.append($0)
        }
        sut.reloadData = {
            reloadDataCallsCount += 1
        }
        sut.showAnimalQueriesListVC()
        showAnimalQueriesListCalled?(animalQuery)
        fetchAnimalInfoUseCase.executeReceivedArguments?.result(.success([testAnimal]))
        
        XCTAssertEqual(giveSectionsCallsCount, 2)
        XCTAssertEqual(giveSectionsWithArgument, [[], [AnimalSectionList.animalName([testAnimal.name])]])
        XCTAssertEqual(reloadDataCallsCount, 2)
    }
    
    func test_showAnimalQueriesListVC_called_pressData_withSuccesAnimals_fromFetchAnimalInfoUseCase() {
        let animalQuery = AnimalQuery(query: "query")
        
        sut.showAnimalQueriesListVC()
        showAnimalQueriesListCalled?(animalQuery)
        fetchAnimalInfoUseCase.executeReceivedArguments?.result(.success([testAnimal]))
        sut.pressName(section: 0, row: 0)
        let result = DetailModel(taxonomy: testAnimal.taxonomy, locations: testAnimal.locations, characteristics: testAnimal.characteristics)
        
        XCTAssertEqual(showAnimalDetailsCalled, result)
    }
    
    func test_showAnimalQueriesListVC_called_stopActivityIndicator_withSuccesAnimals_fromFetchAnimalInfoUseCase() {
        let animalQuery = AnimalQuery(query: "query")
        var activityIndicatorCallsCount = 0
        
        sut.stopActivityIndicator = {
            activityIndicatorCallsCount += 1
        }
        sut.showAnimalQueriesListVC()
        showAnimalQueriesListCalled?(animalQuery)
        fetchAnimalInfoUseCase.executeReceivedArguments?.result(.success([testAnimal]))
        
        XCTAssertEqual(activityIndicatorCallsCount, 1)
    }
    
    func test_showAnimalQueriesListVC_called_stopActivityIndicator_withError_fromFetchAnimalInfoUseCase() {
        let animalQuery = AnimalQuery(query: "query")
        var activityIndicatorCallsCount = 0
        
        sut.stopActivityIndicator = {
            activityIndicatorCallsCount += 1
        }
        sut.showAnimalQueriesListVC()
        showAnimalQueriesListCalled?(animalQuery)
        fetchAnimalInfoUseCase.executeReceivedArguments?.result(.failure(error.myError))
        
        XCTAssertEqual(activityIndicatorCallsCount, 1)
    }
    
    func test_showAnimalQueriesListVC_called_giveError_withError_fromFetchAnimalInfoUseCase() {
        let animalQuery = AnimalQuery(query: "query")
        var giveErrorCallsCount = 0
        var giveErrorWithArgument = [String]()
        
        sut.giveError = {
            giveErrorCallsCount += 1
            giveErrorWithArgument.append($0)
        }
        sut.showAnimalQueriesListVC()
        showAnimalQueriesListCalled?(animalQuery)
        fetchAnimalInfoUseCase.executeReceivedArguments?.result(.failure(error.myError))
        
        XCTAssertEqual(giveErrorCallsCount, 1)
        XCTAssertEqual(giveErrorWithArgument, [error.myError.localizedDescription])
    }
}
