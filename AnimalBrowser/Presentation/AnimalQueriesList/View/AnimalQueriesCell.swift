//
//  AnimalQueriesCell.swift
//  AnimalBrowser
//
//  Created by Ewelina on 12/08/2023.
//

import UIKit

final class AnimalQueriesCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: AnimalQueriesCell.self)
    @IBOutlet private var label: UILabel!
    
    func fill(text: String) {
        label.text = text
    }
}
