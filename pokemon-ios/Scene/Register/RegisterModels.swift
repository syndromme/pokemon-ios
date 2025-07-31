//
//  RegisterModels.swift
//  pokemon-ios
//
//  Created by syndromme on 30/07/25.
//

import Foundation

enum Register {

  enum UseCase {

      struct Request: Codable {
          let firstName: String
          let lastName: String
          let email: String
          let phoneNumber: String
          let password: String
      }

    struct Response { }

    struct ViewModel { }
  }
}
