//
//  AnimalQueriesViewController.swift
//  AnimalBrowser
//
//  Created by Ewelina on 13/09/2023.
//

import UIKit

final class AnimalQueriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var queriesTableView: UITableView!
    
    private let viewModel: AnimalQueriesListViewModel
    private var animalQueries: [AnimalQuery] = []
    
    init?(coder: NSCoder, viewModel: AnimalQueriesListViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queriesTableView.backgroundColor = .lightGray
        setupViewModel()
    }
    
    func setupViewModel() {
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.queriesTableView.reloadData()
            }
        }
        viewModel.giveQueries = { [weak self] queries in
            self?.animalQueries = queries
        }
        viewModel.viewWillAppear()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        animalQueries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "queriesCell" , for: indexPath) as! AnimalQueriesTableViewCell
        let model = CellModel(text: animalQueries[indexPath.row].query)
        cell.backgroundColor = .lightGray
        cell.fillCell(with: model)
        return cell
    }
    
    deinit {
        print("hej tu deinit")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.didSelect(query: animalQueries[indexPath.row].query)
    }
}
