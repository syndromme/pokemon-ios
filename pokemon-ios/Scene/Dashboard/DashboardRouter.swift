//
//  DashboardRouter.swift
//  pokemon-ios
//
//  Created by syndromme on 28/07/25.
//

import Foundation

protocol DashboardRoutingLogic: class {
    func routeToDetail()
}

protocol DashboardDataPassing: class {
  var dataStore: DashboardDataStore? { get }
}

final class DashboardRouter: DashboardRoutingLogic, DashboardDataPassing {

  weak var viewController: DashboardController?
  var dataStore: DashboardDataStore?

    func routeToDetail() {
        let destinationViewController = DetailController(nibName: "DetailView", bundle: nil)
        let destinationDataStore = destinationViewController.router?.dataStore

        destinationDataStore?.pokemon = dataStore!.pokemon
        viewController?.navigationController?.pushViewController(destinationViewController, animated: true)
        
    }
}
