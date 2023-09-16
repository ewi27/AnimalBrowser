//
//  AnimalBrowserViewController.swift
//  AnimalBrowser
//
//  Created by Ewelina on 12/06/2023.
//

import UIKit

final class AnimalListViewController: UIViewController {
    
    private var viewModel: AnimalViewModel
    private var searchBarContainer = UIView()
    private var sections: [AnimalSectionList] = [AnimalSectionList]()
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
    private let searchController = UISearchController(searchResultsController: nil)
    var queriesContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animalTableView.dataSource = self
        animalTableView.delegate = self
        setupViews()
        setupViewModel()
    }
    
    init(viewModel: AnimalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print("INIT GLOWNY")
    }
    
    deinit {
        print("DEINIT GLOWNY")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.viewModel.giveError = { error in
            let alert = UIAlertController(title: "ERROR", message: error , preferredStyle: .alert)
            alert.view.tintColor = UIColor().lightPink()
            let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .lightGray
        self.navigationController?.navigationBar.tintColor = .darkGray
        self.animalTableView.layer.cornerRadius = 25
        self.animalTableView.layer.masksToBounds = true
        setupConstraints()
        setupSearchController()
    }
    
    private func setupConstraints() {
        let safeGuide = view.safeAreaLayoutGuide
        view.addSubview(searchBarContainer)
        view.addSubview(animalTableView)
       
        view.addSubview(activityIndicator)
        
        searchBarContainer.translatesAutoresizingMaskIntoConstraints = false
        searchBarContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBarContainer.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 10).isActive = true
        searchBarContainer.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor).isActive = true
        searchBarContainer.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor).isActive = true
        animalTableView.topAnchor.constraint(equalTo: searchBarContainer.bottomAnchor, constant: 50).isActive = true
        animalTableView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -50).isActive = true
        animalTableView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20).isActive = true
        animalTableView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -20).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: safeGuide.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: safeGuide.centerYAnchor).isActive = true
        queriesContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(queriesContainer)
        queriesContainer.isHidden = true
        queriesContainer.backgroundColor = .lightGray
        queriesContainer.topAnchor.constraint(equalTo: searchBarContainer.bottomAnchor, constant: 50).isActive = true
        queriesContainer.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -50).isActive = true
        queriesContainer.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20).isActive = true
        queriesContainer.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -20).isActive = true
    }
    
    private func setupSearchController() {
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.backgroundColor = .gray
        searchController.searchBar.barTintColor = .lightGray
        searchController.searchBar.tintColor = UIColor().lightPink()
        searchController.searchBar.placeholder = viewModel.searchBarPlaceholderText
        searchBarContainer.addSubview(searchController.searchBar)
        definesPresentationContext = true
    }
}

extension AnimalListViewController: UITableViewDataSource {
    
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

extension AnimalListViewController: UITableViewDelegate {
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

extension AnimalListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.clearTable()
        guard let text = searchBar.text else { return }
        viewModel.didSearch(query: text)
        searchController.isActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}

extension AnimalListViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        viewModel.showAnimalQueriesListVC()
      //  queriesContainer.isHidden = false
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        viewModel.closeAnimalQueriesListVC()
       // queriesContainer.isHidden = true
      }
}

class Vcvc: UIViewController {
    override func viewDidLoad() {
         super.viewDidLoad()
        view.backgroundColor = .red
    }
}

extension UIViewController {
    
    func add(child: UIViewController, container: UIView) {
        addChild(child)
        child.view.frame = container.bounds
        container.addSubview(child.view)
        child.didMove(toParent: self)
    }
}
