//
//  BannersCell.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Kingfisher
import UIKit

class BannersCell: UITableViewCell {
    var banners: [Banner] = [] {
        didSet {
            pageControl.numberOfPages = banners.count
            collectionView.reloadData()
        }
    }

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(ImageCell.nib, forCellWithReuseIdentifier: ImageCell.reuseID)
        }
    }

    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        }
    }

    @IBOutlet weak var layout: UICollectionViewFlowLayout!

    override func layoutSubviews() {
        super.layoutSubviews()

        layout.itemSize = CGSize(width: bounds.width, height: 240)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension BannersCell: UICollectionViewDelegate {}

extension BannersCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID,
                                                      for: indexPath) as! ImageCell

        let banner = banners[indexPath.row]
        cell.imageView.kf.setImage(with: URL(string: AppConstants.API.bannerImageURL + banner.image))
        
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard bounds.width > 0 else { return }
        let pageIndex = scrollView.contentOffset.x / bounds.width
        pageControl.currentPage = Int(pageIndex)
    }
}
