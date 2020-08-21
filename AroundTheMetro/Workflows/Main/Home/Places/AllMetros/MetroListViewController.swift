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
            if isViewLoaded {
                tableView.reloadData()
            }
        }
    }

    // MARK: - Outlets

    @IBOutlet var tableView: UITableView!

    // MARK: - Private properties

    // MARK: - Lifecycle
}

extension MetroListViewController: UITableViewDelegate {

}

extension MetroListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return metrosAndPlaces.keys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MetroListCell.reuseID) as! MetroListCell

        if metrosAndPlaces.keys.count > indexPath.row {
            cell.configure(with: Array(metrosAndPlaces.keys)[indexPath.row])
        }

        return cell
    }
}
