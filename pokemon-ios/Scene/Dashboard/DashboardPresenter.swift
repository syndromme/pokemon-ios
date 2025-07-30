//
//  DashboardPresenter.swift
//  pokemon-ios
//
//  Created by syndromme on 28/07/25.
//

import Foundation

protocol DashboardPresentationLogic: class {
    func didFetchPokemons(_ pokemons: [Pokemon], _ offset: Int)
    func didFail(_ error: Error)
}

final class DashboardPresenter: DashboardPresentationLogic {
  weak var viewController: DashboardDisplayLogic?
    func didFetchPokemons(_ pokemons: [Pokemon], _ offset: Int) {
        viewController?.hideProgress()
        viewController?.showPokemons(pokemons, offset)
    }
    
    func didFail(_ error: any Error) {
        viewController?.showError(error.localizedDescription)
    }

}
