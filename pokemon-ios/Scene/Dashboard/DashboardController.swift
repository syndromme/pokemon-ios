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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var resultSearchController: UISearchController = {
      let controller = UISearchController(searchResultsController: nil)
      controller.obscuresBackgroundDuringPresentation = false
      controller.searchBar.sizeToFit()
      return controller
    }()
    
    var pokemons = [Pokemon]()
    var workItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showProgress()
        setupCollectionView()
        interactor?.getPokemons(0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Pokédex"
        navigationItem.largeTitleDisplayMode = .automatic
        resultSearchController.searchResultsUpdater = self
        navigationItem.searchController = resultSearchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "PokemonCollectionCell", bundle: nil), forCellWithReuseIdentifier: "pokemonCollectionCell")
        
        collectionView.es.addPullToRefresh {
            self.interactor?.getPokemons(0)
            self.collectionView.es.stopPullToRefresh()
        }
        collectionView.es.addInfiniteScrolling {
            self.interactor?.getPokemons(self.pokemons.count)
            self.collectionView.es.stopLoadingMore()
        }
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
        collectionView.reloadData()
    }
}

extension DashboardController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokemonCollectionCell", for: indexPath) as! PokemonCollectionCell
        cell.setPokemon(pokemons[indexPath.item])
        return cell
    }
}

extension DashboardController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = (collectionViewLayout as! UICollectionViewFlowLayout)
        let paddingSpace = (2 - 1) * layout.minimumInteritemSpacing
        let inset = layout.sectionInset.left + layout.sectionInset.right
        let availableWidth = collectionView.bounds.width - paddingSpace - inset
        let widthPerItem = availableWidth / 2
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

extension DashboardController: UIColorPickerViewControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
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
