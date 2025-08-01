//
//  LoginInteractor.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import Foundation
import RxSwift

protocol LoginBusinessLogic: class {
    func loginUser(email: String, password: String)
    func checkSession()
}

protocol LoginDataStore: class {

}

class LoginInteractor: LoginBusinessLogic, LoginDataStore {

  var presenter: LoginPresentationLogic?
  var worker: LoginWorker?
    let disposeBag = DisposeBag()

    func loginUser(email: String, password: String) {
        let request = Login.UseCase.Request(email: email, password: password)
        worker?.login(request: request).observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            UserDefaults.standard.set(response?.id, forKey: "current_user_id")
            self.presenter?.didSuccess(response)
        }) { error in
            self.presenter?.didFail(error)
        }.disposed(by: disposeBag)
    }
    
    func checkSession() {
        guard let objectIdString = UserDefaults.standard.string(forKey: "current_user_id") else { return }
        presenter?.didLoggedIn()
    }
}
