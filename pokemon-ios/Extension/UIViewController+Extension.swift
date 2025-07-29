//
//  UIViewController+Extension.swift
//  pokemon-ios
//
//  Created by syndromme on 29/07/25.
//

import MBProgressHUD

extension UIViewController {
    func showLoading(message: String = "Loading", delay: TimeInterval? = nil) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate
        guard let delay = delay else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.hideLoading()
        }
    }
    
    func hideLoading() {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    
}
