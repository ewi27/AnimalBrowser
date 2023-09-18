//
//  ViewControllerUtils.swift
//  AnimalBrowser
//
//  Created by Ewelina on 18/09/2023.
//

import UIKit

extension UIViewController {
    
    func add(child: UIViewController, container: UIView) {
        addChild(child)
        child.view.frame = container.bounds
        container.addSubview(child.view)
        child.didMove(toParent: self)
    }
}
