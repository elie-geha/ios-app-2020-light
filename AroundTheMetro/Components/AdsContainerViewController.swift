//
//  AdsControllerContainer.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 24.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

class AdsContainerViewController: UIViewController {
    private var bannerHeight: NSLayoutConstraint!

    private var bannerViewContainer = UIView()
    private var contentContainer = UIView()

    var onResized: ((CGSize) -> Void)?

    var contentViewController: UIViewController? {
        didSet {
            contentContainer.subviews.forEach { $0.removeFromSuperview() }
            guard let contentViewController = contentViewController else { return }

            contentViewController.willMove(toParent: self)
            contentViewController.view.frame = contentContainer.bounds
            contentContainer.addSubview(contentViewController.view)
            contentViewController.view.topAnchor.constraint(equalTo: contentContainer.topAnchor).isActive = true
            contentViewController.view.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor).isActive = true
            contentViewController.view.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor).isActive = true
            contentViewController.view.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor).isActive = true
            self.addChild(contentViewController)
            contentViewController.didMove(toParent: self)
        }
    }

    override func viewDidLoad() {
        layoutViews()

		bannerViewContainer.isHidden = IAPManager.shared.isSubscribed

		NotificationCenter.default.addObserver(self, selector: #selector(self.subscriptionUpdated), name: Notification.Name(IAPManager.SUBSCRIPTION_UPDATED_NOTIFICATION), object: nil)
    }

	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
    override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		bannerViewContainer.isHidden = IAPManager.shared.isSubscribed
        self.onResized?(view.frame.size)

    }

    override func viewWillTransition(to size: CGSize,
                            with coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransition(to:size, with:coordinator)
      coordinator.animate(alongsideTransition: { _ in
        self.onResized?(size)
      })
    }

	@objc func subscriptionUpdated() {
		if IAPManager.shared.isSubscribed {
			hideBanner()
		}else {
			bannerViewContainer.isHidden = false
			self.onResized?(view.frame.size)
		}
	}
	
    private func setBannerHeight(_ bannerHeight: CGFloat) {
		self.bannerHeight.constant = self.bannerViewContainer.isHidden ? 0 : bannerHeight

        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    private func layoutViews() {
        bannerViewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerViewContainer)
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentContainer)

        contentContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        bannerViewContainer.topAnchor.constraint(equalTo: contentContainer.bottomAnchor).isActive = true
        bannerViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bannerViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bannerViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        bannerHeight = bannerViewContainer.heightAnchor.constraint(equalToConstant: 0)
        bannerHeight.isActive = true
    }
}

extension AdsContainerViewController: AdsContainer {
    func setBannerView(_ bannerView: UIView) {
        removeBannerView()
        bannerViewContainer.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.topAnchor.constraint(equalTo: bannerViewContainer.topAnchor).isActive = true
        bannerView.bottomAnchor.constraint(equalTo: bannerViewContainer.bottomAnchor).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: bannerViewContainer.centerXAnchor).isActive = true
    }

    func removeBannerView() {
        bannerViewContainer.subviews.forEach { $0.removeFromSuperview() }
    }

    func hideBanner() {
        setBannerHeight(0)
    }

    func resizeBanner(to height: CGFloat) {
        setBannerHeight(height)
    }
}
