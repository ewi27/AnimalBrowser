//
//  DataTransferServiceTests.swift
//  AnimalBrowserTests
//
//  Created by Ewelina on 16/10/2023.
//

import XCTest
@testable import AnimalBrowser

struct MockModel: Decodable, Equatable {
    let name: String
}

final class DataTransferServiceTests: XCTestCase {
    
    let endpoint = Endpoint(baseUrl: "", path: "", apiKey: "", headerField: "")
    var networkService: NetworkServiceSpy!
    var sut: DataTransferService!
    
    override func setUp() {
        super.setUp()
        
        networkService = .init()
        sut = DefaultDataTransferService(networkService: networkService)
    }
    
    func test_requestWithSucces() {
        let mockModel = MockModel(name: "Hello")
        let responseData = #"{"name": "Hello"}"#.data(using: .utf8)
        networkService.result = .success(responseData!)
        var requestCallsCount = 0
        
        sut.request(endpoint: endpoint) { (result: Result<MockModel,Error>) in
            requestCallsCount += 1
            switch result {
            case .success(let success):
                XCTAssertEqual(mockModel, success)
            case .failure(_):
                XCTFail("Should not fail")
            }
        }
        
        XCTAssertEqual(networkService.networkRequestCallsCount, 1)
        XCTAssertEqual(requestCallsCount, 1)
    }
    
    func test_requestWithFailure() {
        enum TestError: Error {
            case myError
        }
        networkService.result = .failure(TestError.myError)
        var requestCallsCount = 0
        
        sut.request(endpoint: endpoint) { (result: Result<MockModel,Error>) in
            requestCallsCount += 1
            switch result {
            case .success(_):
                XCTFail("Should be failed")
            case .failure(let error):
                XCTAssertEqual(TestError.myError, error as! TestError)
            }
        }
        
        XCTAssertEqual(networkService.networkRequestCallsCount, 1)
        XCTAssertEqual(requestCallsCount, 1)
    }
}
