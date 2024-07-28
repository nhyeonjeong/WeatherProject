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
        let outputCityWeather: Driver<NewCityWeatherModel?>
        let outputBottomCollectionViewItems: Driver<[MainBottomCollectionViewSectionData]?>
        let outputTimeForcastCollectionViewItems: Driver<[TimeForcastItem]?>
        let outputDayForcastTableViewItems: Driver<[DayForcastItem]?>
        let outputMapLocation: Driver<City?>
        let outputErrorMessage: Driver<String>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let outputCityWeather: PublishRelay<NewCityWeatherModel?> = PublishRelay()
        let outputBottomCollectionViewItems: PublishRelay<[MainBottomCollectionViewSectionData]?> = PublishRelay()
        let outputTimeForcastCollectionViewItems: PublishRelay<[TimeForcastItem]?> = PublishRelay()
        let outputDayForcastTableViewItems: PublishRelay<[DayForcastItem]?> = PublishRelay()
        let outputMapLocation: PublishRelay<City?> = PublishRelay()
        let outputErrorMessage: PublishRelay<String> = PublishRelay()
        
        // 도시 API통신(cnt = 7)
        input.inputFetchCityWeatherTrigger
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .flatMap { cityData in
                print("🍕network")
                return NetworkManager.shared.fetchAPI(type: CityWeatherModel.self, router: WeatherAPIRequest.currentWeather(lat: cityData.coord.lat, lon: cityData.coord.lon))
                    .catch { error in
                        guard let error = error as? WeatherAPIError else {
                            return Observable.empty()
                        }
                        outputCityWeather.accept(nil)
                        outputBottomCollectionViewItems.accept(nil)
                        outputMapLocation.accept(nil)
                        if error == .overLimit {
                            outputErrorMessage.accept("통신 횟수를 초과했습니다")
                        }
                        return Observable.never()
                    }
            }
            .bind(with: self) { owner, weather in
                // 상단 UI 업데이트
                outputCityWeather.accept(weather.newWeatherList)
                // 습도, 구름, 바람 UI 업데이트
                outputBottomCollectionViewItems.accept(weather.averageList)
                // 지도 annotation표시
                outputMapLocation.accept(weather.city)
            }.disposed(by: disposeBag)
        
        input.inputFetchTimeForcastTrigger
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .flatMap { cityData in
                print("🍕network")
                return NetworkManager.shared.fetchAPI(type: CityWeatherModel.self, router: WeatherAPIRequest.currentWeather(lat: cityData.coord.lat, lon: cityData.coord.lon, cnt: 40))
                    .catch { error in
                        guard let error = error as? WeatherAPIError else {
                            return Observable.empty()
                        }
                        outputTimeForcastCollectionViewItems.accept(nil)
                        outputDayForcastTableViewItems.accept(nil)
                        if error == .overLimit {
                            outputErrorMessage.accept("통신 횟수를 초과했습니다")
                        }
                        return Observable.never()
                    }
            }
            .bind(with: self) { owner, weather in
                // 3시간마다의 일기예보
                let twoDaysForcastItems = Array(weather.timeForcastItems[0...15])
                outputTimeForcastCollectionViewItems.accept(twoDaysForcastItems)
                // 5일간의 일기예보
                outputDayForcastTableViewItems.accept(weather.fiveDayForcastItems)
            }.disposed(by: disposeBag)
        
        
        return Output(outputCityWeather: outputCityWeather.asDriver(onErrorJustReturn: nil),
                      outputBottomCollectionViewItems: outputBottomCollectionViewItems.asDriver(onErrorJustReturn: nil),
                      outputTimeForcastCollectionViewItems: outputTimeForcastCollectionViewItems.asDriver(onErrorJustReturn: nil),
                      outputDayForcastTableViewItems: outputDayForcastTableViewItems.asDriver(onErrorJustReturn: nil),
                      outputMapLocation: outputMapLocation.asDriver(onErrorJustReturn: nil),
                      outputErrorMessage: outputErrorMessage.asDriver(onErrorJustReturn: ""))
    }
}

