//
//  CitySearchView.swift
//  weather
//
//  Created by Kirill Titov on 13.11.2020.
//

import UIKit

class CitySearchView: UIView {

	@IBOutlet weak var additionalInfo: UIButton!{
		didSet {
			additionalInfo.translatesAutoresizingMaskIntoConstraints = false
			additionalInfo.backgroundColor = .white
		}
	}
	@IBOutlet weak var cityName: UILabel!{
		didSet {
			cityName.translatesAutoresizingMaskIntoConstraints = false
			cityName.backgroundColor = .white
		}
	}
	@IBOutlet weak var cityTemperature: UILabel!{
		didSet {
			cityTemperature.translatesAutoresizingMaskIntoConstraints = false
			cityTemperature.backgroundColor = .white
		}
	}
	@IBOutlet weak var weatherIcon: UIImageView!{
		didSet {
			weatherIcon.translatesAutoresizingMaskIntoConstraints = false
			weatherIcon.backgroundColor = .white
			weatherIcon.bounds.size = CGSize(width: 100, height: 100)
			weatherIcon.clipsToBounds = false
		}
	}
	@IBOutlet weak var searchBar: UISearchBar! {
		didSet {
			searchBar.translatesAutoresizingMaskIntoConstraints = false
			searchBar.backgroundColor = .white
			searchBar.barTintColor = .white
		}
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
}
