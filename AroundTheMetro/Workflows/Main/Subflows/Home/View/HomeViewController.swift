//
//  HomeViewController.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit

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
    var logout: (() -> Void)?

    // MARK: - Private Properties

    // MARK: - Actions

    @IBAction func leftBarButtonAction() {
        onLeftBarButton?()
    }

    @IBAction func rightBarButtonAction() {
        onRightBarButton?()
    }

//    @IBAction func actLogout() {
//		showConfirmationAlert()
//    }

//	private func showConfirmationAlert() {
//		let okay = UIAlertAction(title: "Okay", style: .default) { [weak self] (_) in
//			do {
//				try Auth.auth().signOut()
//				self?.navigationItem.rightBarButtonItems = []
//				NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: Constants.LOGIN_UPDATED)))
//			}catch {
//
//			}
//		}
//		let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//		let alert = UIAlertController(title: "Do you want to logout of app?", message: "", preferredStyle: .alert)
//		alert.addAction(okay)
//		alert.addAction(cancel)
//		self.present(alert, animated: true, completion: nil)
//	}

    // MARK: - Lifecycle

    override func viewDidLoad() {
        #warning("disabling share screen temporary")
//        navigationItem.rightBarButtonItem = nil

//		NotificationCenter.default.addObserver(self, selector: #selector(self.loginUpdated), name: Notification.Name(Constants.LOGIN_UPDATED), object: nil)
    }

//	@objc func loginUpdated() {
//		if Auth.auth().currentUser != nil {
//			let logout = UIBarButtonItem(image: UIImage(named: "logout")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(actLogout))
//			self.navigationItem.rightBarButtonItems = [logout]
//		}else {
//			self.navigationItem.rightBarButtonItems = []
//		}
//	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
//		loginUpdated()
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
