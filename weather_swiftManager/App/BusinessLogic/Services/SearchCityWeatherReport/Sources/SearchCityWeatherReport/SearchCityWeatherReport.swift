//
//  SearchCityWeatherReport.swift
//  weather
//
//  Created by Kirill Titov on 15.11.2020.
//

import Foundation
import Alamofire
import RxSwift
import ErrorHandler
import MementoNSCache

public protocol FetchWeatherReportProtocol {
	var errorParser: SearchCityErrorParser { get }
	func fetchCityWeatherReport(strCityName city: String) -> Single<Codable & AnyObject>
}

//let cacher = ResponseCacher(behavior: .cache)
//https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md#cachedresponsehandler
//URLCache
public class CityWeatherReportService<T: Codable & AnyObject> {
    private let responseCache = NSCache<NSString, AnyObject>()
	
	private let weathermapPathString = "http://api.openweathermap.org/data/2.5/forecast"
	private let appID = "ab77220aa6b309a18c2836899513f35e"
	
	public let errorParser: SearchCityErrorParser

	public init(errorParser: SearchCityErrorParser) {
		self.errorParser = errorParser
	}
	
	public func fetchCityWeatherReport(strCityName city: String) -> Single<T> {
		let url = weathermapPathString
		let parameters: [String : String] = ["q" : city,
											 "appid" : appID,
											 "mode" : "JSON",
											 "units" : "metric"]

		return Single<T>.create { [weak self] single in
			
			// response from cache
            if let responseFromCache = self?.responseCache.object(forKey: city as NSString ) as? T {
				single(.success(responseFromCache))
			} else {
				AF.request(url, method: .get, parameters: parameters)
					.responseDecodable(of: T.self) { response in
						switch response.result {
						case let .success(success):
							// response into cache
							DispatchQueue.main.async {
                                self?.responseCache.setObject(success, forKey: city as NSString)
								single(.success(success))
							}
						case let .failure(error):
							self?.errorParser.parser(searchCityError: error)
						}
					}
			}
			return Disposables.create()
		}
	}
}

