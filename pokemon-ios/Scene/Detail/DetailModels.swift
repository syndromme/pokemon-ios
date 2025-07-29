//
//  DetailModels.swift
//  pokemon-ios
//
//  Created by syndromme on 29/07/25.
//

import Foundation

enum Detail {

  enum UseCase {

      struct Request: Codable {
        let name: String?
    }

    struct Response { }

    struct ViewModel { }
  }
}
