//
//  UserCacheModel.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import RealmSwift

class UserCacheModel: Object {

    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var firstName: String = ""
    @Persisted var lastName: String = ""
    @Persisted var email: String = ""
    @Persisted var phoneNumber: String = ""
    @Persisted var password: String = ""
    @Persisted var imageData: Data?

    func toUser() -> Login.UseCase.Response {
        return .init(id: id.stringValue, firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, image: imageData)
    }
}
