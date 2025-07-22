//
//  TabBarDelegate.swift
//  LuxuryStocks
//
//  Created by johndoe on 7/22/25.
//

import Foundation

@objc protocol TabBarDelegate {
    
    func didSelect(favoritesOnly: Bool)
}
