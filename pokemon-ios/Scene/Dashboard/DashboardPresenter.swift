//
//  DashboardPresenter.swift
//  pokemon-ios
//
//  Created by syndromme on 28/07/25.
//

import Foundation

protocol DashboardPresentationLogic: class {
    func didFetchPokemons(_ pokemons: [Pokemon])
    func didFail(_ error: Error)
}

final class DashboardPresenter: DashboardPresentationLogic {
  weak var viewController: DashboardDisplayLogic?
    func didFetchPokemons(_ pokemons: [Pokemon]) {
        viewController?.hideProgress()
        viewController?.showPokemons(pokemons)
    }
    
    func didFail(_ error: any Error) {
        viewController?.showError(error.localizedDescription)
    }

}
