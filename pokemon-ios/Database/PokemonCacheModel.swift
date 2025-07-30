//
//  PokemonCacheModel.swift
//  pokemon-ios
//
//  Created by syndromme on 28/07/25.
//

import RealmSwift

class PokemonCacheModel: Object {
    @Persisted var id: Int = 0
    @Persisted var name: String = ""
    @Persisted var url: String = ""
    @Persisted var baseExperience: Int = 0
    @Persisted var height: Int = 0
    @Persisted var weight: Int = 0
    @Persisted var statistics: List<StatisticsCacheModel>

    override static func primaryKey() -> String? {
        return "name"
    }

    func toPokemon() -> Pokemon {
        return .init(id: id, name: name, url: url, baseExperience: baseExperience, height: height, weight: weight, stats: [], types: [], abilities: [])
    }

    static func from(pokemon: Pokemon) -> PokemonCacheModel {
        let model = PokemonCacheModel()
        model.name = pokemon.name
        model.url = pokemon.url ?? ""
//        model.baseExperience = pokemon?.baseExperience
//        model.height = pokemon?.height
//        model.weight = pokemon?.weight
//        model.statistics = pokemon.statistics.map({ statistic in
//            StatisticsCacheModel(value: statistic)
//        })//(StatisticsCacheModel.init)
        return model
    }
}

class StatisticsCacheModel: Object {
    @Persisted var baseStat: Int = 0
    @Persisted var effort: Int = 0
    @Persisted var stat: StatisticCacheModel?
    
    func toStatistics() -> Statistics {
        .init(baseStat: baseStat, effort: effort, stat: stat!.toStatistic())
    }
}

class StatisticCacheModel: Object {
    @Persisted var name: String = ""
    @Persisted var url: String = ""
    
    func toStatistic() -> DefaultResponse {
        .init(name: name, url: url)
    }
}
