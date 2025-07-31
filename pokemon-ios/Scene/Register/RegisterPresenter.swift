//
//  RegisterPresenter.swift
//  pokemon-ios
//
//  Created by syndromme on 30/07/25.
//

import Foundation

protocol RegisterPresentationLogic: class {
    func didSuccess()
    func didFail(_ error: Error)
}

final class RegisterPresenter: RegisterPresentationLogic {

  weak var viewController: RegisterDisplayLogic?
    func didSuccess() {
        viewController?.showRegisterSuccess()
    }
    
    func didFail(_ error: any Error) {
        viewController?.showError(error.localizedDescription)
    }
}
