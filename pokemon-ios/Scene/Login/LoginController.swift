//
//  LoginController.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import UIKit
import SkyFloatingLabelTextField

protocol LoginDisplayLogic: class {
    func showLoginSuccess(_ user: Login.UseCase.Response?)
    func showError(_ message: String)
}

final class LoginController: UIViewController {

  var interactor: LoginBusinessLogic?
  var router: (LoginRoutingLogic & LoginDataPassing)?

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
    let interactor = LoginInteractor()
    let presenter = LoginPresenter()
    let worker = LoginWorker()
    let router = LoginRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
    
    @IBOutlet weak var emailTextField: InputField!
    @IBOutlet weak var passwordTextField: InputField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    
    let secureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(handleToggleSecureTextEntry), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRegister()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.stackView.addArrangedSubview(secureButton)
    }
    
    private func setupUI() {
        emailTextField.textField.placeholder = "Your Email"
        emailTextField.textField.title = "Email"
        emailTextField.textField.keyboardType = .emailAddress
        emailTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.textField.placeholder = "Your Password"
        passwordTextField.textField.title = "Password"
        passwordTextField.textField.isSecureTextEntry = true
        passwordTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
        var config = UIButton.Configuration.filled()
        config.title = "Login"
        config.cornerStyle = .medium
        config.baseBackgroundColor = .grass
        config.baseForegroundColor = .white
        config.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var updated = attributes
            updated.font = .system(size: 16, weight: .bold)
            return updated
        }
        loginButton.configuration = config
    }
    
    private func setupRegister() {
        let fullText = "Don't have an account? Register."
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        let registerRange = (fullText as NSString).range(of: "Register")
        if registerRange.location != NSNotFound {
            attributedString.addAttribute(.link, value: "register", range: registerRange)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: registerRange)
        }
        loginLabel.attributedText = attributedString
        loginLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        loginLabel.addGestureRecognizer(tapGesture)
    }
    
    private func isValid() -> Bool {
        emailTextField.textField?.errorMessage = emailTextField.textField?.text?.isEmpty ?? true ? "Email is required" : nil
        passwordTextField.textField?.errorMessage = passwordTextField.textField?.text?.isEmpty ?? true ? "Password is required" : nil
        return emailTextField.textField.errorMessage == nil && passwordTextField.textField.errorMessage == nil
    }
    
    private func doLogin() {
        if isValid() == false { return }
        
        showLoading()
        interactor?.loginUser(email: emailTextField.textField.text ?? "",
                              password: passwordTextField.textField.text ?? "")
    }
    
    private func clearFields() {
        emailTextField.textField.text = ""
        passwordTextField.textField.text = ""
    }
    
    @IBAction func handleToggleSecureTextEntry(_ sender: Any) {
        secureButton.isSelected.toggle()
        passwordTextField.textField.isSecureTextEntry.toggle()
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        let textField: SkyFloatingLabelTextField? = sender as? SkyFloatingLabelTextField
        switch textField {
        case emailTextField.textField:
            textField?.errorMessage = !(textField?.text?.isEmail ?? true) ? "Invalid email format" : nil
        case passwordTextField.textField:
            if textField?.text?.count ?? 0 < 6 {
                textField?.errorMessage = "Password must be at least 6 characters long"
            } else {
                textField?.errorMessage = nil
            }
        default:
            textField?.errorMessage = nil
        }
    }
    
    @IBAction func handleTap(_ sender: Any) {
        guard let gesture = sender as? UITapGestureRecognizer else { return }
        gesture.handleTapLabel { string in
            switch string {
            case "register":
                self.router?.routeToRegister()
                break
            default:
                return
            }
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        doLogin()
    }
}

extension LoginController: LoginDisplayLogic {
    func showLoginSuccess(_ user: Login.UseCase.Response?) {
        hideLoading()
        showLoading(message: "Login Success!!!", delay: 2)
        clearFields()
    }
    
    func showError(_ message: String) {
        hideLoading()
        showLoading(message: message, delay: 2)
    }
}
