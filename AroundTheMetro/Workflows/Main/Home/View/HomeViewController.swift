//
//  HomeViewController.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
        }
    }

    var onLeftBarButton: (() -> Void)?
    var onRightBarButton: (() -> Void)?

    @IBAction func leftBarButtonAction() {
        onLeftBarButton?()
    }

    @IBAction func rightBarButtonAction() {
        onRightBarButton?()
    }
}

extension HomeViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = UIScreen.main.bounds.width
        let height = width / (1242.0/708.0)
        switch indexPath.section {
        case 0: return height
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
            let cell = tableView.dequeueReusableCell(withIdentifier: BannersCell.identifier)
                as! BannersCell
            cell.delegate = self
            cell.pageControl.numberOfPages = bannerimages.count
            cell.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
            cell.collectionView.reloadData()
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier)
                as! MenuCell
            cell.delegate = self
            return cell

        default:

            return UITableViewCell()
        }
    }
}
