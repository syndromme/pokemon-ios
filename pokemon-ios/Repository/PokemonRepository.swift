//
//  PokemonRepository.swift
//  pokemon-ios
//
//  Created by syndromme on 28/07/25.
//

import RxSwift
import RealmSwift

class PokemonRepository {
    private let apiProvider: APIProviderProtocol

    init(apiProvider: APIProviderProtocol = APIProvider()) {
        self.apiProvider = apiProvider
    }

    func getPokemons(request: Dashboard.UseCase.Request) -> Observable<Dashboard.UseCase.Response> {
        return apiProvider.execute(APIService.fetch(name: request.name, limit: request.limit, offset: request.offset), decodeTo: Dashboard.UseCase.Response.self)
            .do(onNext: { response in
                self.saveToCache(response.results)
                
            }).catch { error in
                print("⚠️ API failed, falling back to cache: \(error.localizedDescription)")
                return self.loadListFromCache()
            }
    }
    
    func getPokemon(request: Detail.UseCase.Request) -> Observable<Pokemon?> {
        var pokemon: Pokemon?
        return apiProvider.execute(APIService.fetch(name: request.name), decodeTo: Pokemon?.self)
            .do(onNext: { response in
                pokemon = response
                self.updateCache(pokemon!)
            }).catch { error in
                print("⚠️ API failed, falling back to cache: \(error.localizedDescription)")
                return Observable.just(pokemon)
            }
    }

    private func saveToCache(_ pokemons: [Pokemon]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(pokemons.map(PokemonCacheModel.from), update: .modified)
            }
        } catch {
            print("❌ Failed to save cache: \(error)")
        }
    }

    private func loadListFromCache() -> Observable<Dashboard.UseCase.Response> {
        do {
            let realm = try Realm()
            let cached = realm.objects(PokemonCacheModel.self)
            let pokemons = cached.map { $0.toPokemon() }
            return Observable.just(Dashboard.UseCase.Response.init(count: pokemons.count, results: Array(pokemons)))
        } catch {
            return Observable.error(error)
        }
    }
    
    private func updateCache(_ pokemon: Pokemon) {
        do {
            let realm = try Realm()
            let cached = realm.objects(PokemonCacheModel.self)
            guard let cachedPokemon = cached.where{ $0.name == pokemon.name}.first else { return }
            
            try realm.write {
                cachedPokemon.id = pokemon.id ?? 0
                cachedPokemon.baseExperience = pokemon.baseExperience ?? 0
                cachedPokemon.height = pokemon.height ?? 0
                cachedPokemon.weight = pokemon.weight ?? 0
//                cachedPokemon.statistics
            }
        } catch {
            print("❌ Failed to save cache: \(error)")
        }
    }
}
