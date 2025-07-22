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
    
    var isFavoritesHidden = false
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
        if !isFavoritesHidden {
            isFavoritesOnly = false
            updateUI()
            
            delegate?.didSelect(favoritesOnly: false)
        }
    }
    
    @objc func selectFavoritesOnly(_ recognizer: UITapGestureRecognizer) {
        isFavoritesOnly = true
        updateUI()
        
        delegate?.didSelect(favoritesOnly: true)
    }
    
    func updateUI() {
        favoritesLabel.isHidden = isFavoritesHidden
        
        stocksLabel.font = UIFont.systemFont(ofSize: isFavoritesOnly ? 18 : 28, weight: .black)
        favoritesLabel.font = UIFont.systemFont(ofSize: isFavoritesOnly ? 28 : 18, weight: .black)
        
        stocksLabel.textColor = isFavoritesOnly ? .lightGray : .black
        favoritesLabel.textColor = isFavoritesOnly ? .black : .lightGray
    }
}
