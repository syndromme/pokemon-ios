//
//  LoginRouter.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import Foundation

protocol LoginRoutingLogic: class {
    func routeToRegister()
}

protocol LoginDataPassing: class {
  var dataStore: LoginDataStore? { get }
}

final class LoginRouter: LoginRoutingLogic, LoginDataPassing {

  weak var viewController: LoginController?
  var dataStore: LoginDataStore?

    func routeToRegister() {
        let destinationViewController = RegisterController(nibName: "RegisterView", bundle: nil)
        viewController?.navigationController?.pushViewController(destinationViewController, animated: true)
    }
}
