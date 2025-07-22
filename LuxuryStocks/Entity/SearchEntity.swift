//
//  SearchEntity.swift
//  LuxuryStocks
//
//  Created by johndoe on 7/22/25.
//

import RealmSwift

class SearchEntity: Object {
    @Persisted(primaryKey: true) var search: String
}
