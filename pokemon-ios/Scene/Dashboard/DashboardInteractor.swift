//
//  DashboardInteractor.swift
//  pokemon-ios
//
//  Created by syndromme on 28/07/25.
//

import Foundation
import RxSwift

protocol DashboardBusinessLogic: class {
    func getPokemons(_ offset: Int?)
    func setPokemon(_ pokemon: Pokemon)
}

protocol DashboardDataStore: class {
    var pokemon: Pokemon? { get set }
}

class DashboardInteractor: DashboardBusinessLogic, DashboardDataStore {
    var presenter: DashboardPresentationLogic?
    var worker: DashboardWorker?
    var pokemon: Pokemon?
    var maxPokemons: Int = 0
    let disposeBag = DisposeBag()

    func getPokemons(_ offset: Int?) {
        if (maxPokemons == offset) {
            self.presenter?.didFetchPokemons([], offset ?? 0)
        }
        worker?.fetchPokemons(Dashboard.UseCase.Request.init(name: nil, offset: offset)).observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] response in
            self?.maxPokemons = response.count
            self?.presenter?.didFetchPokemons(response.results, offset ?? 0)
        }) { error in
            self.presenter?.didFail(error)
        }.disposed(by: disposeBag)
    }
    
    func setPokemon(_ pokemon: Pokemon) {
        self.pokemon = pokemon
    }
}
