//
//  DataTransferService.swift
//  AnimalBrowser
//
//  Created by Ewelina on 16/06/2023.
//

import Foundation

protocol DataTransferService {
    func request<T: Decodable>(endpoint: Requestable, completion: @escaping (Result<T,Error>) -> Void)
}

final class DefaultDataTransferService: DataTransferService {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = DefaultNetworkService()){
        self.networkService = networkService
    }
    
    func request<T:Decodable>(endpoint: Requestable,
                              completion: @escaping (Result<T,Error>) -> Void) {
        networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
