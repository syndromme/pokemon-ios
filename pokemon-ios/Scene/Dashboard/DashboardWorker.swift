//
//  DashboardWorker.swift
//  pokemon-ios
//
//  Created by syndromme on 28/07/25.
//

import Foundation
import RxSwift

final class DashboardWorker {
    private let repository = PokemonRepository()
    
    func fetchPokemons() -> Observable<Dashboard.UseCase.Response> {
        repository.getPokemons()
    }
}
