//
//  AdditionalCityInfoCoordinator.swift
//  weather
//
//  Created by Kirill Titov on 13.11.2020.
//

import UIKit
import RxSwift

final class AdditionalCityInfoCoordinator: BaseCoordinator {
	private let weatherReport: CityWeatherReport!
	private let disposeBag = DisposeBag()
	
	init(weatherReport: CityWeatherReport) {
		self.weatherReport = weatherReport
	}
	
	override func start() {
		let viewController = UIStoryboard.init(name: "AdditionalCityInfo", bundle: nil).instantiateInitialViewController()
		guard let additionalCityInfoViewController = viewController as? AdditionalCityInfoViewController else { return }
		
		// Coordinator initializes and injects viewModel
		let viewModel = AdditionalCityInfoViewModel(weatherReport: weatherReport)
		additionalCityInfoViewController.viewModel = viewModel
		additionalCityInfoViewController.weatherReport = weatherReport
		
		// Coordinator subscribes to events and notifies parentCoordinator
		additionalCityInfoViewController
			.navigationItem
			.leftBarButtonItem?
			.rx.tap.debug("🧭")
			.subscribe(onNext: { [weak self] item in
				self?.backDidPressed()
			}).disposed(by: disposeBag)
		
		self.navigationController.viewControllers.append(additionalCityInfoViewController)
	}
}

protocol BackListener {
	func backDidPressed()
}
extension AdditionalCityInfoCoordinator: BackListener {
	@objc func backDidPressed() {
		self.parentCoordinator?.didFinish(coordinator: self)
		self.navigationController.popViewController(animated: true)
	}
}
