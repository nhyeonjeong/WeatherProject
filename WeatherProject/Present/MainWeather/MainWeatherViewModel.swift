//
//  MainWeatherViewModel.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import Foundation
import RxCocoa
import RxSwift

final class MainWeatherViewModel: InputOutput {
    
    struct Input {
        let inputFetchCityWeatherTrigger: PublishSubject<CityModel>
        let inputFetchTimeForcastTrigger: PublishSubject<CityModel>
    }
    struct Output {
        let outputCityWeather: Driver<CityWeatherModel?>
        let outputBottomCollectionViewItems: Driver<[MainBottomCollectionViewSectionData]?>
        let outputTimeForcastCollectionViewItems: Driver<[TimeForcastItem]?>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let outputCityWeather: PublishRelay<CityWeatherModel?> = PublishRelay()
        let outputBottomCollectionViewItems: PublishRelay<[MainBottomCollectionViewSectionData]?> = PublishRelay()
        let outputTimeForcastCollectionViewItems: PublishRelay<[TimeForcastItem]?> = PublishRelay()
        
        // 도시 API통신(cnt = 7)
        input.inputFetchCityWeatherTrigger
            .flatMap { cityData in
                return NetworkManager.shared.fetchAPI(type: CityWeatherModel.self, router: WeatherAPIRequest.currentWeather(lat: cityData.coord.lat, lon: cityData.coord.lon))
                    .catch { error in
                        return Observable.empty()
                    }
            }
            .bind(with: self) { owner, weather in
                // 상단 UI 업데이트
                outputCityWeather.accept(weather)
                // 습도, 구름, 바람 UI 업데이트
                outputBottomCollectionViewItems.accept(weather.averageList)
                
            }.disposed(by: disposeBag)
        
        input.inputFetchTimeForcastTrigger
            .flatMap { cityData in
                return NetworkManager.shared.fetchAPI(type: CityWeatherModel.self, router: WeatherAPIRequest.currentWeather(lat: cityData.coord.lat, lon: cityData.coord.lon, cnt: 16))
                    .catch { error in
                        return Observable.empty()
                    }
            }
            .bind(with: self) { owner, weather in
                // 3시간마다의 일기예보
                outputTimeForcastCollectionViewItems.accept(weather.timeForcastItems)
            }.disposed(by: disposeBag)
        
        
        return Output(outputCityWeather: outputCityWeather.asDriver(onErrorJustReturn: nil),
                      outputBottomCollectionViewItems: outputBottomCollectionViewItems.asDriver(onErrorJustReturn: nil),
                      outputTimeForcastCollectionViewItems: outputTimeForcastCollectionViewItems.asDriver(onErrorJustReturn: nil))
    }
}

