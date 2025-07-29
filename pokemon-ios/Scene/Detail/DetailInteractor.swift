//
//  DetailInteractor.swift
//  pokemon-ios
//
//  Created by syndromme on 29/07/25.
//

import Foundation
import RxSwift

protocol DetailBusinessLogic: class {
    func getPokemon()
}

protocol DetailDataStore: class {
    var pokemon: Pokemon? { get set }
}

class DetailInteractor: DetailBusinessLogic, DetailDataStore {

  var presenter: DetailPresentationLogic?
  var worker: DetailWorker?
    let disposeBag = DisposeBag()
    var pokemon: Pokemon?

    func getPokemon() {
        let request = Detail.UseCase.Request(name: pokemon?.name)
        worker?.fetchPokemon(request: request).observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            
            self.presenter?.didFetchPokemon(response)
        }) { error in
            self.presenter?.didFail(error)
        }.disposed(by: disposeBag)
    }
}
