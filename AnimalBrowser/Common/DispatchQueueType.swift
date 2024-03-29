//
//  DispatchQueue.swift
//  AnimalBrowser
//
//  Created by Ewelina on 27/09/2023.
//

import Foundation

// Used to easily mock main and background queues in tests
protocol DispatchQueueType {
    func async(execute work: @escaping () -> Void)
}

extension DispatchQueue: DispatchQueueType {
    func async(execute work: @escaping () -> Void) {
        async(group: nil, execute: work)
    }
}
