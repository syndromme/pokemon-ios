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
    func saveUserProfile(image: UIImage)
}

protocol ProfileDataStore: class {

}

class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {

  var presenter: ProfilePresentationLogic?
  var worker: ProfileWorker?
    let disposeBag = DisposeBag()
    
    func saveUserProfile(image: UIImage) {
        let request = Profile.UseCase.Request(userID: 1, image: image.jpegData(compressionQuality: 0.8))
        worker?.saveProfile(request: request).observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
        }) { (error) in
            
        }.disposed(by: disposeBag)
    }
}
