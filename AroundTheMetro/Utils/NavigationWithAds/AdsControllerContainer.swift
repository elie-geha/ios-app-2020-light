//
//  AdsControllerContainer.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 24.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import GoogleMobileAds
import UIKit

class AdsControllerContainer: UIViewController {
    private var bannerHeight: NSLayoutConstraint!

    private var bannerView = GADBannerView(adSize: kGADAdSizeBanner)
    private var contentContainer = UIView()

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
        initAdMobBanner()
    }

    func showAds() {
        setBannerHeight(AppConstants.Ads.adBannerheight)
    }

    func hideAds() {
        setBannerHeight(0)
    }

    private func setBannerHeight(_ bannerHeight: CGFloat) {
        self.bannerHeight.constant = bannerHeight

        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    private func layoutViews() {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentContainer)

        contentContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        bannerView.topAnchor.constraint(equalTo: contentContainer.bottomAnchor).isActive = true
        bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        bannerHeight = bannerView.heightAnchor.constraint(equalToConstant: AppConstants.Ads.adBannerheight)
        bannerHeight.isActive = true
    }

    private func initAdMobBanner() {
        bannerView.adUnitID = AppConstants.Ads.bannerAdsUnitID
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.isAutoloadEnabled = true
    }
}

extension AdsControllerContainer: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ view: GADBannerView) {
        showAds()
    }

    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        hideAds()
    }
}
