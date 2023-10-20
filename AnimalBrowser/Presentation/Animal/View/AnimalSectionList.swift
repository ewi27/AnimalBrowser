//
//  AnimalSectionList.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//

enum AnimalSectionList: Equatable {
    
    case animalName([String])
    
    var cellCount: Int {
        switch self {
        case .animalName(let names):
            return names.count
        }
    }
    var sectionTitle: String {
        switch self {
        case .animalName:
            return "NAME"
        }
    }
}
