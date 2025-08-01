//
//  AppError.swift
//  pokemon-ios
//
//  Created by syndromme on 01/08/25.
//

import Foundation

enum AppError: Swift.Error, LocalizedError {
    case genericError(message: String)

    public var errorDescription: String? {
        get {
            switch self {
            case .genericError(let message):
                return message
            }
        }
    }
}
