//
//  StocksControllerSearch.swift
//  LuxuryStocks
//
//  Created by johndoe on 7/19/25.
//

import Foundation

extension StocksController: SearchFieldDelegate {
    
    func searchText(didChangeTo newSearch: String) {
        searchText = newSearch
        suggestingsView.isHidden = !searchText.isEmpty
        
        //print(searchText)
        reloadListithFilter()
    }
    
    func searchText(didReceiveFocus: Bool) {
        suggestingsView.isHidden = !didReceiveFocus || !searchText.isEmpty
        
        if didReceiveFocus {
            fetchSearchHistory()
        }
        
        if !didReceiveFocus, !searchText.isEmpty {
            stocksViewModel.saveSearch(text: searchText)
        }
    }
}
