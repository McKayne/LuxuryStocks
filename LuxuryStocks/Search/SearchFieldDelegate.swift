//
//  SearchFieldDelegate.swift
//  LuxuryStocks
//
//  Created by johndoe on 7/19/25.
//

import Foundation

@objc protocol SearchFieldDelegate {
    
    func searchText(didChangeTo: String)
    
    func searchText(didReceiveFocus: Bool)
}
