//
//  ProfilePresenter.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import Foundation

protocol ProfilePresentationLogic: class {
    func didSuccess()
    func didFail(_ error: Error)
}

final class ProfilePresenter: ProfilePresentationLogic {

  weak var viewController: ProfileDisplayLogic?
    func didSuccess() {
        
    }
    
    func didFail(_ error: any Error) {
        
    }
}
