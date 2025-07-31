//
//  URL+Extension.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import UIKit

extension URL {
    func open() {
        if UIApplication.shared.canOpenURL(self) {
            UIApplication.shared.open(self, options: [:]) { success in
                if success {
                    print("URL opened successfully")
                } else {
                    print("Failed to open URL")
                }
            }
        } else {
            print("Cannot open this URL scheme.")
        }
    }
}
