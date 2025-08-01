//
//  ProfileDetailView.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import UIKit

class ProfileDetailView: UIView {
    
    private var bottomBorder: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.lightGray.cgColor
        
        return layer
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomBorder.frame = CGRect(x: 16, y: bounds.height - 1, width: bounds.width - 16, height: 1)
    }
    
    init(title: String? = nil, subtitle: String? = nil, border: Bool = false) {
        super.init(frame: .zero)
        super.invalidateIntrinsicContentSize()
        self.configure(title: title, subtitle: subtitle, border: border)
    }
    
    private func configure(title: String? = nil, subtitle: String? = nil, border: Bool = false) {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 14, weight: .light)
        titleLabel.text = title
        let subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .right
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        subtitleLabel.text = subtitle
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        if border {
            layer.addSublayer(bottomBorder)
        }
    }
}
