//
//  CapsuleButton.swift
//  pokemon-ios
//
//  Created by syndromme on 30/07/25.
//

import UIKit

class CapsuleButton: UIButton {
    
    init(title: String, font: UIFont = .systemFont(ofSize: 16, weight: .medium), backgroundColor: UIColor = .systemBlue, foregroundColor: UIColor = .white) {
        super.init(frame: .zero)
        configure(title: title, font: font, backgroundColor: backgroundColor, foregroundColor: foregroundColor)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure(title: "Button")
    }
    
    private func configure(title: String, font: UIFont = .systemFont(ofSize: 16, weight: .medium), backgroundColor: UIColor = .systemBlue, foregroundColor: UIColor = .white) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.cornerStyle = .capsule
        config.baseBackgroundColor = backgroundColor
        config.baseForegroundColor = foregroundColor
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var updated = attributes
            updated.font = font
            return updated
        }
        
        self.configuration = config
    }
}
