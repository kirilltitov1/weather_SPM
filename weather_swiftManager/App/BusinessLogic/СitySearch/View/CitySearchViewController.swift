//
//  CitySearchViewController.swift
//  weather
//
//  Created by Kirill Titov on 13.11.2020.
//

import UIKit
import RxSwift
import RxCocoa
import loadImageUsingUrlString

class CitySearchViewController: UIViewController,
								UISearchBarDelegate {
	
	var viewModel: CitySearchViewModel!
	var citySearchView: CitySearchView!
	private let disposeBag = DisposeBag()

	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.view = citySearchView

		self.citySearchView.searchBar.delegate = self
		self.setUpBindings()
    }
	private func setUpBindings() {
		let input = CitySearchViewModel.Input(
			cityName: citySearchView.searchBar.rx.text
				.orEmpty
				.distinctUntilChanged()
				.debounce(DispatchTimeInterval.milliseconds(500),
						  scheduler: MainScheduler.instance)
				.filter { !$0.isEmpty }
				.asObservable()
		)
		let output = viewModel.transform(input: input)
		output.cityName
			.bind(to: citySearchView.cityName.rx.text)
			.disposed(by: disposeBag)
		output.cityTemperature
			.bind(to: citySearchView.cityTemperature.rx.text)
			.disposed(by: disposeBag)
		
		output.weatherIcon.subscribe { [weak self] strImage in
			self?.citySearchView.weatherIcon
				.loadImageUsingUrlString(urlString: String(Constants.Path.weathermapIcon + strImage + ".png"))
		}.disposed(by: disposeBag)
		output.isButtonEnabled
			.bind(to: citySearchView.additionalInfo.rx.isEnabled)
			.disposed(by: disposeBag)
	}
}
