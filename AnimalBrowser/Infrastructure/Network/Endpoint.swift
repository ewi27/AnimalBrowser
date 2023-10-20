//
//  Endpoint.swift
//  AnimalBrowser
//
//  Created by Ewelina on 16/06/2023.
//
// tutaj tworzony jest endpoint

import Foundation

protocol Requestable {
    
    var baseUrl: String { get }
    var path: String { get }
    var queryParametersEncodable: Encodable? { get }
    var apiKey: String { get set }
    
    func makeUrlRequest() -> URLRequest
}

class Endpoint: Requestable {

    var baseUrl: String
    var path: String
    var queryParametersEncodable: Encodable?
    var apiKey: String
    var headerField: String
    
    init(baseUrl: String, path: String, queryParametersEncodable: Encodable? = nil, apiKey: String, headerField: String) {
        self.baseUrl = baseUrl
        self.path = path
        self.queryParametersEncodable = queryParametersEncodable
        self.apiKey = apiKey
        self.headerField = headerField
    }
    
    func makeUrlRequest() -> URLRequest {
        let urlPath = "\(baseUrl)\(path)"
        var urlComponents = URLComponents(string: urlPath)
        var urlQueryItems = [URLQueryItem]()
        let queryParameters = try? queryParametersEncodable?.toDictionary()
        queryParameters?.forEach { urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        urlComponents?.queryItems = urlQueryItems
        let url = urlComponents?.url
        var urlRequest = URLRequest(url: url!)
        urlRequest.setValue(apiKey, forHTTPHeaderField: headerField)
        return urlRequest
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String : Any]
    }
}
