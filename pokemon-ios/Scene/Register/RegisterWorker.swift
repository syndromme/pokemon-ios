//
//  RegisterWorker.swift
//  pokemon-ios
//
//  Created by syndromme on 30/07/25.
//

import Foundation
import RxSwift

final class RegisterWorker {
    private let repository = UserRepository()
    
    func register(request: Register.UseCase.Request) -> Observable<Bool> {
        repository.registerUser(request: request)
    }
}
