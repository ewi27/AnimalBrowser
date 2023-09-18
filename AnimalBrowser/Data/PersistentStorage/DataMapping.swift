//
//  DataMapping.swift
//  AnimalBrowser
//
//  Created by Ewelina on 23/07/2023.
//

import Foundation
import CoreData

//tworzenie AnimalQueryEntity na podstawie obiektów domenowych
extension AnimalQueryEntity {
    convenience init(animalQuery: AnimalQuery, context: NSManagedObjectContext) {
        self.init(context: context)
        createdAt = Date()
        query = animalQuery.query
    }
}
//mapowanie obiektu z Core Data na obiekt domenowy - z przechowywanego w bazie danych na taki, kóry można używać w aplikacji
extension AnimalQueryEntity {
    func mapToDomain() -> AnimalQuery {
        return .init(query: self.query ?? "")
    }
}
