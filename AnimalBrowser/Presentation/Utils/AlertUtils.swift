//
//  ActivityInspectorUtils.swift
//  AnimalBrowser
//
//  Created by Ewelina on 22/09/2023.
//

import UIKit

extension UIViewController {
    
    func setAlert(title: String,
                  message: String,
                  actions: [UIAlertAction],
                  color: UIColor) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.view.tintColor = color
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
