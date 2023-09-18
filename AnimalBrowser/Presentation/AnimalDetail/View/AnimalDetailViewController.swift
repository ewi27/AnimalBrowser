//
//  AnimalDetailViewController.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//

import UIKit

final class AnimalDetailViewController: UIViewController {
    
    private let detailTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .gray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AnimalTableViewCell.self, forCellReuseIdentifier: AnimalTableViewCell.idetifier)
        return tableView
    }()
    
    private let viewModel: AnimalDetailViewModel
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
        navigationController?.navigationBar.tintColor = .darkGray
        detailTableView.layer.cornerRadius = 25
        detailTableView.layer.masksToBounds = true
        detailTableView.dataSource = self
        detailTableView.delegate = self
        setupConstraints()
        setupViewModel()
    }
    
    private func setupViewModel() {
        sections = self.viewModel.makeSections()
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
        viewModel.numberOfCell(at: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .taxonomy(let taxo):
            let cell = detailTableView.dequeueReusableCell(withIdentifier: AnimalTableViewCell.idetifier, for: indexPath) as! AnimalTableViewCell
            cell.setupModel(with: .init(text: taxo))
            return cell
        case .locations(let locations):
            let cell = detailTableView.dequeueReusableCell(withIdentifier: AnimalTableViewCell.idetifier, for: indexPath) as! AnimalTableViewCell
            cell.setupModel(with: .init(text: locations[indexPath.row]))
            return cell
        case .characteristics(let char):
            let cell = detailTableView.dequeueReusableCell(withIdentifier: AnimalTableViewCell.idetifier, for: indexPath) as! AnimalTableViewCell
            cell.setupModel(with: .init(text: char))
            return cell
        }
    }
}

extension AnimalDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sectionsTitle(at: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .taxonomy:
            viewModel.pressTaxonomy()
        case .locations:
            break
        case .characteristics:
            viewModel.pressCharacteristics()
        }
    }
}
