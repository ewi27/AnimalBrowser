//
//  DataTransferServiceSpy.swift
//  AnimalBrowserTests
//
//  Created by Ewelina on 20/10/2023.
//

@testable import AnimalBrowser

final class DataTransferServiceSpy: DataTransferService {
    let animalElement = AnimalElement(name: "", taxonomy: Taxonomy(kingdom: "", phylum: "", taxonomyClass: "", order: "", family: "", genus: "", scientificName: ""), locations: [], characteristics: Characteristics(prey: "", habitat: "", diet: "", lifestyle: "", location: "", color: "", lifespan: "", weight: ""))
    var testAnimalModel: AnimalModel?
    enum TestError: Error {
        case myError
    }
    var shouldFailed = false
    var dataTransferServiceCallsCount = 0
    
    func request<T>(endpoint: AnimalBrowser.Requestable, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        dataTransferServiceCallsCount += 1
        testAnimalModel = [animalElement]
        
        if shouldFailed {
            completion(.failure(TestError.myError))
        } else {
            completion(.success(testAnimalModel as! T))
        }
    }
}
