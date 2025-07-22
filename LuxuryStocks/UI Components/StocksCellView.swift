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
    
    @IBOutlet weak var favoritesImage: UIImageView!
    
    func setupStocksCell(with entity: StocksEntity, loadImageHandler: @escaping () -> Void) {
        stocksImage.image = entity.stocksImage ?? UIImage(named: "AppIcon")
        stocksImage.setNeedsDisplay()
        
        if entity.stocksImage == nil {
            loadImageHandler()
        }
        
        stocksSymbol.text = entity.symbol
        stocksName.text = entity.name
        
        stocksPrice.text = "$\(entity.price)"
        stocksChange.text = "\(entity.change >= 0 ? "+" : "-")$\(abs(entity.change)) (\(abs(entity.changePercent))%)"
        stocksChange.textColor = entity.change >= 0 ? .green : .red
        
        favoritesImage.image = UIImage(named: entity.isFavorite == true ? "FavoritesActive" : "BackArrow")
        favoritesImage.setNeedsDisplay()
    }
}
