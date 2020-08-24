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

    @IBOutlet weak var layout: UICollectionViewFlowLayout! {
        didSet {
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 240)
        }
    }

    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        }
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

    func scrollView(_ scrollView: UIScrollView, pageIndex: Int) {
        pageControl.currentPage = pageIndex
    }
}
