//
//  StatView.swift
//  pokemon-ios
//
//  Created by syndromme on 30/07/25.
//
import UIKit

@IBDesignable
class StatView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var statLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)

        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    convenience init(name: String, stat: Int, progress: Float, color: UIColor) {
        self.init()
        self.statLabel.text = name
        self.statLabel.textColor = color
        self.valueLabel.text = "\(stat)"
        self.progressView.setProgress(progress, animated: false)
        self.progressView.progressTintColor = color
        self.progressView.trackTintColor = color.withAlphaComponent(0.25)
    }
}
