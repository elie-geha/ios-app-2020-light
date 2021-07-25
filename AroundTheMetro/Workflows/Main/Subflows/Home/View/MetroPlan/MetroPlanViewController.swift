//
//  MetroPlanViewController.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 24.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit
import SDWebImage

class MetroPlanViewController: UIViewController {

    var city: City? {
        didSet {
//            if isViewLoaded {
                
//            }
        }
    }

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1
        self.scrollView.maximumZoomScale = 10.0
        setImage()
    }

    func setImage() {
        if city?.name == "Moscow" {
            imageView.image = UIImage(named: "Moscow_Map")
            activityIndicator.stopAnimating()
            return
        } else if city?.name == "Sofia" {
            imageView.image = UIImage(named: "Sofia_Map")
            activityIndicator.stopAnimating()
            return
        }
        activityIndicator.startAnimating()
        guard let url = URL(string: city?.metroPlanImageUrl ?? "") else { activityIndicator.stopAnimating(); return }
        imageView.sd_setImage(with: url) { [weak self] (image, error, cacheType, url) in
            self?.activityIndicator.stopAnimating()
        }
    }
}

extension MetroPlanViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
