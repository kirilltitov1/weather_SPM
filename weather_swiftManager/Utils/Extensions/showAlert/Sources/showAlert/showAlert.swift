//
//  showAllert.swift
//  weather
//
//  Created by Kirill Titov on 19.11.2020.
//

import UIKit

public protocol showAlert {}

public extension showAlert {
	func showAlert(message: String?) {
		let alertC = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
		alertC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

		UIApplication.shared.windows.filter { $0.isKeyWindow }
			.first?
			.rootViewController?
			.present(alertC, animated: true, completion: nil)
	}
}
