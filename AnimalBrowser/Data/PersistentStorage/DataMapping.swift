//
//  DataMapping.swift
//  AnimalBrowser
//
//  Created by Ewelina on 23/07/2023.
//

import Foundation
import CoreData

extension AnimalQueryEntity {
    convenience init(animalQuery: AnimalQuery, context: NSManagedObjectContext) {
        self.init(context: context)
        query = animalQuery.query
    }
}

extension AnimalQueryEntity {
    func mapToDomain() -> AnimalQuery {
        return .init(query: self.query ?? "")
    }
}
