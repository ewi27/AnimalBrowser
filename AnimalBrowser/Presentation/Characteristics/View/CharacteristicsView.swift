//
//  CharacteristicsView.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//

import UIKit

struct CharacteristicsModel {
    var text: [String] = []
}

class CharacteristicsView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var model: [String] = []
    var constraint = NSLayoutConstraint()
    let table: UITableView = {
        let table = UITableView()
        table.register(AnimalTableViewCell.self, forCellReuseIdentifier: AnimalTableViewCell.idetifier)
        table.rowHeight = 100
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        table.delegate = self
        table.dataSource = self
        setupTable()
        table.layer.cornerRadius = 25
        table.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillTable(model: [String]) {
        self.model = model
    }
    
    func updateTableConstraints() {
        constraint.isActive = false
        constraint = table.heightAnchor.constraint(equalToConstant: table.contentSize.height)
        constraint.isActive = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: AnimalTableViewCell.idetifier, for: indexPath) as! AnimalTableViewCell
        cell.setupModel(model: .init(text: self.model[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.model.count
    }
    
    private func setupTable() {
        self.table.translatesAutoresizingMaskIntoConstraints = false
        let safeGuide = self.safeAreaLayoutGuide
        self.addSubview(table)
        table.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 30).isActive = true
        self.constraint = table.heightAnchor.constraint(equalToConstant: 1000)
        constraint.isActive = true
        table.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 30).isActive = true
        table.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -30).isActive = true
    }
}
