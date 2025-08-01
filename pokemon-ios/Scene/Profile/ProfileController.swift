//
//  ProfileController.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import UIKit
import XLPagerTabStrip

protocol ProfileDisplayLogic: class {
    func showError(_ message: String)
}

final class ProfileController: UIViewController {

  var interactor: ProfileBusinessLogic?
  var router: (ProfileRoutingLogic & ProfileDataPassing)?

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
    let interactor = ProfileInteractor()
    let presenter = ProfilePresenter()
    let worker = ProfileWorker()
    let router = ProfileRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var changeProfileButton: UIButton!
    @IBOutlet weak var detailContainerView: UIView!
    @IBOutlet weak var detailStackView: UIStackView!
    @IBOutlet weak var logoutButton: UIButton!
    
    private var profiles = ["First Name", "Last Name", "Email", "Phone Number"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButton()
    }
    
    private func setupUI() {
        detailContainerView.layer.borderColor = UIColor.lightGray.cgColor
        detailContainerView.layer.borderWidth = 1
        detailContainerView.layer.cornerRadius = 8
        profiles.forEach({ string in
            detailStackView.addArrangedSubview(ProfileDetailView(title: string, border: string != profiles.last))
        })
        profileImageView.image = UIImage(systemName: "person.crop.circle.fill")
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
    }
    
    private func setupButton() {
        changeProfileButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        changeProfileButton.layer.cornerRadius = changeProfileButton.bounds.height / 2
        changeProfileButton.backgroundColor = .lightGray
        changeProfileButton.tintColor = .gray
        
        var config = UIButton.Configuration.filled()
        config.title = "Logout"
        config.cornerStyle = .medium
        config.baseBackgroundColor = .red
        config.baseForegroundColor = .white
        config.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var updated = attributes
            updated.font = .system(size: 16, weight: .bold)
            return updated
        }
        logoutButton.configuration = config
    }
    
    @IBAction func changeProfileAction(_ sender: Any) {
        
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        router?.routeToLogin()
    }
}

extension ProfileController: ProfileDisplayLogic {
    func showError(_ message: String) {
        hideLoading()
        showLoading(message: message, isSuccess: false, delay: 2)
    }
}

extension ProfileController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(image:UIImage(systemName: "figure"))
    }
}
