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
        firstNameTextField.textField.placeholder = "Your First Name"
        firstNameTextField.textField.title = "First Name"
        firstNameTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastNameTextField.textField.placeholder = "Your Last Name"
        lastNameTextField.textField.title = "Last Name"
        lastNameTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.textField.placeholder = "Your Email"
        emailTextField.textField.title = "Email"
        emailTextField.textField.keyboardType = .emailAddress
        emailTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneTextField.textField.placeholder = "Your Phone Number"
        phoneTextField.textField.title = "Phone Number"
        phoneTextField.textField.keyboardType = .phonePad
        phoneTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.textField.placeholder = "Your Password"
        passwordTextField.textField.title = "Password"
        passwordTextField.textField.isSecureTextEntry = true
        passwordTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        confirmPasswordTextField.textField.placeholder = "Confirm Your Password"
        confirmPasswordTextField.textField.title = "Confirm Password"
        confirmPasswordTextField.textField.errorLabel.numberOfLines = 0
        confirmPasswordTextField.textField.isSecureTextEntry = true
        confirmPasswordTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
        var config = UIButton.Configuration.filled()
        config.title = "Register"
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
        let fullText = "By registering you agree to our Terms and Privacy Policy."
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
        let termRange = (fullText as NSString).range(of: "Terms")
        if termRange.location != NSNotFound {
            attributedString.addAttribute(.link, value: "terms", range: termRange)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: termRange)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: termRange)
        }
        let policyRange = (fullText as NSString).range(of: "Privacy Policy")
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
        let fullText = "Already have an account? Login."
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        let loginRange = (fullText as NSString).range(of: "Login")
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
        firstNameTextField.textField?.errorMessage = firstNameTextField.textField?.text?.isEmpty ?? true ? "First Name is required" : nil
        lastNameTextField.textField?.errorMessage = lastNameTextField.textField?.text?.isEmpty ?? true ? "Last Name is required" : nil
        emailTextField.textField?.errorMessage = emailTextField.textField?.text?.isEmpty ?? true ? "Email is required" : nil
        phoneTextField.textField?.errorMessage = phoneTextField.textField?.text?.isEmpty ?? true ? "Phone Number is required" : nil
        passwordTextField.textField?.errorMessage = passwordTextField.textField?.text?.isEmpty ?? true ? "Password is required" : nil
        confirmPasswordTextField.textField?.errorMessage = confirmPasswordTextField.textField?.text?.isEmpty ?? true ? "Confirm Password is required" : nil
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
            textField?.errorMessage = firstNameTextField.textField?.text?.isEmpty ?? true ? "First Name is required" : nil
        case lastNameTextField.textField:
            textField?.errorMessage = lastNameTextField.textField?.text?.isEmpty ?? true ? "Last Name is required" : nil
        case emailTextField.textField:
            if textField?.text?.isEmpty ?? true {
                textField?.errorMessage = "Email is required"
            } else if !(textField?.text?.isEmail ?? true) {
                textField?.errorMessage = "Invalid email format"
            } else {
                textField?.errorMessage = nil
            }
        case phoneTextField.textField:
            if textField?.text?.isEmpty ?? true {
                textField?.errorMessage = "Phone Number is required"
            } else if !(textField?.text?.isPhone ?? true) {
                textField?.errorMessage = "Invalid phone format"
            } else {
                textField?.errorMessage = nil
            }
        case passwordTextField.textField:
            if textField?.text?.isEmpty ?? true {
                textField?.errorMessage = "Password is required"
            } else if textField?.text?.count ?? 0 < 6 {
                textField?.errorMessage = "Password must be at least 6 characters long"
            } else if !(textField?.text?.isValidPassword ?? false) {
                textField?.errorMessage = "Password at least one uppercase, one lowercase, one digit, one special character"
            } else {
                textField?.errorMessage = nil
            }
        case confirmPasswordTextField.textField:
            if textField?.text?.isEmpty ?? true {
                textField?.errorMessage = "Confirm Password is required"
            } else if textField?.text?.count ?? 0 < 6 {
                textField?.errorMessage = "Password must be at least 6 characters long"
            } else if textField?.text != passwordTextField.textField.text {
                textField?.errorMessage = "Passwords do not match"
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
