//
//  CharacteristicsViewModel.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//

import Foundation

class CharacteristicsViewModel {
    
    var model: AnimalCharacteristics
    var array: [String] = []
    var giveArray: (([String]) -> ())?
    
    init(model: AnimalCharacteristics) {
        self.model = model
    }
    
    func makeArray() {
        let mirror = Mirror(reflecting: model)
        mirror.children.forEach { child in
            if child.value is String {
                guard let label = child.label else {return}
                array.append("\(String(describing: label)): \(child.value as! String)")
            }
            self.giveArray?(array)
        }
    }
}
