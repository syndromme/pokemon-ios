//
//  InputField.swift
//  pokemon-ios
//
//  Created by syndromme on 30/07/25.
//

import UIKit
import SkyFloatingLabelTextField

@IBDesignable
class InputField: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var textField: SkyFloatingLabelTextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setupUI()
    }
    
    private func commonInit() {
        Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)

        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    
    private func setupUI() {
        textField.setTitleVisible(true, animated: true)
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
    }
}
