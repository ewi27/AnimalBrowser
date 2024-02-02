//
//  Endpoint.swift
//  AnimalBrowser
//
//  Created by Ewelina on 16/06/2023.
//

import Foundation

protocol Requestable {
    
    var baseUrl: String { get }
    var path: String { get }
    var queryParametersEncodable: Encodable? { get }
    var apiKey: String { get set }
    
    func makeUrlRequest() -> URLRequest?
}

final class Endpoint: Requestable {

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
    
    func makeUrlRequest() -> URLRequest? {
        let urlPath = "\(baseUrl)\(path)"
        guard var urlComponents = URLComponents(string: urlPath) else { return nil }
        var urlQueryItems = [URLQueryItem]()
        let queryParameters = try? queryParametersEncodable?.toDictionary()
        guard let queryParam = queryParameters else { return nil }
        queryParam.forEach { urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { return nil }
        var urlRequest = URLRequest(url: url)
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
