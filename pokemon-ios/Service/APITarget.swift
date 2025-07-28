//
//  NetworkTarget.swift
//  pokemon-ios
//
//  Created by syndromme on 28/07/25.
//

import Alamofire

protocol APITarget {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: APITask { get }
    var headers: HTTPHeaders? { get }
}

extension APITarget {
    var url: String { return baseURL + path }
    var headers: HTTPHeaders? { return nil }
}
