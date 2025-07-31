//
//  LoginWorker.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import Foundation
import RxSwift

final class LoginWorker {
    private let repository = UserRepository()

    func login(request: Login.UseCase.Request) -> Observable<Login.UseCase.Response?> {
        repository.loginUser(request: request)
    }
}
