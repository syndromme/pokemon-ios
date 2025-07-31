//
//  UIViewController+Extension.swift
//  pokemon-ios
//
//  Created by syndromme on 29/07/25.
//

import MBProgressHUD

extension UIViewController {
    func showLoading(message: String? = nil, delay: TimeInterval? = nil) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate
        if let message = message {
            hud.mode = .customView
            hud.label.text = message
            hud.customView = UIImageView(image: UIImage(systemName: "checkmark.seal.fill"))
        }
        guard let delay = delay else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.hideLoading()
        }
    }
    
    func hideLoading() {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    
}
