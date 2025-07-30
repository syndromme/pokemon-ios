//
//  DashboardController.swift
//  pokemon-ios
//
//  Created by syndromme on 28/07/25.
//

import UIKit
import ESPullToRefresh

protocol DashboardDisplayLogic: class {
    func showProgress()
    func showError(_ message: String)
    func hideProgress()
    func showPokemons(_ pokemons: [Pokemon], _ page: Int)
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
    
    private var resultSearchController: UISearchController = {
      let controller = UISearchController(searchResultsController: nil)
      controller.dimsBackgroundDuringPresentation = false
      controller.searchBar.sizeToFit()
      return controller
    }()
    
    var pokemons = [Pokemon]()
    var workItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showProgress()
        setupTableView()
        interactor?.getPokemons(0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.es.addPullToRefresh {
            self.interactor?.getPokemons(0)
            self.tableView.es.stopPullToRefresh()
        }
        tableView.es.addInfiniteScrolling {
            self.interactor?.getPokemons(self.pokemons.count)
            self.tableView.es.stopLoadingMore()
        }
        
        resultSearchController.searchResultsUpdater = self
        tableView.tableHeaderView = resultSearchController.searchBar
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
    
    func showPokemons(_ pokemons: [Pokemon], _ page: Int) {
        if page == 0 {
            self.pokemons.removeAll()
        }
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

extension DashboardController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        workItem?.cancel()

        let workItem = DispatchWorkItem { [weak self] in
            self?.pokemons.removeAll()
            if (!(searchController.searchBar.text?.isEmpty ?? true)) {
                self?.interactor?.getPokemon(searchController.searchBar.text ?? "")
            } else {
                self?.interactor?.getPokemons(0)
            }
            searchController.dismiss(animated: true)
        }

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
        self.workItem = workItem
    }
}
