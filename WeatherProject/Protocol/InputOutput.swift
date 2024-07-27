//
//  InputOutput.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import Foundation
import RxSwift
import RxCocoa

protocol InputOutput {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get }
    
    func transform(input: Input) -> Output
}
