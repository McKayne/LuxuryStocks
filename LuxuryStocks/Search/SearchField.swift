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
    
    private let backView = UIImageView(image: UIImage(named: "BackArrow"))
    private let clearView = UIImageView(image: UIImage(named: "BackArrow"))
    
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
            
            searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            
            searchTextField.leftView = backView
            searchTextField.rightView = clearView
            
            backView.isUserInteractionEnabled = true
            backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backArrowDidTap(_:))))
            
            clearView.isUserInteractionEnabled = true
            clearView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clearDidTap(_:))))
        }
    }
    
    // MARK: - Search text
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchTextField.leftViewMode = .always
        delegate?.searchText(didReceiveFocus: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField.leftViewMode = searchTextField.text?.isEmpty == true ? .never : .always
        delegate?.searchText(didReceiveFocus: false)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        searchTextField.rightViewMode = searchTextField.text?.isEmpty == true ? .never : .always
        delegate?.searchText(didChangeTo: searchTextField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    @objc func backArrowDidTap(_ recognizer: UITapGestureRecognizer) {
        searchTextField.text = ""
        searchTextField.endEditing(true)
        
        textFieldDidChange(searchTextField)
        textFieldDidEndEditing(searchTextField)
    }
    
    @objc func clearDidTap(_ recognizer: UITapGestureRecognizer) {
        searchTextField.becomeFirstResponder()
        searchTextField.text = ""
        
        textFieldDidChange(searchTextField)
    }
}
