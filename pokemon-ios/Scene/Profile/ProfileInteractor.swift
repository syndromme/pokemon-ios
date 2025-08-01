//
//  ProfileInteractor.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import UIKit
import Foundation
import RxSwift

protocol ProfileBusinessLogic: class {
    func getCurrentUserProfile()
    func saveUserProfile(image: UIImage)
    func logout()
}

protocol ProfileDataStore: class {

}

class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {

  var presenter: ProfilePresentationLogic?
  var worker: ProfileWorker?
    let disposeBag = DisposeBag()
    
    func getCurrentUserProfile() {
        guard let objectIdString = UserDefaults.standard.string(forKey: "current_user_id") else { return }
        let request = Profile.UseCase.Request(userID: objectIdString, image: nil)
        worker?.getProfile(request: request).observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            self.presenter?.didGetProfile(user: response!)
        }) { (error) in
            self.presenter?.didFail(error)
        }.disposed(by: disposeBag)
    }
    
    func saveUserProfile(image: UIImage) {
        guard let objectIdString = UserDefaults.standard.string(forKey: "current_user_id") else { return }
        let request = Profile.UseCase.Request(userID: objectIdString, image: image.jpegData(compressionQuality: 0.8))
        worker?.saveProfile(request: request).observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            self.presenter?.didChangeImage(user: response!)
        }) { (error) in
            self.presenter?.didFail(error)
        }.disposed(by: disposeBag)
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "current_user_id")
    }
}
