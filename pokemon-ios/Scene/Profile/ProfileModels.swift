//
//  ProfileModels.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import Foundation

enum Profile {

  enum UseCase {

      struct Request: Codable {
          let userID: String
          let image: Data?
      }

    struct Response { }

    struct ViewModel { }
  }
}
