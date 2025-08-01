//
//  ProfileRouter.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import Foundation

protocol ProfileRoutingLogic: class {
    func routeToLogin()
}

protocol ProfileDataPassing: class {
  var dataStore: ProfileDataStore? { get }
}

final class ProfileRouter: ProfileRoutingLogic, ProfileDataPassing {

  weak var viewController: ProfileController?
  var dataStore: ProfileDataStore?

    func routeToLogin() {
        viewController?.dismiss(animated: true)
    }
}
