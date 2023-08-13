//
//  AnimalQueriesTableViewController.swift
//  AnimalBrowser
//
//  Created by Ewelina on 11/08/2023.
//

import UIKit

final class AnimalQueriesTableViewController: UITableViewController {
    
    private let viewModel = AnimalQueriesListViewModel()
    private var animalQueries: [AnimalQuery] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupViewModel() {
        viewModel.reloadData = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.giveQueries = { [weak self] queries in
            self?.animalQueries = queries
        }
        viewModel.viewWillAppear()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        animalQueries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnimalQueriesCell.reuseIdentifier , for: indexPath) as! AnimalQueriesCell
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
}
