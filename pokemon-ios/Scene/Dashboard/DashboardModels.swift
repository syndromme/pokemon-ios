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

        struct Request { }
        
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
    
    var idFromURL: String {
        get {
            return String(format: "#%03d", id ?? Int(URL(string: url ?? "")?.lastPathComponent ?? "0") ?? 0)
        }
    }
}

struct Statistics: Codable {
    let baseStat: Int
    let effort: Int
    let stat: Statistic
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}

struct Statistic: Codable {
    let name: String
    let url: String
}
