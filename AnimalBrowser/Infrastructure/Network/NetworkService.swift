//
//  NetworkService.swift
//  AnimalBrowser
//
//  Created by Ewelina on 16/06/2023.
//
//klasa do wykonywania requestow w celu pobrania informacji

import Foundation

protocol NetworkService {
    func request(endpoint: Requestable,
                 completion: @escaping (Result<Data,Error>) -> Void)
}

final class DefaultNetworkService: NetworkService {
    func request(endpoint: Requestable,
                 completion: @escaping (Result<Data,Error>) -> Void) {
        let urlRequest = endpoint.makeUrlRequest()
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
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

