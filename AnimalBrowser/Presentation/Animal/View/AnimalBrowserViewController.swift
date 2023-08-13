//
//  AnimalBrowserViewController.swift
//  AnimalBrowser
//
//  Created by Ewelina on 12/06/2023.
//

import UIKit

final class AnimalBrowserViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.backgroundColor = .gray
        searchBar.barTintColor = .lightGray
        searchBar.placeholder = "ANIMAL"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    private let animalTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .gray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AnimalTableViewCell.self, forCellReuseIdentifier: AnimalTableViewCell.idetifier)
        return tableView
    }()
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = UIColor().lightPink()
        return activityIndicator
    }()
    private let viewModel = AnimalViewModel()
    private var sections: [AnimalSectionList] = [AnimalSectionList]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        self.navigationController?.navigationBar.tintColor = .darkGray
        self.animalTableView.layer.cornerRadius = 25
        self.animalTableView.layer.masksToBounds = true
        animalTableView.dataSource = self
        animalTableView.delegate = self
        searchBar.delegate = self
        setupConstraints()
        setupViewModel()
        print(AnimalQueriesCell.reuseIdentifier)
    }
    
    private func setupViewModel() {
        self.viewModel.startActivityIndicator = { [weak self] in
            self?.activityIndicator.startAnimating()
        }
        self.viewModel.stopActivityIndicator = { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
        self.viewModel.reloadData = { [weak self] in
            self?.animalTableView.reloadData()
        }
        self.viewModel.giveSections = { [weak self] sections in
            self?.sections = sections
        }
        self.viewModel.presentDetailScreen = { [weak self] model in
            let viewModel = AnimalDetailViewModel(model: (.init( taxonomy: model.taxonomy, locations: model.locations, characteristics: model.characteristics)))
            let viewController = AnimalDetailViewController(viewModel: viewModel)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        self.viewModel.giveError = { error in
            let alert = UIAlertController(title: "ERROR", message: error , preferredStyle: .alert)
            alert.view.tintColor = UIColor().lightPink()
            let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func setupConstraints() {
        let safeGuide = view.safeAreaLayoutGuide
        view.addSubview(animalTableView)
        view.addSubview(searchBar)
        view.addSubview(activityIndicator)
        searchBar.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 10).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: animalTableView.topAnchor, constant: -30).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -20).isActive = true
        animalTableView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -50).isActive = true
        animalTableView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20).isActive = true
        animalTableView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -20).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: safeGuide.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: safeGuide.centerYAnchor).isActive = true
    }
    
    func setupSearchController() {
        searchController.delegate = self
        
    }
}

extension AnimalBrowserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].cellCount
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = animalTableView.dequeueReusableCell(withIdentifier: AnimalTableViewCell.idetifier, for: indexPath) as! AnimalTableViewCell
        switch sections[indexPath.section] {
        case .animalName(let names):
            let model = AnimalCellModel(text: names[indexPath.row])
            cell.setupModel(with: model)
            return cell
        }
    }
}

extension AnimalBrowserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.pressName(section: indexPath.section, row: indexPath.row)
    }
}

extension AnimalBrowserViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.clearTable()
        guard let text = searchBar.text else { return }
        viewModel.didSearch(query: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}

extension AnimalBrowserViewController: UISearchControllerDelegate {
    
}
