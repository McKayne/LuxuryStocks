//
//  SearchField.swift
//  LuxuryStocks
//
//  Created by johndoe on 7/19/25.
//

import UIKit
import SnapKit

@IBDesignable class SearchField: UIView, UITextFieldDelegate {
    
    @IBOutlet var delegate: SearchFieldDelegate?
    
    @IBInspectable var xibName: String?
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.borderWidth = 1.5
            layer.borderColor = UIColor.black.cgColor
            layer.cornerRadius = newValue
        }
        
        get {
            return layer.cornerRadius
        }
    }
    
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
    
    // MARK: - Search text
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.searchText(didReceiveFocus: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.searchText(didReceiveFocus: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
}
