//
//  AdditionalCityInfoViewModel.swift
//  weather
//
//  Created by Kirill Titov on 13.11.2020.
//

import UIKit
import RxSwift
import RxCocoa

protocol AdditionalCityInfoViewModelProtocol {
	associatedtype Input
	associatedtype Output
	
	func transform(input: Input) -> Output
}

final class AdditionalCityInfoViewModel {
	private var weatherReport: CityWeatherReport
	
	let disposeBag = DisposeBag()
	
	init(weatherReport: CityWeatherReport) {
		self.weatherReport = weatherReport
	}
	
	public func transform(input: Input) -> Output {
		let weatherReport = BehaviorSubject<CityWeatherReport>(value: self.weatherReport)
		return Output(weatherForCurrentCity: weatherReport)
	}
}

extension AdditionalCityInfoViewModel: AdditionalCityInfoViewModelProtocol {
	struct Input {
		let city: String
	}
	struct Output {
		let weatherForCurrentCity: BehaviorSubject<CityWeatherReport>
	}
}
