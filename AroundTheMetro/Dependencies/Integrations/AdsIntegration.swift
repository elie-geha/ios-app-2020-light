//
//  AdsIntegration.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 28.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Foundation
import GoogleMobileAds

class InterstatialAdManager {
	private var counter: Int {
		set {
			UserDefaults.standard.set(newValue, forKey: "InterstatialAdCounter")
		}
		get {
			return (UserDefaults.standard.value(forKey: "InterstatialAdCounter") as? Int) ?? 0
		}
	}

	func shouldDisplay() -> Bool {
		return counter % 3 == 0
	}
}

class RewardVideoAdManager {
	private var counter: Int {
		set {
			UserDefaults.standard.set(newValue, forKey: "RewardVideoCounter")
		}
		get {
			return (UserDefaults.standard.value(forKey: "RewardVideoCounter") as? Int) ?? 0
		}
	}

	func shouldDisplay() -> Bool {
		return counter % 5 == 0
	}
}

class AdsIntegration: NSObject, AdsIntegrationType {
    private var lastInterstitialShowTime: Date = Date(timeIntervalSince1970: 0)
    private var detailsPageViews = 0
    private var adsContainer: AdsContainer?
    private var interstitial = GADInterstitial(adUnitID: AppConstants.Ads.interstitialUnitID)
	static var ironsourceBannerHeight: CGFloat = 90
	
    override init() {
        super.init()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        interstitial.delegate = self
    }

    func handleEvent(with type: AdsEventType) {
        switch type {
        case .openDetailsPage:
            detailsPageViews += 1
            if detailsPageViews == AppConstants.Ads.detailsPageViewsToShowInterstitial {
                showInterstitialIfNeeded()
                detailsPageViews = 0
            }
            break;
        }
    }

    func setAdsContainer(_ adsContainer: AdsContainer?) {
        self.adsContainer?.hideBanner()
        self.adsContainer?.removeBannerView()
        self.adsContainer = adsContainer

        if let adsContainer = adsContainer {
			//showIronsourceBannerView(adsContainer: adsContainer)
			showGoogleBannerView(adsContainer: adsContainer)
        }
    }

	private func showGoogleBannerView(adsContainer: AdsContainer) {
		let bannerView = GADBannerView()
		bannerView.rootViewController = adsContainer
		bannerView.adUnitID = AppConstants.Ads.bannerAdsUnitID
		bannerView.delegate = self
		bannerView.isAutoloadEnabled = true

		adsContainer.setBannerView(bannerView)
		adsContainer.onResized = { newSize in
			let size = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(newSize.width)
			bannerView.adSize = size
			adsContainer.resizeBanner(to: size.size.height)
			bannerView.load(GADRequest())
		}
	}

	private func showIronsourceBannerView(adsContainer: AdsContainer) {
		IronSource.setBannerDelegate(self)
//		if let size = ISBannerSize(width: Int(adsContainer.view.frame.size.width), andHeight: Int(AdsIntegration.ironsourceBannerHeight)) {
		if let size = ISBannerSize(width: Int(320), andHeight: Int(50)) {
			IronSource.loadBanner(with: adsContainer, size: size,placement: "Main_Menu")
		}
	}

    private func showInterstitialIfNeeded() {
        let sinceLastShow = Date().timeIntervalSince(lastInterstitialShowTime)
        let minInterval = AppConstants.Ads.intervalBetweenInterstitialShows
        guard sinceLastShow >= minInterval else {
            return
        }

        lastInterstitialShowTime = Date()
        interstitial.load(GADRequest())
    }
}

extension AdsIntegration: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ view: GADBannerView) {
        adsContainer?.resizeBanner(to: view.adSize.size.height)
    }

    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        adsContainer?.hideBanner()
    }
}

extension AdsIntegration: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if let adsContainer = adsContainer {
            if !IAPManager.shared.isSubscribed {
            ad.present(fromRootViewController: adsContainer)
            }
        }
    }
}

//MARK:- ISBannerDelegate
extension AdsIntegration: ISBannerDelegate {
	func bannerDidLoad(_ bannerView: ISBannerView!) {
		DispatchQueue.main.async { [weak self] in
			self?.adsContainer?.resizeBanner(to: AdsIntegration.ironsourceBannerHeight)
		}
	}

	func bannerDidFailToLoadWithError(_ error: Error!) {
		print("Ironsource Banner error:\(error)")
		DispatchQueue.main.async { [weak self] in
			self?.adsContainer?.hideBanner()
		}
	}

	func didClickBanner() {

	}

	func bannerWillPresentScreen() {

	}

	func bannerDidDismissScreen() {

	}

	func bannerWillLeaveApplication() {

	}

	func bannerDidShow() {

	}
}
