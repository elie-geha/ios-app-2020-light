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

    var onCall: ((Place) -> Void)?
    var onWebsite: ((Place) -> Void)?

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
