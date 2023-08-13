//
//  CoreData.swift
//  AnimalBrowser
//
//  Created by Ewelina on 18/07/2023.
//

import UIKit
import CoreData

final class CoreDataStorage {
    
    private var container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask(block)
    }
}
