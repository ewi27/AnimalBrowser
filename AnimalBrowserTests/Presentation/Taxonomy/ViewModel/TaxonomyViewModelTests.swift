//
//  TaxonomyViewModelTests.swift
//  AnimalBrowserTests
//
//  Created by Ewelina on 03/10/2023.
//

import XCTest
@testable import AnimalBrowser

final class TaxonomyViewModelTests: XCTestCase {
    
    let taxonomyModel = AnimalTaxonomy(kingdom: "", phylum: "", taxonomyClass: "", order: "", family: "", genus: "", scientificName: "")
    
    var sut: TaxonomyViewModel!

    override func setUp() {
        super.setUp()
        
        sut = TaxonomyViewModel(model: taxonomyModel)
    }
    
    func test_viewDidLoad_called_prepareTaxonomy() {
        let taxonomyModelOfView = TaxonomyView.Model(kingdomText: "", phylumText: "", taxonomyClassText: "" ,orderText: "", familyText: "", genusText: "", scientificNameText: "")
        var model: TaxonomyView.Model?
        
        sut.update = {
            model = $0
        }
        sut.viewDidLoad()
        
        XCTAssertEqual(taxonomyModelOfView, model)
    }
}
