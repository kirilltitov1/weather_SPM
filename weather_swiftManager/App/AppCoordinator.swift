//
//  AppCoordinator.swift
//  weather
//
//  Created by Kirill Titov on 13.11.2020.
//

import RxSwift
import UIKit

final class AppCoordinator: BaseCoordinator {

	var window: UIWindow!

	override func start(window: UIWindow) {
		self.window = window

		self.window.rootViewController = self.navigationController
		self.window.makeKeyAndVisible()

		let coordinator = CitySearchCoordinator()
		coordinator.navigationController = self.navigationController

		self.start(coordinator: coordinator)
	}
}
