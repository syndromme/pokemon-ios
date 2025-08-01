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
    @Persisted var baseExperience: Int?
    @Persisted var height: Int?
    @Persisted var weight: Int?
    @Persisted var statistics: List<StatisticsCacheModel>
    @Persisted var types: List<TypeCacheModel>
    @Persisted var abilities: List<AbilityCacheModel>

    override static func primaryKey() -> String? {
        return "name"
    }

    func toPokemon() -> Pokemon {
        return .init(id: id,
                     name: name,
                     url: url,
                     baseExperience: baseExperience,
                     height: height,
                     weight: weight,
                     stats: statistics.map({ $0.toStatistics() }),
                     types: types.map({ $0.toMonsterType() }),
                     abilities: abilities.map({ $0.toMonsterAbility()})
        )
    }

    static func from(pokemon: Pokemon) -> PokemonCacheModel {
        let model = PokemonCacheModel()
        model.id = Int(pokemon.url?.split(separator: "/").last ?? "") ?? 0
        model.name = pokemon.name
        model.url = pokemon.url ?? ""
        model.baseExperience = pokemon.baseExperience
        model.height = pokemon.height
        model.weight = pokemon.weight
        pokemon.stats?.forEach({ stat in
            model.statistics.append(StatisticsCacheModel.from(statistic: stat))
        })
        pokemon.types?.forEach({ type in
            model.types.append(TypeCacheModel.from(value: type))
        })
        pokemon.abilities?.forEach({ ability in
            model.abilities.append(AbilityCacheModel.from(value: ability))
        })
        return model
    }
}

class StatisticsCacheModel: Object {
    @Persisted var baseStat: Int = 0
    @Persisted var effort: Int = 0
    @Persisted var stat: DefaultCacheModel?
    
    func toStatistics() -> Statistics {
        .init(baseStat: baseStat, effort: effort, stat: stat!.toDefault())
    }
    
    static func from(statistic: Statistics) -> StatisticsCacheModel {
        let model = StatisticsCacheModel()
        model.baseStat = statistic.baseStat
        model.effort = statistic.effort
        model.stat = DefaultCacheModel.from(value: statistic.stat)
        return model
    }
}

class TypeCacheModel: Object {
    @Persisted var slot: Int = 0
    @Persisted var type: DefaultCacheModel?
    
    func toMonsterType() -> MonsterType {
        .init(slot: slot, type: type!.toDefault())
    }
    
    static func from(value: MonsterType) -> TypeCacheModel {
        let model = TypeCacheModel()
        model.slot = value.slot
        model.type = DefaultCacheModel.from(value: value.type)
        return model
    }
}

class AbilityCacheModel: Object {
    @Persisted var slot: Int = 0
    @Persisted var isHidden: Bool = false
    @Persisted var ability: DefaultCacheModel?
    
    func toMonsterAbility() -> MonsterAbility {
        .init(slot: slot, isHidden: isHidden, ability: ability!.toDefault())
    }
    
    static func from(value: MonsterAbility) -> AbilityCacheModel {
        let model = AbilityCacheModel()
        model.slot = value.slot
        model.isHidden = value.isHidden
        model.ability = DefaultCacheModel.from(value: value.ability)
        return model
    }
}

class DefaultCacheModel: Object {
    @Persisted var name: String = ""
    @Persisted var url: String = ""
    
    func toDefault() -> DefaultResponse {
        .init(name: name, url: url)
    }
    
    static func from(value: DefaultResponse) -> DefaultCacheModel {
        let model = DefaultCacheModel()
        model.name = value.name
        model.url = value.url
        return model
    }
}
