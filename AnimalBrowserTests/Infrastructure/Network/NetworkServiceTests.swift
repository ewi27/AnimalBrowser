//
//  NetworkServiceTests.swift
//  AnimalBrowserTests
//
//  Created by Ewelina on 16/10/2023.
//

import XCTest
@testable import AnimalBrowser

final class NetworkServiceTests: XCTestCase {
    
    let endpoint = Endpoint(baseUrl: "", path: "", apiKey: "", headerField: "")
    var urlSessionMock: URLSessionMock!
    var sut: DefaultNetworkService!
    enum TestError: Error {
        case myError
    }
    
    override func setUp() {
        super.setUp()
        
        urlSessionMock = URLSessionMock()
        sut = DefaultNetworkService(urlSessionDataTask: urlSessionMock)
    }
    
    func test_requestWithSuccess() {
        let responseData = "Hello".data(using: .utf8)
        urlSessionMock.mockData = responseData
        var resultData: Data?
        var requestCallsCount = 0
        
        sut.request(endpoint: endpoint) { result in
            requestCallsCount += 1
            switch result {
            case .success(let data):
                resultData = data
            case .failure(_):
                XCTFail("Should't be failed")
            }
        }
        
        XCTAssertEqual(requestCallsCount, 1)
        XCTAssertEqual(responseData, resultData)
    }
    
    func test_requestWithError() {
        enum TestError: Error {
            case myError
        }
        urlSessionMock.mockError = TestError.myError
        var requestCallsCount = 0
        
        sut.request(endpoint: endpoint) { result in
            requestCallsCount += 1
            switch result {
            case .success(_):
                XCTFail("Should be failed")
            case .failure(let error):
                XCTAssertEqual(TestError.myError, error as! TestError)
            }
        }
        
        XCTAssertEqual(requestCallsCount, 1)
    }
}

final class URLSessionMock: URLSessionManager {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    func request(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let dataTask = URLSession.shared.dataTask(with: urlRequest)
        completion(mockData, mockResponse, mockError)
        return dataTask
    }
}
