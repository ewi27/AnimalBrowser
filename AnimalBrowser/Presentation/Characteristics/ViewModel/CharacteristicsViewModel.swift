//
//  CharacteristicsViewModel.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//

final class CharacteristicsViewModel {
    
    private let model: AnimalCharacteristics
    private var array: [String] = []
    var loadData: (([String]) -> ())?
    
    init(model: AnimalCharacteristics) {
        self.model = model
    }
    
    func viewDidLoad() {
        let mirror = Mirror(reflecting: model)
        mirror.children.forEach { child in
            if child.value is String {
                guard let label = child.label else {return}
                array.append("\(String(describing: label)): \(child.value as! String)")
            }
            self.loadData?(array)
        }
    }
}
