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
    
    @IBOutlet weak var stackView: UIStackView!
    
    var suggestionStackViews: [UIStackView] = []

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
        
        var foundRowThatFits = false
        
        for row in suggestionStackViews {
            var occupiedWidth: CGFloat = 0
            
            for subview in row.arrangedSubviews {
                if let currentBubble = subview as? BubbleView {
                    occupiedWidth += currentBubble.calculateTextSize()
                }
            }
            
            //print("occupied \(occupiedWidth)")
            //print(UIScreen.main.bounds.width)
            
            foundRowThatFits = occupiedWidth + bubble.calculateTextSize() <= UIScreen.main.bounds.width - 20
            if foundRowThatFits {
                row.addArrangedSubview(bubble)
                break
            }
        }
        
        //print("fits = \(foundRowThatFits)")
        
        if !foundRowThatFits {
            let rowView = UIStackView()
            rowView.axis = .horizontal
            rowView.distribution = .fill
            //rowView.spacing = 2
            
            stackView.addArrangedSubview(rowView)
            suggestionStackViews.append(rowView)
            
            rowView.addArrangedSubview(bubble)
            
            //rowView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //b.calculateTextSize()
        
        //debug.addArrangedSubview(b)
    }
}
