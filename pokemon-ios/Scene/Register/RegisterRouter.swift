//
//  RegisterRouter.swift
//  pokemon-ios
//
//  Created by syndromme on 30/07/25.
//

import Foundation

protocol RegisterRoutingLogic: class {
    func routeToLogin()
}

protocol RegisterDataPassing: class {
  var dataStore: RegisterDataStore? { get }
}

final class RegisterRouter: RegisterRoutingLogic, RegisterDataPassing {

  weak var viewController: RegisterController?
  var dataStore: RegisterDataStore?
    
    func routeToLogin() {
        if viewController?.navigationController?.viewControllers.contains(where: { $0 is LoginController }) ?? false {
            viewController?.navigationController?.popViewController(animated: true)
        } else {
            let destinationViewController = LoginController(nibName: "LoginView", bundle: nil)
            viewController?.navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }

}
