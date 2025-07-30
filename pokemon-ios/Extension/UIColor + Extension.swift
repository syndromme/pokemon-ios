//
//  UIColor + Extension.swift
//  pokemon-ios
//
//  Created by syndromme on 30/07/25.
//

import UIKit

extension UIColor {
    convenience init(hex code: String) {
        var cString = code.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        var color: UIColor
        if cString.count != 6 {
            color = UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        color = UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        self.init(cgColor: color.cgColor)
    }
    
//    https://gist.github.com/apaleslimghost/0d25ec801ca4fc43317bcff298af43c3
    class var normal: UIColor {
        get {
            UIColor(hex: "#A8A77A")
        }
    }
    class var fire: UIColor {
        get {
            UIColor(hex: "#EE8130")
        }
    }
    class var water: UIColor {
        get {
            UIColor(hex: "#6390F0")
        }
    }
    class var electric: UIColor {
        get {
            UIColor(hex: "#F7D02C")
        }
    }
    class var grass: UIColor {
        get {
            UIColor(hex: "#7AC74C")
        }
    }
    class var ice: UIColor {
        get {
            UIColor(hex: "#96D9D6")
        }
    }
    
    class var fighting: UIColor {
        get {
            UIColor(hex: "#C22E28")
        }
    }
    class var poison: UIColor {
        get {
            UIColor(hex: "#A33EA1")
        }
    }
    class var ground: UIColor {
        get {
            UIColor(hex: "#E2BF65")
        }
    }
    class var flying: UIColor {
        get {
            UIColor(hex: "#A98FF3")
        }
    }
    class var psychic: UIColor {
        get {
            UIColor(hex: "#F95587")
        }
    }
    class var bug: UIColor {
        get {
            UIColor(hex: "#A6B91A")
        }
    }
    class var rock: UIColor {
        get {
            UIColor(hex: "#B6A136")
        }
    }
    class var ghost: UIColor {
        get {
            UIColor(hex: "#735797")
        }
    }
    class var dragon: UIColor {
        get {
            UIColor(hex: "#6F35FC")
        }
    }
    class var dark: UIColor {
        get {
            UIColor(hex: "#705746")
        }
    }
    class var steel: UIColor {
        get {
            UIColor(hex: "#B7B7CE")
        }
    }
    class var fairy: UIColor {
        get {
            UIColor(hex: "#D685AD")
        }
    }
}
