//
//  LoginPresenter.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import Foundation

protocol LoginPresentationLogic: class {
    func didSuccess(_ user: Login.UseCase.Response?)
    func didFail(_ error: Error)
}

final class LoginPresenter: LoginPresentationLogic {

  weak var viewController: LoginDisplayLogic?
    func didSuccess(_ user: Login.UseCase.Response?) {
        if let user = user {
            viewController?.showLoginSuccess(user)
        } else {
            viewController?.showError("User not found.")
        }
    }
    
    func didFail(_ error: Error) {
        viewController?.showError(error.localizedDescription)
    }
}
