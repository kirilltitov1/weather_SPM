//
//  CitySearchViewModel.swift
//  weather
//
//  Created by Kirill Titov on 13.11.2020.
//

import RxSwift
import RxCocoa
import Alamofire
import ErrorHandler
import SearchCityWeatherReport

protocol CitySearchViewModelProtocol {
	associatedtype Input
	associatedtype Output
	
	func transform(input: Input) -> Output
}

final class CitySearchViewModel {
	private var disposeBag = DisposeBag()
	private let errorHandler: SearchCityErrorParser
	private let fetchWeatherReportService: CityWeatherReportService<CityWeatherReport> // не получилось передать через протокол  
	var weatherForCurrentCity: CityWeatherReport!
	
	init() {
		self.errorHandler = ErrorHandler()
		self.fetchWeatherReportService = CityWeatherReportService<CityWeatherReport>(errorParser: errorHandler)
	}
	public func transform(input: Input) -> Output {
		let cityName = BehaviorSubject<String>(value: "Input city")
		let cityTemperature = BehaviorSubject<String>(value: "")
		let weatherStrIcon = BehaviorSubject<String>(value: "")
		
		input.cityName.debug("🏙").flatMap {
			self.fetchWeatherReportService.fetchCityWeatherReport(strCityName: $0)
		}
		.debug("☂️")
		.observeOn(MainScheduler.instance)
		.subscribe { weatherReport in
			self.weatherForCurrentCity = weatherReport
			guard let current = weatherReport.list.first else { return }
			cityName.onNext(weatherReport.city.name)
			cityTemperature.onNext(String(Int(current.main.temp)))
			guard let weather = current.weather.first else { return }
			weatherStrIcon.onNext(weather.icon)
		} onError: { error in
			
		}.disposed(by: disposeBag)
		
		let isLoginButtonEnabled = Observable
			.combineLatest(
				cityName.asObserver(),
				cityTemperature.asObserver()
			)
			.map { ($0 != "..." && $0 != "Input city" ) && $1 != "..." }
			.startWith(false)
		
		return Output(
			cityName: cityName,
			cityTemperature: cityTemperature,
			weatherIcon: weatherStrIcon,
			isButtonEnabled: isLoginButtonEnabled
		)
	}
}

extension CitySearchViewModel: CitySearchViewModelProtocol {
	struct Input {
		let cityName: Observable<String>
	}
	
	struct Output {
		let cityName: BehaviorSubject<String>
		let cityTemperature: BehaviorSubject<String>
		let weatherIcon: BehaviorSubject<String>
		let isButtonEnabled: Observable<Bool>
	}
}
