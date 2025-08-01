//
//  AppError.swift
//  pokemon-ios
//
//  Created by syndromme on 01/08/25.
//

import Foundation

enum AppError: Swift.Error, LocalizedError {
    case networkError(Error)
    case serverError(code: Int, message: String)
    case decodingError(Error)
    case genericError(message: String)

    public var errorDescription: String? {
        get {
            switch self {
            case .serverError(_, let message):
                return message
            case .genericError(let message):
                return message
            default :
                return localizedDescription
            }
        }
    }
}
