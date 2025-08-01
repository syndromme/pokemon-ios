//
//  ReachabilityManager.swift
//  pokemon-ios
//
//  Created by syndromme on 01/08/25.
//

import Reachability
import RxSwift
import RxRelay

final class ReachabilityService {

    static let shared = ReachabilityService()
    private let reachability = try! Reachability()

    private let connectionRelay = BehaviorRelay<Bool>(value: true)
    var isConnected: Observable<Bool> {
        return connectionRelay.asObservable().distinctUntilChanged()
    }

    private init() {
        reachability.whenReachable = { [weak self] _ in
            self?.connectionRelay.accept(true)
        }
        reachability.whenUnreachable = { [weak self] _ in
            self?.connectionRelay.accept(false)
        }

        try? reachability.startNotifier()
    }

    func currentStatus() -> Bool {
        return connectionRelay.value//reachability.connection != .unavailable
    }
}
