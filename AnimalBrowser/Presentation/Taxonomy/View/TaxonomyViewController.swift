//
//  TaxonomyViewController.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//

import UIKit

class TaxonomyViewController: UIViewController {
    
    private var viewModel: TaxonomyViewModel
    private let taxonomyView = TaxonomyView()
    
    init(viewModel: TaxonomyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = taxonomyView
        self.viewModel.update = { model in
            self.taxonomyView.fill(with: model)
        }
        self.viewModel.viewDidLoad()
    }
}
