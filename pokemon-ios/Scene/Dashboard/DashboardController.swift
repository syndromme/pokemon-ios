//
//  DashboardController.swift
//  pokemon-ios
//
//  Created by syndromme on 28/07/25.
//

import UIKit

protocol DashboardDisplayLogic: class {
    func showProgress()
    func showError(_ message: String)
    func hideProgress()
    func showPokemons(_ pokemons: [Pokemon])
}

final class DashboardController: UIViewController {

  var interactor: DashboardBusinessLogic?
  var router: (DashboardRoutingLogic & DashboardDataPassing)?

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
    let interactor = DashboardInteractor()
    let presenter = DashboardPresenter()
    let worker = DashboardWorker()
    let router = DashboardRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var pokemons = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showProgress()
        setupTableView()
        interactor?.getPokemons()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension DashboardController: DashboardDisplayLogic {
    func showProgress() {
        showLoading()
    }
    
    func showError(_ message: String) {
        showLoading(message: message, delay: 3)
    }
    
    func hideProgress() {
        hideLoading()
    }
    
    func showPokemons(_ pokemons: [Pokemon]) {
        self.pokemons.append(contentsOf: pokemons)
        tableView.reloadData()
    }
}

extension DashboardController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        let pokemon = pokemons[indexPath.row]
        cell.textLabel?.text = pokemon.name
        cell.detailTextLabel?.text = pokemon.idFromURL
        return cell
    }
}

extension DashboardController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        interactor?.setPokemon(pokemons[indexPath.row])
        router?.routeToDetail()
    }
}
