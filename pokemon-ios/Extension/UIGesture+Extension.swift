//
//  UIGesture+Extension.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//
import UIKit

extension UITapGestureRecognizer {
    func handleTapLabel(with closure: @escaping (String) -> Void) {
        guard let label = self.view as? UILabel, let attributedText = label.attributedText else { return }

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: attributedText)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y)

        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        // Check if the tapped character is within a link range
        attributedText.enumerateAttribute(.link, in: NSRange(location: 0, length: attributedText.length), options: []) { (value, range, stop) in
            if let string = value as? String, NSLocationInRange(indexOfCharacter, range) {
                closure(string)
                print("Tapped on \(string)")
                // Perform action based on the tapped link (e.g., open URL)
                stop.pointee = true // Stop enumeration once a match is found
            }
        }
        
    }
}
