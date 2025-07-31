//
//  PasswordHasher.swift
//  pokemon-ios
//
//  Created by syndromme on 31/07/25.
//

import Sodium

struct PasswordHasher {
    
    static let sodium = Sodium()
    
    static func hash(_ password: String) -> String {
        return sodium.pwHash.str(passwd: password.bytes, opsLimit: sodium.pwHash.OpsLimitInteractive, memLimit: sodium.pwHash.MemLimitInteractive) ?? ""
    }
    
    static func verify(_ password: String, matches hash: String) -> Bool {
        return sodium.pwHash.strVerify(hash: hash, passwd: password.bytes)
    }
    
}
