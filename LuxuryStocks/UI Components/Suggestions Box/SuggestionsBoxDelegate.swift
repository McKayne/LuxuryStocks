//
//  SuggestionsBoxDelegate.swift
//  LuxuryStocks
//
//  Created by johndoe on 7/22/25.
//

import Foundation

@objc protocol SuggestionsBoxDelegate {
    
    func suggestionsBox(didSelectedBubbleWith text: String)
}
