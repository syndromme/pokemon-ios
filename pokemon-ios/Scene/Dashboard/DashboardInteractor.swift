//
//  DashboardInteractor.swift
//  pokemon-ios
//
//  Created by syndromme on 28/07/25.
//

import Foundation
import RxSwift

protocol DashboardBusinessLogic: class {
    func getPokemons()
    func setPokemon(_ pokemon: Pokemon)
}

protocol DashboardDataStore: class {
    var pokemon: Pokemon? { get set }
}

class DashboardInteractor: DashboardBusinessLogic, DashboardDataStore {
    var presenter: DashboardPresentationLogic?
    var worker: DashboardWorker?
    var pokemon: Pokemon?
    let disposeBag = DisposeBag()

    func getPokemons() {
        worker?.fetchPokemons().observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] response in
            self?.presenter?.didFetchPokemons(response.results)
        }) { error in
            self.presenter?.didFail(error)
        }.disposed(by: disposeBag)
    }
    
    func setPokemon(_ pokemon: Pokemon) {
        self.pokemon = pokemon
    }
}
