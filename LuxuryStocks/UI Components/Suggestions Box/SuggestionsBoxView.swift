//
//  SuggestionsBoxView.swift
//  LuxuryStocks
//
//  Created by johndoe on 7/20/25.
//

import UIKit
import SnapKit

@IBDesignable class SuggestionsBoxView: UIView {
    
    @IBInspectable var xibName: String?
    
    @IBOutlet var delegate: SuggestionsBoxDelegate?
    
    @IBOutlet weak var stackView: UIStackView!
    
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
            
            //debug.axis = .horizontal
            //debug.distribution = .equalSpacing
            //debug.spacing = 2
            
            //stackView.addArrangedSubview(debug)
        }
    }
    
    func appendSuggestion(text: String) {
        let bubble = BubbleView(frame: .zero, text: text)
        bubble.isUserInteractionEnabled = true
        bubble.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(textBubbleTap(_:))))
        
        var foundRowThatFits = false
        
        for row in stackView.arrangedSubviews {
            if let row = row as? UIStackView {
                var occupiedWidth: CGFloat = 0
            
                for subview in row.arrangedSubviews {
                    if let currentBubble = subview as? BubbleView {
                        occupiedWidth += currentBubble.calculateTextSize()
                    }
                }
                     
                let horizontalOffset: CGFloat = 10
                foundRowThatFits = occupiedWidth + bubble.calculateTextSize() <= UIScreen.main.bounds.width - horizontalOffset * 2
                if foundRowThatFits {
                    row.addArrangedSubview(bubble)
                    break
                }
            }
        }
        
        if !foundRowThatFits {
            let rowView = UIStackView()
            rowView.axis = .horizontal
            rowView.distribution = .fill
            
            stackView.addArrangedSubview(rowView)
            
            rowView.addArrangedSubview(bubble)
        }
    }
    
    func removeAll() {
        for row in stackView.arrangedSubviews {
            row.removeFromSuperview()
        }
    }
    
    @objc func textBubbleTap(_ recognizer: UITapGestureRecognizer) {
        if let bubble = recognizer.view as? BubbleView, let text = bubble.bubbleText.text {
            delegate?.suggestionsBox(didSelectedBubbleWith: text)
        }
    }
}
