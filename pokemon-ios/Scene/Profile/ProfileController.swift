//
//  ProfileController.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import UIKit
import XLPagerTabStrip
import YPImagePicker

protocol ProfileDisplayLogic: class {
    func showProfile(user: Login.UseCase.Response)
    func showImageProfile(user: Login.UseCase.Response)
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
    
    private var profiles = ["first_name", "last_name", "email", "phone"]
    private var currentUser: Login.UseCase.Response?
    private var imagePicker: YPImagePicker = {
        var config = YPImagePickerConfiguration()
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = true
        config.showsPhotoFilters = true
        config.showsVideoTrimmer = false
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "Pokédex"
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.library, .photo]
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = true
        config.hidesBottomBar = false
        config.hidesCancelButton = false
        config.silentMode = true
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        config.maxCameraZoomFactor = 1.0
        config.library.options = nil
        config.library.onlySquare = false
        config.library.isSquareByDefault = true
        config.library.minWidthForItem = nil
        config.library.mediaType = YPlibraryMediaType.photo
        config.library.defaultMultipleSelection = false
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 4
        config.library.spacingBetweenItems = 1.0
        config.library.skipSelectionsGallery = false
        config.library.preselectedItems = nil
        config.library.preSelectItemOnMultipleSelection = true
        config.gallery.hidesRemoveButton = true
        return YPImagePicker(configuration: config)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        interactor?.getCurrentUserProfile()
    }
    
    private func setupUI() {
        detailContainerView.layer.borderColor = UIColor.lightGray.cgColor
        detailContainerView.layer.borderWidth = 1
        detailContainerView.layer.cornerRadius = 8
        profiles.forEach({ string in
            var subtitle: String = ""
            switch profiles.firstIndex(of: string) {
            case 0:
                subtitle = currentUser?.firstName ?? "-"
                break
            case 1:
                subtitle = currentUser?.lastName ?? "-"
                break
            case 2:
                subtitle = currentUser?.email ?? "-"
                break
            case 3:
                subtitle = currentUser?.phoneNumber ?? "-"
                break
            default:
                break
            }
            detailStackView.addArrangedSubview(ProfileDetailView(title: string.localized, subtitle: subtitle, border: string != profiles.last))
        })
        profileImageView.image = currentUser?.image == nil ? UIImage(systemName: "person.crop.circle.fill") : UIImage(data: (currentUser?.image!)!)
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
    }
    
    private func setupButton() {
        changeProfileButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        changeProfileButton.layer.cornerRadius = changeProfileButton.bounds.height / 2
        changeProfileButton.backgroundColor = .lightGray
        changeProfileButton.tintColor = .gray
        
        var config = UIButton.Configuration.filled()
        config.title = "logout".localized
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
        imagePicker.didFinishPicking { items, cancelled in
            if let photo = items.singlePhoto {
                self.interactor?.saveUserProfile(image: photo.image)
            }
            self.imagePicker.dismiss(animated: true)
        }
        present(imagePicker, animated: true)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        interactor?.logout()
        router?.routeToLogin()
    }
}

extension ProfileController: ProfileDisplayLogic {
    func showProfile(user: Login.UseCase.Response) {
        currentUser = user
        setupUI()
    }
    
    func showImageProfile(user: Login.UseCase.Response) {
        showLoading(message: "profile_changed".localized, isSuccess: true, delay: 2)
        currentUser = user
        profileImageView.image = currentUser?.image == nil ? UIImage(systemName: "person.crop.circle.fill") : UIImage(data: (currentUser?.image!)!)
    }
    
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
