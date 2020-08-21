//
//  PlacesViewController.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 21.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Tabman
import Pageboy
import UIKit

class PlacesViewController: TabmanViewController {
    // MARK: - Properties

    var metrosAndPlaces: [MetroStation: [Place]] = [:] {
        didSet {
            if isViewLoaded {
                reloadChildControllers()
            }
        }
    }

    // MARK: - Outlets

    @IBOutlet var containerView: UIView!
    @IBOutlet var tabSwitcher: UIView!

    // MARK: - Private properties

    private var allPlacesViewController: AllPlacesListViewController!
    private var metroViewController: MetroListViewController!

    private var barItems: [TMBarItem] = {
        return [TMBarItem(title: "ALL".localized), TMBarItem(title: "BY METRO".localized)]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupView()
    }

    // MARK: - Private

    private func setupViewControllers() {
        allPlacesViewController = Storyboard.Home.allPlacesListVC
        metroViewController = Storyboard.Home.metroListVC

        reloadChildControllers()
    }

    private func setupView() {
        self.dataSource = self

        let bar = TMBar.ButtonBar()

        bar.backgroundView.style = .flat(color: UIColor(red: 0.078125, green: 0.1796875, blue: 0.234375, alpha: 1.0))

        // layout
        bar.layout.contentInset = .zero
        bar.layout.interButtonSpacing = 0.0
        bar.layout.contentMode = .fit

        // indicator
        bar.indicator.tintColor = UIColor(red:0.25, green:0.765625, blue:1.0, alpha:1.0)
        bar.indicator.overscrollBehavior = .compress
        bar.indicator.weight = .heavy

        // buttons
        bar.buttons.customize { button in
            button.tintColor = .white
            button.selectedTintColor = .white
        }

        addBar(bar, dataSource: self, at: .top)
    }

    private func reloadChildControllers() {
        allPlacesViewController.places = metrosAndPlaces.flatMap { $0.value }
        metroViewController.metrosAndPlaces = metrosAndPlaces
    }
}

extension PlacesViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return barItems[index]
    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return 2
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        switch index {
        case 0: return allPlacesViewController
        case 1: return metroViewController
        default: return nil
        }
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
