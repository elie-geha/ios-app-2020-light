//
//  MetroListViewController.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 22.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

class MetroListViewController: UIViewController {
    // MARK: - Properties

    var metrosAndPlaces: [MetroStation: [Place]] = [:] {
        didSet {
            sortedMetroStations = metrosAndPlaces
                .keys
                .map { $0 }
                .sorted(by: { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending })

            if isViewLoaded {
                tableView.reloadData()
            }
        }
    }

    var onOpenPlaces: ((MetroStation, [Place]) -> Void)?

    // MARK: - Outlets

    @IBOutlet var tableView: UITableView!

    // MARK: - Private properties

    private var sortedMetroStations: [MetroStation] = []

    // MARK: - Lifecycle
}

extension MetroListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sortedMetroStations.indices.contains(indexPath.row),
            let places = metrosAndPlaces[sortedMetroStations[indexPath.row]] {
            onOpenPlaces?(sortedMetroStations[indexPath.row], places)
        }
    }
}

extension MetroListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return metrosAndPlaces.keys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MetroListCell.reuseID) as! MetroListCell

        if sortedMetroStations.indices.contains(indexPath.row) {
            cell.configure(with: sortedMetroStations[indexPath.row])
        }

        return cell
    }
}
