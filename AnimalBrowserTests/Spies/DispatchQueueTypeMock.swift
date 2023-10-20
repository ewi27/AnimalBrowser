//
//  DispatchQueueTypeMock.swift
//  AnimalBrowserTests
//
//  Created by Ewelina on 27/09/2023.
//

@testable import AnimalBrowser

final class DispatchQueueTypeMock: DispatchQueueType {
    func async(execute work: @escaping () -> Void) {
        work()
    }
}
