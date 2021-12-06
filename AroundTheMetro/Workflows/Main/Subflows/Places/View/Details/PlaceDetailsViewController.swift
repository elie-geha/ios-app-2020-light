//
//  PlaceDetailsViewController.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 22.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseAnalytics

class PlaceDetailViewController: UIViewController {

    var place: Place? {
        didSet {
            if isViewLoaded {
                setupView()
            }
        }
    }
	var city: City?

    var onCall: ((Place) -> Void)?
    var onWebsite: ((Place) -> Void)?
	var showSubscription: (() -> Void)?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var mallLabel: UILabel!
    @IBOutlet weak var metroLabel: UILabel!

    @IBOutlet weak var openhoursTxtView: UITextView!

    @IBOutlet weak var callusBtn: UIButton!
    @IBOutlet weak var websiteBtn: UIButton!

    @IBAction func callUsBtnTapped(_ sender: UIButton) {
        if let place = place {
            onCall?(place)
        }
    }

    @IBAction func websiteBtnTapped(_ sender: UIButton) {
        if let place = place {
            onWebsite?(place)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        callusBtn.setTitle("Call Us".localized, for: .normal)
        websiteBtn.setTitle("Website".localized, for: .normal)

        setupView()

		/*
		guard !IAPManager.shared.isSubscribed else {return}
		if IronSource.hasRewardedVideo(), RewardVideoAdManager().shouldDisplay() {
			IronSource.setRewardedVideoDelegate(self)
			IronSource.showRewardedVideo(with: self)
		}else if InterstatialAdManager().shouldDisplay() {
			showInterstitialAd()
		}*/
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationItem()
	}

	/*
	private func showInterstitialAd() {
		IronSource.setInterstitialDelegate(self)
		IronSource.loadInterstitial()
	}*/

	func setupNavigationItem() {
		let item = UIBarButtonItem(image: UIImage(named: "share-2")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(actShare))
		item.tintColor = UIColor(hex: "#555555")
		self.navigationItem.rightBarButtonItem = item
	}

	@objc private func actShare() {
		let items: [Any] = ["Checkout \(place?.name ?? "") a Great Place Near Metro Station \(place?.metroName ?? "") in \(city?.name ?? "") \nDownload the App for Free: https://apps.apple.com/us/app/id1276636784 and discover great places around metro stations."/*, URL(string: "https://apps.apple.com/us/app/id1276636784")!*/]
		let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
		if (ac.popoverPresentationController != nil) {
			ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
		}
		self.present(ac, animated: true)
	}

    func setupView() {

        self.title = place?.name

        if let imageURL = place?.imageURL {
            self.imageView.kf.setImage(with: imageURL)
        } else {
            self.imageView.image = place?.placeType.defaultImage
        }

        titleLabel.text = place?.name

        if let type = place?.placeType.rawValue {
            typeLabel.isHidden = false
            typeLabel.text = "Type".localized + " : " + type.localized
        } else {
            typeLabel.isHidden = true
        }

        if let metroName = place?.metroName {
            metroLabel.isHidden = false
            metroLabel.text = "Metro".localized + " : \(metroName)"
        } else {
            metroLabel.isHidden = true
        }

        if let mallname = place?.mallName {
            mallLabel.isHidden = false
            mallLabel.text = "Mall".localized + " : \(mallname)"
        } else {
            mallLabel.isHidden = true
        }

        websiteBtn.isHidden = place?.website == nil || place?.website?.isEmpty == true
        callusBtn.isHidden = place?.phoneNumber == nil || place?.phoneNumber?.isEmpty == true

        openhoursTxtView.isHidden = true
    }
}

/*
extension PlaceDetailViewController: ISRewardedVideoDelegate {
	func rewardedVideoHasChangedAvailability(_ available: Bool) {

	}

	func didReceiveReward(forPlacement placementInfo: ISPlacementInfo!) {

	}

	func rewardedVideoDidFailToShowWithError(_ error: Error!) {

	}

	func rewardedVideoDidOpen() {

	}

	func rewardedVideoDidClose() {
		if !(IAPManager.shared.isSubscribed) {
			self.showSubscription?()
		}
	}

	func rewardedVideoDidStart() {

	}

	func rewardedVideoDidEnd() {

	}

	func didClickRewardedVideo(_ placementInfo: ISPlacementInfo!) {

	}
}

//MARK:- ISBannerDelegate
extension PlaceDetailViewController: ISInterstitialDelegate {
	func interstitialDidLoad() {
		IronSource.showInterstitial(with: self)
	}

	func interstitialDidFailToLoadWithError(_ error: Error!) {

	}

	func interstitialDidOpen() {

	}

	func interstitialDidClose() {

	}

	func interstitialDidShow() {

	}

	func interstitialDidFailToShowWithError(_ error: Error!) {

	}

	func didClickInterstitial() {

	}
}*/
