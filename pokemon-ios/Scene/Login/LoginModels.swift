//
//  LoginModels.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import Foundation

enum Login {

  enum UseCase {

      struct Request: Codable {
          let email: String
          let password: String
      }

      struct Response: Codable {
        let firstName: String
        let lastName: String
        let email: String
        let phoneNumber: String
    }

    struct ViewModel { }
  }
}
