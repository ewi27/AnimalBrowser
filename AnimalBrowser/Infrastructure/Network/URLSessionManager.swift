//
//  URLSessionManager.swift
//  AnimalBrowser
//
//  Created by Ewelina on 16/10/2023.
//

import Foundation

protocol URLSessionManager {
    func request(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

final class DefaultURLSessionManager: URLSessionManager {
    func request(
        urlRequest: URLRequest,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: completion)
        task.resume()
        return task
    }
}
