//
//  CitySearchCoordinator.swift
//  weather
//
//  Created by Kirill Titov on 13.11.2020.
//

import UIKit
import RxSwift
import RxCocoa

final class CitySearchCoordinator: BaseCoordinator {
	
	let disposeBag = DisposeBag()
	override func start() {
		let viewController = UIStoryboard.init(name: "CitySearch", bundle: nil).instantiateInitialViewController()
		guard let citySearchViewController = viewController as? CitySearchViewController else { return }
		
		// Coordinator initializes and injects view & viewModel
		let view = UINib(nibName: "CitySearchView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! CitySearchView
		let viewModel = CitySearchViewModel()

		citySearchViewController.citySearchView = view
		citySearchViewController.viewModel = viewModel
		
		// Coordinator subscribes to events and notifies parentCoordinator
		view.additionalInfo.rx.tap
			.subscribe { [weak self] _ in
				self?.goToAdditionalInfo(
					weatherReport: citySearchViewController.viewModel.weatherForCurrentCity
				)
			}.disposed(by: disposeBag)
		
		self.navigationController.setNavigationBarHidden(true, animated: false)
		self.navigationController.viewControllers = [citySearchViewController]
	}
}

protocol AdditioalCityInfoListener {
	func goToAdditionalInfo(weatherReport: CityWeatherReport)
}

extension CitySearchCoordinator: AdditioalCityInfoListener {
	func goToAdditionalInfo(weatherReport: CityWeatherReport) {
		let coordinator = AdditionalCityInfoCoordinator(weatherReport: weatherReport)
		coordinator.navigationController = self.navigationController
		self.start(coordinator: coordinator)
	}
}
