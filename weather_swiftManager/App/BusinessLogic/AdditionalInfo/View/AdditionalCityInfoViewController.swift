//
//  AdditionalCityInfoViewController.swift
//  weather
//
//  Created by Kirill Titov on 13.11.2020.
//

import UIKit
import RxSwift
import RxCocoa

final class AdditionalCityInfoViewController: UIViewController {
	
	let CITY_CELL_IDENTIFIER = "AdditionalCityInfo"

	var viewModel: AdditionalCityInfoViewModel!
	var weatherReport: CityWeatherReport!
	
	let disposeBag = DisposeBag()
	
	@IBOutlet weak var tableView: UITableView!
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.setupNavBar()
	}
	
	override func viewWillLayoutSubviews() {
		self.navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.delegate = self
		tableView.dataSource = self
		
		self.regCell()
		self.setUpBindings()
    }
	
	private func setupNavBar() {
		self.navigationItem
			.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: nil)
	}
	
	private func setUpBindings() {
		let input = AdditionalCityInfoViewModel.Input(city: self.weatherReport.city.name)
		let output = viewModel.transform(input: input)
		output.weatherForCurrentCity.debug("🏙➕")
			.subscribeOn(MainScheduler.instance)
			.subscribe { [weak self] respose in
				guard let self = self else { return }
				self.weatherReport = respose.element
				self.title = self.weatherReport.city.country + " " + self.weatherReport.city.name
				self.tableView.reloadData()
			}.disposed(by: disposeBag)
	}
}

extension AdditionalCityInfoViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return weatherReport.list.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CITY_CELL_IDENTIFIER, for: indexPath) as? AdditionalCityInfoTableViewCell else {
			let cell = AdditionalCityInfoTableViewCell()
			return cell
		}
		cell.setup(currentWeather: weatherReport.list[indexPath.row])
		return cell
	}
	private func regCell() {
		let nib = UINib.init(nibName: "AdditionalCityInfoTableViewCell", bundle: nil)
		self.tableView.register(nib, forCellReuseIdentifier: CITY_CELL_IDENTIFIER)
		self.tableView.rowHeight = 100
	}
}
