//
//  ProfileWorker.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import Foundation
import RxSwift

final class ProfileWorker {
    private let repository = UserRepository()

    func saveProfile(request: Profile.UseCase.Request) -> Observable<Login.UseCase.Response?> {
        repository.setUserProfile(request: request)
    }
}
