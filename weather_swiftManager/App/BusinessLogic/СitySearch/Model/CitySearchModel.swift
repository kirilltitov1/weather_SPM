//
//  CitySearchModel.swift
//  weather
//
//  Created by Kirill Titov on 14.11.2020.
//

import Alamofire

import RxSwift
import RxCocoa

class CityWeatherReport: Codable {
	let cod: String
	let list: [List]
	let city: Сity
	
	class List: Codable {
		let dt: Int
		let main: Main
		let weather: [Weather]
		
		class Main: Codable {
			let humidity: Int
			let pressure: Int
			let temp: Double
			let feels_like: Double
		}
		class Weather: Codable {
			let icon: String
		}
	}
	class Сity: Codable {
		let name: String
		let country: String
	}
}
