//
//  StocksControllerTabBar.swift
//  LuxuryStocks
//
//  Created by johndoe on 7/22/25.
//

import Foundation

extension StocksController: TabBarDelegate {
    
    func didSelect(favoritesOnly: Bool) {
        reloadListithFilter()
    }
}
