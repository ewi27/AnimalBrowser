//
//  NetworkService.swift
//  AnimalBrowser
//
//  Created by Ewelina on 16/06/2023.
//

import Foundation

protocol NetworkService {
    func request(endpoint: Requestable,
                 completion: @escaping (Result<Data,Error>) -> Void)
}

final class DefaultNetworkService: NetworkService {
    var urlSessionManager: URLSessionManager
    
    init(urlSessionDataTask: URLSessionManager = DefaultURLSessionManager()) {
        self.urlSessionManager = urlSessionDataTask
    }
    
    func request(endpoint: Requestable,
                 completion: @escaping (Result<Data,Error>) -> Void) {
        guard let urlRequest = endpoint.makeUrlRequest() else { return }
        let task = urlSessionManager.request(urlRequest: urlRequest) { data, response, error in
            if let data = data {
                completion(.success(data))
            }
            if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
