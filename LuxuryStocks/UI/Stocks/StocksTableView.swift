//
//  StocksTableView.swift
//  LuxuryStocks
//
//  Created by johndoe on 7/19/25.
//

import UIKit

extension StocksController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Delegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - Data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StocksCell", for: indexPath)
        
        if let stocksCell = cell as? StocksCellView {
            stocksCell.setupStocksCell(with: currentStocks[indexPath.row]) {
                self.fetchStocksImageIfNeeded(stocksIndex: indexPath.row)
            }
        }
        
        return cell
    }
}
