//
//  TabBar.swift
//  LuxuryStocks
//
//  Created by johndoe on 7/19/25.
//

import UIKit
import SnapKit

@IBDesignable class TabBar: UIView {
    
    @IBInspectable var xibName: String?
    
    @IBOutlet weak var stocksLabel: UILabel!
    
    @IBOutlet weak var favoritesLabel: UILabel!
    
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
        }
    }
    
}
