//
//  RouterType.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import Alamofire
import Foundation

protocol RouterType: URLRequestConvertible {
    var baseURLString: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
}

extension RouterType {
    func asURLRequest() throws -> URLRequest {
        var urlComps = URLComponents(string: baseURLString)
        if let queryItems {
            urlComps?.queryItems = queryItems
        }
        do {
            guard let url = try urlComps?.asURL() else {
                return URLRequest(url: try baseURLString.asURL())
            }
            let urlRequest = try URLRequest(url: url, method: method)
            return urlRequest
        } catch {
            print(error)
            return URLRequest(url: try baseURLString.asURL())
        }
    }
}
