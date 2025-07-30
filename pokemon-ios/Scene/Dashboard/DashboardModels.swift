//
//  DashboardModels.swift
//  pokemon-ios
//
//  Created by syndromme on 28/07/25.
//

import Foundation
import Realm
import RealmSwift

enum Dashboard {

    enum UseCase {

        struct Request: Codable {
            let name: String?
            let limit: Int = 20
            let offset: Int?
        }
        
        struct Response: Codable {
            let count: Int
            let results: [Pokemon]
        }

        struct ViewModel { }
  }
}

struct Pokemon: Codable {
    let id: Int?
    let name: String
    let url: String?
    let baseExperience: Int?
    let height: Int?
    let weight: Int?
    let stats: [Statistics]?
    let types: [MonsterType]?
    let abilities: [MonsterAbility]?
    
    var idFromURL: String {
        get {
            return String(format: "#%03d", id ?? Int(URL(string: url ?? "")?.lastPathComponent ?? "0") ?? 0)
        }
    }
}

struct Statistics: Codable {
    let baseStat: Int
    let effort: Int
    let stat: DefaultResponse
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}

struct MonsterType: Codable {
    let slot: Int
    let type: DefaultResponse
    
    var color: UIColor {
        get {
            switch type.name {
            case "fire":
                return UIColor.fire
            case "water":
                return UIColor.water
            case "electric":
                return UIColor.electric
            case "grass":
                return UIColor.grass
            case "ice":
                return UIColor.ice
            case "fighting":
                return UIColor.fighting
            case "poison":
                return UIColor.poison
            case "ground":
                return UIColor.ground
            case "flying":
                return UIColor.flying
            case "psychic":
                return UIColor.psychic
            case "bug":
                return UIColor.bug
            case "rock":
                return UIColor.rock
            case "ghost":
                return UIColor.ghost
            case "dragon":
                return UIColor.dragon
            case "dark":
                return UIColor.dark
            case "steel":
                return UIColor.steel
            case "fairy":
                return UIColor.fairy
            default:
                return UIColor.normal
            }
        }
    }
}

struct MonsterAbility: Codable {
    let slot: Int
    let isHidden: Bool
    let ability: DefaultResponse
    
    enum CodingKeys: String, CodingKey {
        case isHidden = "is_hidden"
        case slot, ability
    }
}

struct DefaultResponse: Codable {
    let name: String
    let url: String
}
