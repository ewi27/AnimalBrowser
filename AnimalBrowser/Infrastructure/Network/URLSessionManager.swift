//
//  URLSessionManager.swift
//  AnimalBrowser
//
//  Created by Ewelina on 16/10/2023.
//

import Foundation

protocol URLSessionManager {
    func request(with: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

class DefaultURLSessionManager: URLSessionManager {
    func request(
        with: URLRequest,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: with, completionHandler: completion)
        task.resume()
        return task
    }
}
