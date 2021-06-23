//
//  MenuViewController.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 21.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

public class MenuViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    var menuItems: [MainMenuItem] = [] {
        didSet {
            if isViewLoaded {
                tableView.reloadData()
            }
        }
    }

	var showSubscriptionScene: (() -> Void)?
	
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupView()
		NotificationCenter.default.addObserver(self, selector: #selector(self.subscriptionUpdated), name: Notification.Name(IAPManager.SUBSCRIPTION_UPDATED_NOTIFICATION), object: nil)
		subscriptionUpdated()
    }

	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
    //Mark: - SetupView
    func setupView()  {
        tableView.isOpaque = false
        tableView.backgroundView = nil
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.register(MainMenuCell.nib, forCellReuseIdentifier: MainMenuCell.reuseID)
    }

	@objc func subscriptionUpdated() {
		let type = menuItems.last?.type ?? .contactUs

		//remove subscription from menu item if user has subscribed
		if IAPManager.shared.isSubscribed && type == .subscription{
			menuItems.removeLast()
			tableView.reloadData()
		}
		//add subscription if user is not yet subscribed
		else if !IAPManager.shared.isSubscribed && type != .subscription {
			menuItems.append(MainMenuItem(type: .subscription, onSelect: { [weak self] in
				self?.showSubscriptionScene?()
			}))
		}
	}
}

extension MenuViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard menuItems.count > indexPath.row else { return }
        menuItems[indexPath.row].onSelect()
    }
}


extension MenuViewController: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        return menuItems.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: MainMenuCell.reuseID) as? MainMenuCell else {
            fatalError("Unable to dequeue cell")
        }

        if menuItems.count > indexPath.row {
            cell.textLabel?.text = menuItems[indexPath.row].type.title
            cell.imageView?.image = UIImage(named: menuItems[indexPath.row].type.iconName)
        }

        return cell
    }
}
