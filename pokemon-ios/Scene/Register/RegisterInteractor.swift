//
//  RegisterInteractor.swift
//  pokemon-ios
//
//  Created by syndromme on 30/07/25.
//

import Foundation
import RxSwift

protocol RegisterBusinessLogic: class {
    func registerUser(firstName: String, lastName: String, email: String, phoneNumber: String, password: String)
}

protocol RegisterDataStore: class {

}

class RegisterInteractor: RegisterBusinessLogic, RegisterDataStore {

  var presenter: RegisterPresentationLogic?
  var worker: RegisterWorker?
    let disposeBag = DisposeBag()

    func registerUser(firstName: String, lastName: String, email: String, phoneNumber: String, password: String) {
        let request = Register.UseCase.Request(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, password: try! PasswordHasher.hash(password))
        
        worker?.register(request: request).observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            self.presenter?.didSuccess()
        }) { error in
            self.presenter?.didFail(error)
        }.disposed(by: disposeBag)
    }
}
