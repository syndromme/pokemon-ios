//
//  APIProvider.swift
//  pokemon-ios
//
//  Created by syndromme on 28/07/25.
//

import RxSwift
import Alamofire
import RxAlamofire

protocol APIProviderProtocol {
    func execute<T: Decodable>(_ target: APITarget, decodeTo type: T.Type) -> Observable<T>
    func executeArray<T: Decodable>(_ target: APITarget, decodeTo type: [T].Type) -> Observable<[T]>
}

class APIProvider: APIProviderProtocol {
    func execute<T: Decodable>(_ target: APITarget, decodeTo type: T.Type) -> Observable<T> {
        return requestData(for: target)
            .map { data in
                try JSONDecoder().decode(T.self, from: data)
            }
    }

    func executeArray<T: Decodable>(_ target: APITarget, decodeTo type: [T].Type) -> Observable<[T]> {
        return requestData(for: target)
            .map { data in
                try JSONDecoder().decode([T].self, from: data)
            }
    }

    private func requestData(for target: APITarget) -> Observable<Data> {
        let request: Observable<(HTTPURLResponse, Data)>

        switch target.task {
        case .requestPlain:
            request = RxAlamofire.requestData(target.method, target.url, headers: target.headers)

        case .requestParameters(let parameters, let encoding):
            request = RxAlamofire.requestData(target.method, target.url, parameters: parameters, encoding: encoding, headers: target.headers)
        }

        return request.map { (_, data) in data }
    }
}
