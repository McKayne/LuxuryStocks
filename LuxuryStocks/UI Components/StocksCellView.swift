//
//  StocksCellView.swift
//  LuxuryStocks
//
//  Created by johndoe on 7/19/25.
//

import UIKit

class StocksCellView: UITableViewCell {
    
    @IBOutlet weak var stocksImage: UIImageView!
    
    @IBOutlet weak var stocksSymbol: UILabel!
    
    @IBOutlet weak var stocksName: UILabel!
    
    @IBOutlet weak var stocksPrice: UILabel!
    
    @IBOutlet weak var stocksChange: UILabel!
    
    func setupStocksCell(with entity: StocksEntity, loadImageHandler: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.stocksImage.image = entity.stocksImage ?? UIImage(named: "AppIcon")
            self.stocksImage.setNeedsDisplay()
        }
        
        if entity.stocksImage == nil {
            loadImageHandler()
        }
        
        stocksSymbol.text = entity.symbol
        stocksName.text = entity.name
        
        stocksPrice.text = "$\(entity.price)"
        stocksChange.text = "\(entity.change >= 0 ? "+" : "-")$\(abs(entity.change)) (\(abs(entity.changePercent))%)"
        stocksChange.textColor = entity.change >= 0 ? .green : .red
    }
}
