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
//    private var request : GADRequest?
    private var interstitial: GADInterstitialAd?
	static var ironsourceBannerHeight: CGFloat = 90
	
    override init() {
        super.init()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }

    func handleEvent(with type: AdsEventType) {
        switch type {
        case .openDetailsPage:
//            detailsPageViews += 1
//            if detailsPageViews == AppConstants.Ads.detailsPageViewsToShowInterstitial {
                showInterstitialIfNeeded()
//                detailsPageViews = 0
//            }
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
		var bannerView = GADBannerView()
		bannerView.rootViewController = adsContainer
		bannerView.adUnitID = AppConstants.Ads.bannerAdsUnitID
		bannerView.delegate = self
		bannerView.isAutoloadEnabled = true
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
		adsContainer.setBannerView(bannerView)
        
		adsContainer.onResized = { newSize in
            let size = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(newSize.width)
            bannerView.adSize = GADAdSize.init(size: CGSize.init(width: 320, height: 50), flags: UInt.init(0))
            adsContainer.resizeBanner(to: 0)
//			bannerView = GADBannerView(adSize: GADAdSizeBanner)
//            adsContainer.resizeBanner(to: bannerView.frame.height)
			bannerView.load(GADRequest())
		}
	}

//	private func showIronsourceBannerView(adsContainer: AdsContainer) {
//		IronSource.setBannerDelegate(self)
//		if let size = ISBannerSize(width: Int(adsContainer.view.frame.size.width), andHeight: Int(AdsIntegration.ironsourceBannerHeight)) {
//		if let size = ISBannerSize(width: Int(320), andHeight: Int(50)) {
//			IronSource.loadBanner(with: adsContainer, size: size,placement: "Main_Menu")
//		}
//	}

    private func showInterstitialIfNeeded() {
//        let sinceLastShow = Date().timeIntervalSince(lastInterstitialShowTime)
//        let minInterval = AppConstants.Ads.intervalBetweenInterstitialShows
//        guard sinceLastShow >= minInterval else {
//            return
//        }
//
//        lastInterstitialShowTime = Date()
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:AppConstants.Ads.interstitialUnitID,
                                        request: request,
                              completionHandler: { [self] ad, error in
                                if let error = error {
                                  print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                  return
                                }
                                interstitial = ad
                                interstitial?.fullScreenContentDelegate = self
                              }
            )
    }
}

extension AdsIntegration: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("banner receive ad")
        adsContainer?.setBannerView(bannerView)
    }
    
    // NO AdMob banner available
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("banner with error \(error)")
        adsContainer?.hideBanner()
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
}

extension AdsIntegration: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
      func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content. \(error)")
      }

      /// Tells the delegate that the ad presented full screen content.
      func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
        if let adsContainer = adsContainer {
            if !IAPManager.shared.isSubscribed {
                interstitial?.present(fromRootViewController: adsContainer)
//                ad.present(fromRootViewController: adsContainer)
            }
        }
      }

      /// Tells the delegate that the ad dismissed full screen content.
      func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
      }
    
}

//MARK:- ISBannerDelegate
//extension AdsIntegration: ISBannerDelegate {
//	func bannerDidLoad(_ bannerView: ISBannerView!) {
//		DispatchQueue.main.async { [weak self] in
//			self?.adsContainer?.resizeBanner(to: AdsIntegration.ironsourceBannerHeight)
//		}
//	}
//
//	func bannerDidFailToLoadWithError(_ error: Error!) {
//		print("Ironsource Banner error:\(error)")
//		DispatchQueue.main.async { [weak self] in
//			self?.adsContainer?.hideBanner()
//		}
//	}
//
//	func didClickBanner() {
//
//	}
//
//	func bannerWillPresentScreen() {
//
//	}
//
//	func bannerDidDismissScreen() {
//
//	}
//
//	func bannerWillLeaveApplication() {
//
//	}
//
//	func bannerDidShow() {
//
//	}
//}
