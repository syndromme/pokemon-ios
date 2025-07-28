//
//  Network.swift
//  pokemon-ios
//
//  Created by syndromme on 28/07/25.
//
import Alamofire

enum APIService {
    case fetch(name: String?)
}

extension APIService: APITarget {
    var baseURL: String {
        return "https://pokeapi.co/api/v2/"
    }
    
    var path: String {
        switch self {
        case .fetch(let name):
            return "pokemon" + "/\(name ?? "")"
        default:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var task: APITask {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }
}
