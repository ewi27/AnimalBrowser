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
    var tabelka: [String] = ["bla", "bla2", "bla3"]
    
    init?(coder: NSCoder, viewModel: AnimalQueriesListViewModel) {
        self.viewModel = viewModel
        print("hej tu init")
        print("\(animalQueries)")
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queriesTableView.dataSource = self
        queriesTableView.delegate = self
        view.backgroundColor = .lightGray
    }

    func setupViewModel() {
        viewModel.reloadData = { [weak self] in
            self?.queriesTableView.reloadData()
        }
        viewModel.giveQueries = { [weak self] queries in
            self?.animalQueries = queries
        }
        viewModel.viewWillAppear()
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  animalQueries.count
         tabelka.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "queriesCell" , for: indexPath) as! AnimalQueriesTableViewCell
       //  cell.queryLabel.text = animalQueries[indexPath.row].query
         cell.queryLabel.text = tabelka[indexPath.row]
        return cell
    }
    
    deinit {
        print("hej tu deinit")
    }
    
//     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         viewModel.didSelect(query: animalQueries[indexPath.row].query)
//    }
}
