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
    private let reachability = ReachabilityService.shared
    private let realm = try! Realm()

    init(apiProvider: APIProviderProtocol = APIProvider()) {
        self.apiProvider = apiProvider
    }

    func getPokemons(request: Dashboard.UseCase.Request) -> Observable<Dashboard.UseCase.Response> {
        if !reachability.currentStatus() {
            return self.loadListFromCache()
        }
        
        return apiProvider.request(APIService.fetch(name: request.name, limit: request.limit, offset: request.offset)).do(onNext: { response in
            self.saveToCache(response.results)
        }).catch { error in
            print("⚠️ API failed, falling back to cache: \(error.localizedDescription)")
            if let err = error as? AppError {
                return Observable.error(err)
            }
            return self.loadListFromCache()
        }
    }
    
    func getPokemon(request: Dashboard.UseCase.Request) -> Observable<Pokemon?> {
        if !reachability.currentStatus() {
            return self.loadItemFromCache(name: request.name ?? "")
        }
        return apiProvider.request(APIService.fetch(name: request.name, offset: nil)).do(onNext: { response in
            self.updateCache(response!)
        }).catch { error in
            print("⚠️ API failed, falling back to cache: \(error.localizedDescription)")
            if let err = error as? AppError {
                return Observable.error(err)
            }
            return self.loadItemFromCache(name: request.name ?? "")
            
        }
    }

    private func saveToCache(_ pokemons: [Pokemon]) {
        do {
            try realm.write {
                realm.add(pokemons.map(PokemonCacheModel.from), update: .modified)
            }
        } catch {
            print("❌ Failed to save cache: \(error)")
        }
    }

    private func loadListFromCache() -> Observable<Dashboard.UseCase.Response> {
        do {
            let cached = realm.objects(PokemonCacheModel.self)
            let pokemons = cached.map { $0.toPokemon() }
            return Observable.just(Dashboard.UseCase.Response.init(count: pokemons.count, results: Array(pokemons)))
        } catch {
            print("❌ Failed to load cache: \(error)")
            return Observable.error(error)
        }
    }
    
    private func loadItemFromCache(name: String) -> Observable<Pokemon?> {
        do {
            if let pokemon = realm.object(ofType: PokemonCacheModel.self, forPrimaryKey: name.lowercased()) {
                return .just(pokemon.toPokemon())
            }
            return .just(nil)
        } catch {
            print("❌ Failed to load cache: \(error)")
            return Observable.error(error)
        }
    }
    
    private func updateCache(_ pokemon: Pokemon) {
        do {
            let cached = realm.objects(PokemonCacheModel.self)
            guard let cachedPokemon = cached.where({ $0.name == pokemon.name}).first else { return }
            
            try realm.write {
                cachedPokemon.baseExperience = pokemon.baseExperience ?? 0
                cachedPokemon.height = pokemon.height ?? 0
                cachedPokemon.weight = pokemon.weight ?? 0
                pokemon.stats?.forEach({ stat in
                    cachedPokemon.statistics.append(StatisticsCacheModel.from(statistic: stat))
                })
                pokemon.types?.forEach({ type in
                    cachedPokemon.types.append(TypeCacheModel.from(value: type))
                })
                pokemon.abilities?.forEach({ ability in
                    cachedPokemon.abilities.append(AbilityCacheModel.from(value: ability))
                })
            }
        } catch {
            print("❌ Failed to update cache: \(error)")
        }
    }
}
