//
//  AnimalDetailSectionList.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//

import Foundation

enum AnimalDetailSectionList {
    
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
        case .taxonomy(_):
            return "TAXONOMY"
        case .locations(_):
            return "LOCATIONS"
        case .characteristics(_):
            return "CHARACTERISTICS"
        }
    }
}
