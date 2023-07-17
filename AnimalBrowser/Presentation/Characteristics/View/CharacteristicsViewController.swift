//
//  CharacteristicsViewController.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//

import UIKit

final class CharacteristicsViewController: UIViewController {
    
    private var viewModel: CharacteristicsViewModel
    private let characteristicsView = CharacteristicsView()
    
    init(viewModel: CharacteristicsViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = characteristicsView
        viewModel.loadData = { [weak self] array in
            self?.characteristicsView.fillTable(model: array)
        }
        viewModel.viewDidLoad()
    }
}
