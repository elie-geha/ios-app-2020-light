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

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    //Mark: - SetupView
    func setupView()  {
        tableView.isOpaque = false
        tableView.backgroundView = nil
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.register(MainMenuCell.nib, forCellReuseIdentifier: MainMenuCell.reuseID)
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
