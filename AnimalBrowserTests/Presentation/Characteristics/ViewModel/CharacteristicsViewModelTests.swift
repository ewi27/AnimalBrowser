//
//  CharacteristicsViewModelTests.swift
//  AnimalBrowserTests
//
//  Created by Ewelina on 03/10/2023.
//

import XCTest
@testable import AnimalBrowser

final class CharacteristicsViewModelTests: XCTestCase {
    
    let characteristicsModel = AnimalCharacteristics(prey: "", habitat: "", diet: "", lifestyle: "", location: "", color: "", lifespan: "", weight: "")
    
    var sut: CharacteristicsViewModel!
  
    override func setUp() {
        super.setUp()
        
        sut = CharacteristicsViewModel(model: characteristicsModel)
    }
    
    func test_viewDidLoad_called_loadData() {
        let characteristicsModelOfView = ["prey: ", "habitat: ", "diet: ", "lifestyle: ", "location: ", "color: ", "lifespan: ", "weight: "]
        var model: [String]?
        
        sut.loadData = {
            model = $0
        }
        sut.viewDidLoad()
        
        XCTAssertEqual(characteristicsModelOfView, model)
    }
}
