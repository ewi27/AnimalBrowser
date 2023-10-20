//
//  AnimalDetailSectionList.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//

enum AnimalDetailSectionList: Equatable {
    
    case taxonomy(String)
    case locations([String])
    case characteristics(String)
    
    var cellCount: Int {
        switch self {
        case .taxonomy(_):
            return 1
        case .locations(let locations):
            return locations.count
        case .characteristics(_):
            return 1
        }
    }
    
    var sectionTitle: String {
        switch self {
        case .taxonomy:
            return "TAXONOMY"
        case .locations:
            return "LOCATIONS"
        case .characteristics:
            return "CHARACTERISTICS"
        }
    }
}
