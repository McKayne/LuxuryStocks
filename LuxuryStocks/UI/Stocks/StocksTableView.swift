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
        filteredStocks[indexPath.row] = stocksViewModel.changeFavoritesState(entity: filteredStocks[indexPath.row])
        stocksTableView.reloadData()
    }
    
    // MARK: - Data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StocksCell", for: indexPath)
        
        if let stocksCell = cell as? StocksCellView {
            stocksCell.setupStocksCell(with: filteredStocks[indexPath.row]) {
                self.fetchStocksImageIfNeeded(stocksIndex: indexPath.row)
            }
        }
        
        return cell
    }
}
