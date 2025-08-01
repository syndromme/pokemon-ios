//
//  ProfilePresenter.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import Foundation

protocol ProfilePresentationLogic: class {
    func didGetProfile(user: Login.UseCase.Response)
    func didChangeImage(user: Login.UseCase.Response)
    func didSuccess()
    func didFail(_ error: Error)
}

final class ProfilePresenter: ProfilePresentationLogic {

  weak var viewController: ProfileDisplayLogic?
    
    func didGetProfile(user: Login.UseCase.Response) {
        viewController?.showProfile(user: user)
    }
    
    func didChangeImage(user: Login.UseCase.Response) {
        viewController?.showImageProfile(user: user)
    }
    
    func didSuccess() {
        
    }
    
    func didFail(_ error: any Error) {
        viewController?.showError(error.localizedDescription)
    }
}
