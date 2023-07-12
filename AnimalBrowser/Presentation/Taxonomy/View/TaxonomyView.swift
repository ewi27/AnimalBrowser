//
//  TaxonomyView.swift
//  AnimalBrowser
//
//  Created by Ewelina on 15/06/2023.
//

import UIKit

final class TaxonomyView: UIView {
    
    struct Model {
        var kingdomText: String
        var phylumText: String
        var taxonomyClassText: String
        var orderText: String?
        var familyText: String?
        var genusText: String?
        var scientificNameText: String?
    }
    
    private let stackView = UIStackView()
    private let kingdomLabel = UILabel()
    private let phylumLabel = UILabel()
    private let taxonomyClassLabel = UILabel()
    private let orderLabel = UILabel()
    private let familyLabel = UILabel()
    private let genusLabel = UILabel()
    private let scientificNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(with model: Model) {
        kingdomLabel.text = "Kingdom: \(model.kingdomText)"
        phylumLabel.text = "Phylum: \(model.phylumText)"
        taxonomyClassLabel.text = "Taxonomy class: \(model.taxonomyClassText)"
        guard let order = model.orderText else { return }
        orderLabel.text = "Order: \(String(describing: order))"
        guard let family = model.familyText else { return }
        familyLabel.text = "Family: \(String(describing: family))"
        guard let genus = model.genusText else { return }
        genusLabel.text = "Genus: \(String(describing: genus))"
        guard let scientificName = model.scientificNameText else { return }
        scientificNameLabel.text = "Scientific name: \(String(describing: scientificName))"
    }
    
    private func setupStackView() {
        let safeGuide = self.safeAreaLayoutGuide
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 30).isActive = true
        stackView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -30).isActive = true
        stackView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 30).isActive = true
        stackView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -30).isActive = true
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.addArrangedSubview(kingdomLabel)
        stackView.addArrangedSubview(phylumLabel)
        stackView.addArrangedSubview(taxonomyClassLabel)
        stackView.addArrangedSubview(orderLabel)
        stackView.addArrangedSubview(familyLabel)
        stackView.addArrangedSubview(genusLabel)
        stackView.addArrangedSubview(scientificNameLabel)
    }
}
