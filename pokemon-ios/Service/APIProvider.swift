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
    func request<T: Decodable>(_ target: APITarget) -> Observable<T>
}

class APIProvider: APIProviderProtocol {
    func request<T: Decodable>(_ target: APITarget) -> Observable<T> {
        
        var params: Parameters?
        var encode: ParameterEncoding = JSONEncoding.default
        
        switch target.task {
        case .requestParameters(let parameters, let encoding):
            params = parameters
            encode = encoding
            break
        default:
            break
        }
        
        return RxAlamofire.requestData(target.method,
                                       target.url,
                                       parameters: params,
                                       encoding: encode,
                                       headers: target.headers)
            .flatMap { response, data -> Observable<T> in
                let statusCode = response.statusCode

                switch statusCode {
                case 200..<300:
                    break
                case 404:
                    return .error(AppError.serverError(code: statusCode, message: "Not found"))
                default:
//                    if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
//                        return .error(AppError.serverError(code: statusCode, message: errorResponse.message))
//                    } else {
                        return .error(AppError.serverError(code: statusCode, message: "Unknown server error"))
//                    }
                }
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    return .just(decoded)
                } catch {
                    return .error(AppError.decodingError(error))
                }
            }
    }

    
}
