//
//  ChangeCityViewController.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 25.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

class ChangeCityViewController: UIViewController {
    @IBOutlet weak var btnConfirmOutlet: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!

    private var countries = [Country]()
    private var selectedCountry: Country?
    private var selectedCity: City?

    // display leftBarItem if its called from left menu side
    var isFromLeftMenu = false

    var onConfirm: ((Country, City) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self

        setupBackButton()

        btnConfirmOutlet.setTitle("Confirm".localized, for: .normal)
        updateCityLabel()

    }

    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        isFromLeftMenu = false
    }

    @IBAction func btnConfirmTapped(_ sender: UIButton) {
//		if IronSource.hasOfferwall() {
//			IronSource.showOfferwall(with: self)
//		}else {
			confirmLocation()
//		}
		/*
        guard let selectedCountry = selectedCountry, let selectedCity = selectedCity else {
            let alert = UIAlertController(title: "Alert".localized,
                                          message:"Please select country and city".localized,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))

            self.present(alert, animated: true, completion: nil)

            return
        }

        onConfirm?(selectedCountry, selectedCity)
*/
    }

	private func confirmLocation() {
		guard let selectedCountry = selectedCountry, let selectedCity = selectedCity else {
			let alert = UIAlertController(title: "Alert".localized,
										  message:"Please select country and city".localized,
										  preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))

			self.present(alert, animated: true, completion: nil)

			return
		}

		onConfirm?(selectedCountry, selectedCity)
	}

    func set(countries: [Country], selectedCountry: Country?, selectedCity: City?) {
        self.countries = countries
        self.selectedCountry = selectedCountry
        self.selectedCity = selectedCity

        if isViewLoaded {
            updateView()
        }
    }

    private func setupBackButton()  {
        if !isFromLeftMenu {
            self.navigationItem.leftBarButtonItem = nil
        }
    }

    private func updateView() {
        setDefaultLocationIfNeeded()
        updatePicker()
        updateCityLabel()
    }

    func setDefaultLocationIfNeeded()  {
        guard selectedCity == nil, selectedCountry == nil else { return }

        selectedCountry = countries[optional: 0]
        selectedCity = countries[optional: 0]?.cities[optional: 0]
    }

    private func updatePicker() {
        guard let countryIndex = countries.firstIndex(where: { $0 == selectedCountry }),
            let cityIndex = countries[countryIndex].cities.firstIndex(where: { $0 == selectedCity }) else {
                return
        }

        pickerView.selectRow(countryIndex, inComponent: 0, animated: false)
        pickerView.reloadComponent(1)
        pickerView.selectRow(cityIndex, inComponent: 1, animated: false)
    }

    private func updateCityLabel() {
        if let city = selectedCity {
            title = "City".localized + ": \(city.name)"
        } else {
            title = "Select Country And City".localized
        }
    }
}

extension ChangeCityViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCountryIndex = pickerView.selectedRow(inComponent: 0)
        let selectedCityIndex = pickerView.selectedRow(inComponent: 1)

        switch component {
        case 0:
            selectedCountry = countries[optional: selectedCountryIndex]
            selectedCity = countries[optional: selectedCountryIndex]?.cities[optional: 0]
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: false)
        case 1:
            selectedCity = countries[optional: selectedCountryIndex]?.cities[optional: selectedCityIndex]
        default: break
        }

        updateCityLabel()
    }
}

extension ChangeCityViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return countries.count
        } else {
            if let selectedCountryIndex = countries.firstIndex(where: { $0 == selectedCountry }) {
                return countries[selectedCountryIndex].cities.count
            } else {
                return 0
            }
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return countries[row].name
        } else {
            let selectedCountry = pickerView.selectedRow(inComponent: 0)
            let country = countries[optional: selectedCountry]
            let city = country?.cities[optional: row]

            return city?.name
        }
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var titleData = String()
        var  attributedString = NSAttributedString()

        if component == 0 {
            titleData = countries[row].name

            attributedString = NSAttributedString(string: titleData,
                                                  attributes: [.font: UIFont(name: "Georgia", size: 15.0)!])
        } else {
            let selectedCountry = pickerView.selectedRow(inComponent: 0)

            if let tData = countries[selectedCountry].cities[optional: row]?.name {
                titleData = tData
            }

            attributedString = NSAttributedString(string: titleData,
                                                  attributes: [.font: UIFont(name: "Futura", size: 5.0)!])
        }
        
        return attributedString
    }
}


//check if is index in range or out of range
extension Collection {
    subscript(optional i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }

}
