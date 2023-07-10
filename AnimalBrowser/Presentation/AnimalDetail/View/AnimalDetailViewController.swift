//
//  AnimalDetailViewController.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//

import UIKit

class AnimalDetailViewController: UIViewController {
    
    private let detailTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .gray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AnimalTableViewCell.self, forCellReuseIdentifier: AnimalTableViewCell.idetifier)
        return tableView
    }()
    
    private var viewModel: AnimalDetailViewModel
    private var sections: [AnimalDetailSectionList] = [AnimalDetailSectionList]()
    
    init(viewModel: AnimalDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        self.navigationController?.navigationBar.tintColor = .darkGray
        self.detailTableView.layer.cornerRadius = 25
        self.detailTableView.layer.masksToBounds = true
        detailTableView.dataSource = self
        detailTableView.delegate = self
        setupConstraints()
        setupViewModel()
    }
    
    private func setupViewModel() {
        self.sections = self.viewModel.makeSections()
        self.viewModel.giveTaxonomy = { [weak self] model in
            let viewModel = TaxonomyViewModel(model: model)
            let viewController = TaxonomyViewController(viewModel: viewModel)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        self.viewModel.giveCharacteristics = { [weak self] model in
            let viewModel = CharacteristicsViewModel(model: model)
            let viewController = CharacteristicsViewController(viewModel: viewModel)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func setupConstraints() {
        let safeGuide = view.safeAreaLayoutGuide
        view.addSubview(detailTableView)
        detailTableView.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 10).isActive = true
        detailTableView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -10).isActive = true
        detailTableView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20).isActive = true
        detailTableView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -20).isActive = true
    }
}

extension AnimalDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfCell(at: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .taxonomy(let taxo):
            let cell = detailTableView.dequeueReusableCell(withIdentifier: AnimalTableViewCell.idetifier, for: indexPath) as! AnimalTableViewCell
            cell.setupModel(model: .init(text: taxo))
            return cell
        case .locations(let locations):
            let cell = detailTableView.dequeueReusableCell(withIdentifier: AnimalTableViewCell.idetifier, for: indexPath) as! AnimalTableViewCell
            cell.setupModel(model: .init(text: locations[indexPath.row]))
            return cell
        case .characteristics(let char):
            let cell = detailTableView.dequeueReusableCell(withIdentifier: AnimalTableViewCell.idetifier, for: indexPath) as! AnimalTableViewCell
            cell.setupModel(model: .init(text: char))
            return cell
        }
    }
}

extension AnimalDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.viewModel.sectionsTitle(at: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .taxonomy:
            self.viewModel.pressTaxonomy()
        case .locations:
            break
        case .characteristics:
            self.viewModel.pressCharacteristics()
        }
    }
}
