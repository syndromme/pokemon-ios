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
    func getPokemon(_ name: String?)
    func setPokemon(_ pokemon: Pokemon)
    func handleConnection()
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
    
    func getPokemon(_ name: String?) {
        worker?.fetchPokemon(Dashboard.UseCase.Request.init(name: name, offset: nil)).observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] response in
            if let pokemon = response {
                self?.presenter?.didFetchPokemons([pokemon], 0)
            }
        }) { error in
            self.presenter?.didFail(error)
        }.disposed(by: disposeBag)
    }
    
    func setPokemon(_ pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    func handleConnection() {
        ReachabilityService.shared.isConnected
            .subscribe(onNext: { connected in
                print(connected ? "🟢 Connected" : "🔴 Disconnected")
                self.presenter?.enablePagination(connected)
            })
            .disposed(by: disposeBag)
    }
}
