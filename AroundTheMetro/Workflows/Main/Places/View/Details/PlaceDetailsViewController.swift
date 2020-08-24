//
//  PlaceDetailsViewController.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 22.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit
import Kingfisher
// import FirebaseAnalytics

class PlaceDetailViewController: UIViewController {

    var place: Place? {
        didSet {
            if isViewLoaded {
                setupView()
            }
        }
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var mallLabel: UILabel!
    @IBOutlet weak var metroLabel: UILabel!

    @IBOutlet weak var openhoursTxtView: UITextView!

    @IBOutlet weak var callusBtn: UIButton!
    @IBOutlet weak var websiteBtn: UIButton!


    @IBAction func callUsBtnTapped(_ sender: UIButton) {
        guard let place = place, let phoneNumber = place.phoneNumber,
            !phoneNumber.isEmpty,
            let numberURL = URL(string: "telprompt://" + phoneNumber) else { return }

        UIApplication.shared.open(numberURL, options: [:], completionHandler: nil)

        // TODO: analytics
        //let p = place.name
//        Analytics.logEvent("call_placed", parameters: [
//            "place": p as NSObject,
//            "phoneNumber": phoneNumber ?? "not a number" as NSObject
//            ])
    }

    @IBAction func websiteBtnTapped(_ sender: UIButton) {
        guard let place = place,
            let website = place.website,
            !website.isEmpty,
            let url = URL(string: website) else { return }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)

//
//        let p = (place["name"] as? String)!
//
//        Analytics.logEvent("website_clicked", parameters: [
//            "place": p as NSObject,
//            "url": websiteAddress ?? "no url" as NSObject
//            ])
//
//        let rentFormVC = self.storyboard?.instantiateViewController(withIdentifier: "rentFormViewController") as! RentFormViewController
//
//        rentFormVC.titlename = (place["name"] as? String)!
//
//        rentFormVC.url = websiteAddress! as String
//
//        Public.configureBackButton(vc: self)
//
//        self.navigationController?.pushViewController(rentFormVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        //Sending info to Firebase (place name of page viewed)
//        let p = (place["name"] as? String)!
//
//        Analytics.logEvent("place_page_view", parameters: [
//            "place": p as NSObject,
//            ])

        callusBtn.setTitle("Call Us".localized, for: .normal)
        websiteBtn.setTitle("Website".localized, for: .normal)

        setupView()
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

            typeLabel.text = "Type : \(type)".localized
        } else {
            typeLabel.text = ""
        }

        if let metroName = place?.metroName {
            metroLabel.text = "Metro".localized + " : \(metroName)"
        } else {
            metroLabel.text = ""
        }

        if let mallname = place?.mallName {
            mallLabel.text = "Mall".localized + " : \(mallname)"
        } else {
            mallLabel.text = ""
        }

        websiteBtn.isHidden = place?.website == nil || place?.website?.isEmpty == true
        callusBtn.isHidden = place?.phoneNumber == nil || place?.phoneNumber?.isEmpty == true
    }
}
