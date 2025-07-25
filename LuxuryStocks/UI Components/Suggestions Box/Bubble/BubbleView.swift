//
//  BubbleView.swift
//  LuxuryStocks
//
//  Created by johndoe on 7/20/25.
//

import UIKit
import SnapKit

@IBDesignable class BubbleView: UIView {
    
    
    @IBOutlet weak var bubbleText: UILabel!
    
    let xibName = "Bubble"
    
    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        
        if let container = (Bundle.main.loadNibNamed("Bubble", owner: self, options: nil) as? [UIView])?.first {
            addSubview(container)
            
            container.snp.makeConstraints({ (make) -> Void in
                make.edges.equalTo(self)
            })
                        
            bubbleText.text = text
        }
    }
    
    func calculateTextSize() -> CGFloat {
        let textSize = self.bubbleText.text?.size(withAttributes: [.font: self.bubbleText.font]) ?? .zero
        let textOffset: CGFloat = 20
        let viewOffset: CGFloat = 10
        let size = textSize.width + textOffset * 2 + viewOffset * 2
        
        return size
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
    }
    
    override func awakeFromNib() {
        
        if subviews.count == 0 {
            guard let xib = Bundle.main.loadNibNamed(xibName, owner: self),
                  let view = xib.first as? UIView
            else {
                
                return
            }
            
            addSubview(view)
            
            /*view.snp.makeConstraints({ (make) -> Void in
                make.edges.equalTo(self)
            })*/
        }
    }
}
