//
//  APITask.swift
//  pokemon-ios
//
//  Created by syndromme on 28/07/25.
//
import Alamofire

enum APITask {
    case requestPlain
    case requestParameters(parameters: Parameters, encoding: ParameterEncoding)
}
