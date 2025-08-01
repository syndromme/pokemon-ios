//
//  LoginRouter.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import UIKit
import Foundation

protocol LoginRoutingLogic: class {
    func routeToRegister()
    func routeToMainTab()
}

protocol LoginDataPassing: class {
  var dataStore: LoginDataStore? { get }
}

final class LoginRouter: LoginRoutingLogic, LoginDataPassing {

  weak var viewController: LoginController?
  var dataStore: LoginDataStore?

    func routeToRegister() {
        if viewController?.navigationController?.viewControllers.contains(where: { $0 is RegisterController }) ?? false {
            viewController?.navigationController?.popViewController(animated: true)
        } else {
            let destinationViewController = RegisterController(nibName: "RegisterView", bundle: nil)
            viewController?.navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
    
    func routeToMainTab() {
        let main = MainTab()
        let nav = UINavigationController(rootViewController: main)
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .coverVertical
        viewController?.navigationController?.present(nav, animated: true)
    }
}
