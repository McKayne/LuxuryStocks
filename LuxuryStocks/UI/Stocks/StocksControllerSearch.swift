//
//  StocksControllerSearch.swift
//  LuxuryStocks
//
//  Created by johndoe on 7/19/25.
//

import Foundation

extension StocksController: SearchFieldDelegate {
    
    func searchText(didChangeTo: String) {
        
    }
    
    func searchText(didReceiveFocus: Bool) {
        suggestingsView.isHidden = !didReceiveFocus
    }
}
