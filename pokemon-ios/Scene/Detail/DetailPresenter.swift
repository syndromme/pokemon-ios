//
//  DetailPresenter.swift
//  pokemon-ios
//
//  Created by syndromme on 29/07/25.
//

import Foundation

protocol DetailPresentationLogic: class {
    func didFetchPokemon(_ pokemon: Pokemon?)
    func didFail(_ error: Error)
}

final class DetailPresenter: DetailPresentationLogic {

  weak var viewController: DetailDisplayLogic?
    
    func didFetchPokemon(_ pokemon: Pokemon?) {
        viewController?.hideProgress()
        viewController?.showPokemon(pokemon)
    }
    
    func didFail(_ error: any Error) {
        viewController?.showError(error.localizedDescription)
    }

}
