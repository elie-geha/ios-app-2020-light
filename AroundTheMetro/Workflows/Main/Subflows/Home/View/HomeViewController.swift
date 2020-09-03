//
//  HomeViewController.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
        }
    }

    // MARK: - Properties

    var menuItems: [MenuItem] = []
    var banners: [Banner] = [] {
        didSet {
            if isViewLoaded {
                tableView.reloadData()
            }
        }
    }

    var onLeftBarButton: (() -> Void)?
    var onRightBarButton: (() -> Void)?

    // MARK: - Private Properties

    // MARK: - Actions

    @IBAction func leftBarButtonAction() {
        onLeftBarButton?()
    }

    @IBAction func rightBarButtonAction() {
        onRightBarButton?()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        #warning("disabling share screen temporary")
        navigationItem.rightBarButtonItem = nil
    }
}

extension HomeViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            let width = UIScreen.main.bounds.width
            let height = width * 0.57
            return min(240, height)
        case 1: return 450
        default: return 0
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: BannersCell.reuseID) as! BannersCell
            cell.banners = banners
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.reuseID) as! MenuCell
            cell.menuItems = menuItems
            return cell

        default:
            return UITableViewCell()
        }
    }
}
