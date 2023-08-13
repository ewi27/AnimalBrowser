//
//  APIEndpoint.swift
//  AnimalBrowser
//
//  Created by Ewelina on 19/06/2023.
//

import Foundation

protocol MakeEndpoint {
    func makeEndpoint(requestQuery: AnimalRequestQuery) -> Endpoint
}

struct AnimalAPIEndpoint: MakeEndpoint {
    func makeEndpoint(requestQuery: AnimalRequestQuery) -> Endpoint {
        return .init(baseUrl: AnimalRequestPaths.baseUrl,
                     path: AnimalRequestPaths.path,
                     queryParametersEncodable: requestQuery,
                     apiKey: AnimalRequestPaths.apiKey,
                     headerField: AnimalRequestPaths.headerField)
    }
}
