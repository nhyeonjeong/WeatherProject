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
            /*
             AF.request(urlRequest)
             .responseString { response in
             print("⭐️responseString : \(response)")
             }
             */
            
            AF.request(urlRequest).validate(statusCode: 200..<201)
                .responseDecodable(of: T.self) { response in
                    
                    switch response.result {
                        
                    case .success(let success):
                        observer.onNext(success)
                        observer.onCompleted()
//                        print("🍕\(success)")
                        return
                        
                    case .failure(_):
//                        print("🐈‍⬛ failure: \(failure)")
                        let statusCode = response.response?.statusCode
                        observer.onError(WeatherAPIError.statusCodeChangeToError(statusCode: statusCode))
                        return
                    }
                }
            
            return Disposables.create()
        }
    }
}
