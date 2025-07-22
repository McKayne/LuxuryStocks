//
//  TabBar.swift
//  LuxuryStocks
//
//  Created by johndoe on 7/19/25.
//

import UIKit
import SnapKit

@IBDesignable class TabBar: UIView {
    
    @IBOutlet var delegate: TabBarDelegate?
    
    @IBInspectable var xibName: String?
    
    @IBOutlet weak var stocksLabel: UILabel!
    
    @IBOutlet weak var favoritesLabel: UILabel!
    
    var isFavoritesOnly = false
    
    override func awakeFromNib() {
        if subviews.count == 0 {
            guard let name = xibName,
                  let xib = Bundle.main.loadNibNamed(name, owner: self),
                  let view = xib.first as? UIView
            else {
                return
            }
            
            addSubview(view)
            
            view.snp.makeConstraints({ (make) -> Void in
                make.edges.equalTo(self)
            })
            
            stocksLabel.isUserInteractionEnabled = true
            favoritesLabel.isUserInteractionEnabled = true
            
            stocksLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectAllStocks(_:))))
            favoritesLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectFavoritesOnly(_:))))
            
            updateUI()
        }
    }
    
    @objc func selectAllStocks(_ recognizer: UITapGestureRecognizer) {
        isFavoritesOnly = false
        updateUI()
        
        delegate?.didSelect(favoritesOnly: false)
    }
    
    @objc func selectFavoritesOnly(_ recognizer: UITapGestureRecognizer) {
        isFavoritesOnly = true
        updateUI()
        
        delegate?.didSelect(favoritesOnly: true)
    }
    
    private func updateUI() {
        stocksLabel.font = UIFont.systemFont(ofSize: isFavoritesOnly ? 15 : 20, weight: isFavoritesOnly ? .medium : .black)
        favoritesLabel.font = UIFont.systemFont(ofSize: isFavoritesOnly ? 20 : 15, weight: isFavoritesOnly ? .black : .medium)
    }
}
