//
//  StocksControllerSuggestions.swift
//  LuxuryStocks
//
//  Created by johndoe on 7/22/25.
//

import Foundation

extension StocksController: SuggestionsBoxDelegate {
    
    func suggestionsBox(didSelectedBubbleWith text: String) {
        searchField.searchTextField.text = text
        searchText(didChangeTo: text)
    }
}
