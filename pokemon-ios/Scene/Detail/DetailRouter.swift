//
//  DetailRouter.swift
//  pokemon-ios
//
//  Created by syndromme on 29/07/25.
//

import Foundation

protocol DetailRoutingLogic: class {

}

protocol DetailDataPassing: class {
  var dataStore: DetailDataStore? { get }
}

final class DetailRouter: DetailRoutingLogic, DetailDataPassing {

  weak var viewController: DetailController?
  var dataStore: DetailDataStore?

}
