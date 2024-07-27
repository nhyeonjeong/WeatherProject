//
//  WeatherAPIError.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/28.
//

import Foundation

enum WeatherAPIError: Error {
    case invalidURLRequest
    case invalidAPIKey
    /// 잘못된 도시 이름, 우편 번호 또는 도시ID 지정시, API요청 방식이 올바르지 않는 경우
    case wrongRequest
    case overLimit
    /// 호출 반환 오류
    case returnError
    /// 또 다른 오류
    case otherError
    
    static func statusCodeChangeToError(statusCode: Int?) -> WeatherAPIError {
        switch statusCode {
        case 401: return .invalidAPIKey
        case 404: return .wrongRequest
        case 429: return .overLimit
        case 500, 502, 503, 504: return .returnError
        default: return .otherError
        }
    }
}
