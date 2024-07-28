//
//  NetworkManager.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import Alamofire
import Foundation
import RxSwift

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() { }
    
    func fetchAPI<T: Decodable>(type: T.Type, router: RouterType) -> Observable<T> {
        
        return Observable<T>.create { observer in
            
            var urlRequest: URLRequest
            do {
                urlRequest = try router.asURLRequest()
            } catch {
                observer.onError(WeatherAPIError.invalidURLRequest)
                return Disposables.create()
            }

            AF.request(urlRequest, interceptor: APIRequestInterceptor()).validate(statusCode: 200..<201)
                .responseDecodable(of: T.self) { response in
                    
                    switch response.result {
                        
                    case .success(let success):
                        observer.onNext(success)
                        observer.onCompleted()
                        return
                        
                    case .failure(let failure):
                        if let afError = failure.asAFError, case .requestRetryFailed(let retryError, _) = afError {
                            if let error = retryError as? WeatherAPIError, error == .overLimit {
                                observer.onError(error)
                            } else {
        //                        print("🐈‍⬛ failure: \(failure)")
                                let statusCode = response.response?.statusCode
                                observer.onError(WeatherAPIError.statusCodeChangeToError(statusCode: statusCode))
                            }
                        }
                        return
                    }
                }
            
            return Disposables.create()
        }
    }
}

class APIRequestInterceptor: RequestInterceptor {
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let status = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        if WeatherAPIError.statusCodeChangeToError(statusCode: status) == .overLimit {
            completion(.retry)
        } else {
            completion(.doNotRetryWithError(WeatherAPIError.overLimit))
        }
    }
}
