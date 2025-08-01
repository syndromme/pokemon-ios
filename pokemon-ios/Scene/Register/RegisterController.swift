//
//  RegisterController.swift
//  pokemon-ios
//
//  Created by syndromme on 30/07/25.
//

import UIKit
import SkyFloatingLabelTextField

protocol RegisterDisplayLogic: class {
    func showRegisterSuccess()
    func showError(_ message: String)
}

final class RegisterController: UIViewController {
    
    var interactor: RegisterBusinessLogic?
    var router: (RegisterRoutingLogic & RegisterDataPassing)?
    
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
        let interactor = RegisterInteractor()
        let presenter = RegisterPresenter()
        let worker = RegisterWorker()
        let router = RegisterRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    @IBOutlet weak var firstNameTextField: InputField!
    @IBOutlet weak var lastNameTextField: InputField!
    @IBOutlet weak var emailTextField: InputField!
    @IBOutlet weak var phoneTextField: InputField!
    @IBOutlet weak var passwordTextField: InputField!
    @IBOutlet weak var confirmPasswordTextField: InputField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var termLabel: UILabel!
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
        setupTermsAndConditions()
        setupLogin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.stackView.addArrangedSubview(secureButton)
    }
    
    private func setupUI() {
        firstNameTextField.textField.placeholder = "your_first_name".localized
        firstNameTextField.textField.title = "first_name".localized
        firstNameTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastNameTextField.textField.placeholder = "your_last_name".localized
        lastNameTextField.textField.title = "last_name".localized
        lastNameTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.textField.placeholder = "your_email".localized
        emailTextField.textField.title = "email".localized
        emailTextField.textField.keyboardType = .emailAddress
        emailTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneTextField.textField.placeholder = "your_phone".localized
        phoneTextField.textField.title = "phone".localized
        phoneTextField.textField.keyboardType = .phonePad
        phoneTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.textField.placeholder = "your_password".localized
        passwordTextField.textField.title = "password".localized
        passwordTextField.textField.isSecureTextEntry = true
        passwordTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        confirmPasswordTextField.textField.placeholder = "your_confirm_password".localized
        confirmPasswordTextField.textField.title = "confirm_password".localized
        confirmPasswordTextField.textField.errorLabel.numberOfLines = 0
        confirmPasswordTextField.textField.isSecureTextEntry = true
        confirmPasswordTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
        var config = UIButton.Configuration.filled()
        config.title = "register".localized
        config.cornerStyle = .medium
        config.baseBackgroundColor = .grass
        config.baseForegroundColor = .white
        config.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var updated = attributes
            updated.font = .system(size: 16, weight: .bold)
            return updated
        }
        registerButton.configuration = config
    }
    
    private func setupTermsAndConditions() {
        let fullText = "toc".localized
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
        let termRange = (fullText as NSString).range(of: "terms".localized)
        if termRange.location != NSNotFound {
            attributedString.addAttribute(.link, value: "terms", range: termRange)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: termRange)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: termRange)
        }
        let policyRange = (fullText as NSString).range(of: "policy".localized)
        if policyRange.location != NSNotFound {
            attributedString.addAttribute(.link, value: "policy", range: policyRange)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: policyRange)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: policyRange)
        }
        termLabel.attributedText = attributedString
        termLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        termLabel.addGestureRecognizer(tapGesture)
    }
    
    private func setupLogin() {
        let fullText = "have_account".localized
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        let loginRange = (fullText as NSString).range(of: "login".localized)
        if loginRange.location != NSNotFound {
            attributedString.addAttribute(.link, value: "login", range: loginRange)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: loginRange)
        }
        loginLabel.attributedText = attributedString
        loginLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        loginLabel.addGestureRecognizer(tapGesture)
    }
    
    private func isValid() -> Bool {
        firstNameTextField.textField?.errorMessage = firstNameTextField.textField?.text?.isEmpty ?? true ? "first_name_required".localized : nil
        lastNameTextField.textField?.errorMessage = lastNameTextField.textField?.text?.isEmpty ?? true ? "last_name_required".localized : nil
        emailTextField.textField?.errorMessage = emailTextField.textField?.text?.isEmpty ?? true ? "email_required".localized : nil
        phoneTextField.textField?.errorMessage = phoneTextField.textField?.text?.isEmpty ?? true ? "phone_required".localized : nil
        passwordTextField.textField?.errorMessage = passwordTextField.textField?.text?.isEmpty ?? true ? "password_required".localized : nil
        confirmPasswordTextField.textField?.errorMessage = confirmPasswordTextField.textField?.text?.isEmpty ?? true ? "confirm_password_required".localized : nil
        return firstNameTextField.textField.errorMessage == nil && lastNameTextField.textField.errorMessage == nil && emailTextField.textField.errorMessage == nil && phoneTextField.textField.errorMessage == nil && passwordTextField.textField.errorMessage == nil && confirmPasswordTextField.textField.errorMessage == nil
    }
    
    private func doRegister() {
        if isValid() == false { return }
        
        showLoading()
        interactor?.registerUser(firstName: firstNameTextField.textField.text ?? "",
                                 lastName: lastNameTextField.textField.text ?? "",
                                 email: emailTextField.textField.text ?? "",
                                 phoneNumber: phoneTextField.textField.text ?? "",
                                 password: passwordTextField.textField.text ?? "")
    }
    
    private func clearFields() {
        firstNameTextField.textField.text = ""
        lastNameTextField.textField.text = ""
        emailTextField.textField.text = ""
        phoneTextField.textField.text = ""
        passwordTextField.textField.text = ""
        confirmPasswordTextField.textField.text = ""
    }
    
    @IBAction func handleToggleSecureTextEntry(_ sender: Any) {
        secureButton.isSelected.toggle()
        passwordTextField.textField.isSecureTextEntry.toggle()
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        let textField: SkyFloatingLabelTextField? = sender as? SkyFloatingLabelTextField
        switch textField {
        case firstNameTextField.textField:
            textField?.errorMessage = firstNameTextField.textField?.text?.isEmpty ?? true ? "first_name_required".localized : nil
        case lastNameTextField.textField:
            textField?.errorMessage = lastNameTextField.textField?.text?.isEmpty ?? true ? "last_name_required".localized : nil
        case emailTextField.textField:
            if textField?.text?.isEmpty ?? true {
                textField?.errorMessage = "email_required".localized
            } else if !(textField?.text?.isEmail ?? true) {
                textField?.errorMessage = "email_invalid"
            } else {
                textField?.errorMessage = nil
            }
        case phoneTextField.textField:
            if textField?.text?.isEmpty ?? true {
                textField?.errorMessage = "phone_required".localized
            } else if !(textField?.text?.isPhone ?? true) {
                textField?.errorMessage = "phone_invalid".localized
            } else {
                textField?.errorMessage = nil
            }
        case passwordTextField.textField:
            if textField?.text?.isEmpty ?? true {
                textField?.errorMessage = "password_required".localized
            } else if textField?.text?.count ?? 0 < 6 {
                textField?.errorMessage = "password_invalid_length".localized
            } else if !(textField?.text?.isValidPassword ?? false) {
                textField?.errorMessage = "password_invalid".localized
            } else {
                textField?.errorMessage = nil
            }
        case confirmPasswordTextField.textField:
            if textField?.text?.isEmpty ?? true {
                textField?.errorMessage = "confirm_password_required".localized
            } else if textField?.text?.count ?? 0 < 6 {
                textField?.errorMessage = "confirm_password_invalid_length".localized
            } else if textField?.text != passwordTextField.textField.text {
                textField?.errorMessage = "confirm_password_invalid".localized
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
            case "terms":
                URL(string: "https://policies.google.com/terms?hl=id-ID")!.open()
                break
            case "policy":
                URL(string: "https://policies.google.com/privacy?hl=id-ID")!.open()
                break
            case "login":
                self.router?.routeToLogin()
                break
            default:
                return
            }
        }
    }
    
    @IBAction func registerAction(_ sender: Any) {
        doRegister()
    }
}

extension RegisterController: RegisterDisplayLogic {
    func showRegisterSuccess() {
        hideLoading()
        showLoading(message: "Register Success!!!", delay: 2)
        clearFields()
        router?.routeToLogin()
    }
    
    func showError(_ message: String) {
        hideLoading()
        showLoading(message: message, isSuccess: false, delay: 2)
    }
}
