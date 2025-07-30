//
//  DetailController.swift
//  pokemon-ios
//
//  Created by syndromme on 29/07/25.
//

import UIKit
import Kingfisher

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
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var statLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var typesStackView: UIStackView!
    @IBOutlet weak var abilityStackView: UIStackView!
    @IBOutlet weak var weightButton: UIButton!
    @IBOutlet weak var heightButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var statStackView: UIStackView!
    
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
        
        topView.backgroundColor = pokemon?.types?.first?.color
        aboutLabel.textColor = pokemon?.types?.first?.color
        statLabel.textColor = pokemon?.types?.first?.color
        previewImage.kf.setImage(with: URL(string: String(format: artworkURL, pokemon?.id ?? 0)))
        pokemon?.types?.forEach({ type in
            typesStackView.addArrangedSubview(CapsuleButton(title: type.type.name.capitalized, backgroundColor: type.color))
        })
        weightButton.setTitle(String(format: "%.1f kg", Float(pokemon?.weight ?? 0)/10), for: .normal)
        heightButton.setTitle(String(format: "%.1f m", Float(pokemon?.height ?? 0)/10), for: .normal)
        pokemon?.abilities?.forEach({ ability in
            let label = UILabel()
            label.text = ability.ability.name.capitalized
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.textAlignment = .center
            label.numberOfLines = 0
            abilityStackView.addArrangedSubview(label)
        })
        let label = UILabel()
        label.text = "Ability"
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textAlignment = .center
        abilityStackView.addArrangedSubview(label)
        
        pokemon?.stats?.forEach({ stat in
            statStackView.addArrangedSubview(StatView(stat: stat, color: pokemon?.types?.first?.color ?? UIColor.gray))
        })
    }
}
