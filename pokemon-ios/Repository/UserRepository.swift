//
//  UserRepository.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import RealmSwift
import RxSwift

class UserRepository {
    func registerUser(request: Register.UseCase.Request) -> Observable<Bool> {
        do {
            let realm = try Realm()
            let user = UserCacheModel()
            user.firstName = request.firstName
            user.lastName = request.lastName
            user.email = request.email
            user.phoneNumber = request.phoneNumber
            user.password = request.password
            try realm.write {
                realm.add(user, update: .modified)
            }
            
            return .just(true)
        } catch {
            print("❌ Failed to save cache: \(error)")
            return Observable.error(error)
        }
    }
    
    func loginUser(request: Login.UseCase.Request) -> Observable<Login.UseCase.Response?> {
        do {
            let realm = try Realm()
            if let user = realm.objects(UserCacheModel.self).filter("email == %@", request.email).first {
                if PasswordHasher.verify(request.password, matches: user.password) {
                    return .just(user.toUser())
                } else {
                    throw AppError.genericError(message: "Email or password is incorrect")
                }
            }
            return .just(nil)
        } catch {
            print("❌ Failed to login: \(error)")
            return Observable.error(error)
        }
    }
    
    func getCurrentUser(request: Profile.UseCase.Request) -> Observable<Login.UseCase.Response?> {
        do {
            return .just(try getCurrentUserByID(userID: request.userID)?.toUser())
        } catch {
            print("❌ Failed to save image: \(error)")
            return Observable.error(error)
        }
    }
    
    func setUserProfile(request: Profile.UseCase.Request) -> Observable<Login.UseCase.Response?> {
        do {
            if let user = try getCurrentUserByID(userID: request.userID) {
            let realm = try Realm()
                try realm.write {
                    user.imageData = request.image
                }
                return .just(user.toUser())
            }
            return .just(nil)
        } catch {
            print("❌ Failed to save image: \(error)")
            return Observable.error(error)
        }
    }
    
    private func getCurrentUserByID(userID: String) throws -> UserCacheModel? {
        do {
            let realm = try Realm()
            if let objectId = try? ObjectId(string: userID), let user = realm.object(ofType: UserCacheModel.self, forPrimaryKey: objectId) {
                return user
            }
            return nil
        } catch {
            print("❌ Failed to get user: \(error)")
            return nil
        }
    }
}
