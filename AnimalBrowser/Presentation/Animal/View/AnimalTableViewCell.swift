//
//  AnimalTableViewCell.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//

import UIKit

class AnimalTableViewCell: UITableViewCell {
    
    static let idetifier = "cellIdentifier"
    
    private var animalInfoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .gray
        selectionStyle = .none
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupModel(with model: AnimalCellModel) {
        animalInfoLabel.text = model.text
    }
    
    private func setupConstraints() {
        contentView.addSubview(animalInfoLabel)
        animalInfoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        animalInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
        animalInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        animalInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
    }
}
