//
//  DetailWorker.swift
//  pokemon-ios
//
//  Created by syndromme on 29/07/25.
//

import Foundation
import RxSwift

final class DetailWorker {
    private let repository = PokemonRepository()
    
    func fetchPokemon(request: Detail.UseCase.Request) -> Observable<Pokemon?> {
        repository.getPokemon(request: request)
    }
}
