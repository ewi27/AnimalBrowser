//
//  AnimalQueriesTableViewCell.swift
//  AnimalBrowser
//
//  Created by Ewelina on 13/09/2023.
//

import UIKit

struct CellModel {
    let text: String
}

final class AnimalQueriesTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var queryLabel: UILabel!
    
    func fillCell(with model: CellModel) {
        self.queryLabel.text = model.text
    }
}
