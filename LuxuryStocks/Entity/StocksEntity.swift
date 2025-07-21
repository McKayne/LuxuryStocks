//
//  StocksEntity.swift
//  LuxuryStocks
//
//  Created by johndoe on 7/19/25.
//

import UIKit
import RealmSwift

class StocksEntity: Object, Decodable {
    @Persisted(primaryKey: true) var symbol: String
    
    @Persisted var name: String
    @Persisted var price: Double
    @Persisted var change: Double
    @Persisted var changePercent: Double
    @Persisted var logo: String
    
    @Persisted var isFavorite: Bool?
    
    lazy var stocksImage: UIImage? = nil
}
