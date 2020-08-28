//
//  AdsIntegration.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 28.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Foundation
import GoogleMobileAds

class AdsIntegration: NSObject, AdsIntegrationType {
    private var lastInterstitialShowTime: Date = Date(timeIntervalSince1970: 0)
    private var detailsPageViews = 0
    private var adsContainer: AdsContainer?
    private var interstitial = GADInterstitial(adUnitID: AppConstants.Ads.interstitialUnitID)

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
            let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            bannerView.rootViewController = adsContainer
            bannerView.adUnitID = AppConstants.Ads.bannerAdsUnitID
            bannerView.delegate = self
            bannerView.isAutoloadEnabled = true

            adsContainer.setBannerView(bannerView)
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
        adsContainer?.showBanner()
    }

    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        adsContainer?.hideBanner()
    }
}

extension AdsIntegration: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if let adsContainer = adsContainer {
            ad.present(fromRootViewController: adsContainer)
        }
    }
}
