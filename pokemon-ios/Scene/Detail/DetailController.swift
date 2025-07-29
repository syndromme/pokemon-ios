//
//  DetailController.swift
//  pokemon-ios
//
//  Created by syndromme on 29/07/25.
//

import UIKit

protocol DetailDisplayLogic: class {
    func showProgress()
    func showError(_ message: String)
    func hideProgress()
    func showPokemon(_ pokemon: Pokemon?)
}

final class DetailController: UIViewController {

  var interactor: DetailBusinessLogic?
  var router: (DetailRoutingLogic & DetailDataPassing)?

  // MARK: Object lifecycle

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  // MARK: Setup

  private func setup() {
    let viewController = self
    let interactor = DetailInteractor()
    let presenter = DetailPresenter()
    let worker = DetailWorker()
    let router = DetailRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showProgress()
        interactor?.getPokemon()
    }
}

extension DetailController: DetailDisplayLogic {
    func showProgress() {
        showLoading()
    }
    
    func showError(_ message: String) {
        showLoading(message: message, delay: 3)
    }
    
    func hideProgress() {
        hideLoading()
    }
    
    func showPokemon(_ pokemon: Pokemon?) {
        if pokemon == nil {
            showError("Data not found!")
            navigationController?.popViewController(animated: true)
        }
        
    }
}
