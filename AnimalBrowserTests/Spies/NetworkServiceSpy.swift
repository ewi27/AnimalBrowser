//
//  NetworkServiceSpy.swift
//  AnimalBrowserTests
//
//  Created by Ewelina on 20/10/2023.
//

import Foundation
@testable import AnimalBrowser

final class NetworkServiceSpy: NetworkService {
    var networkRequestCallsCount = 0
    var result: Result<Data, Error>?
    
    func request(endpoint: AnimalBrowser.Requestable, completion: @escaping (Result<Data, Error>) -> Void) {
        networkRequestCallsCount += 1
        if let result = result {
            completion(result)
        }
    }
}
