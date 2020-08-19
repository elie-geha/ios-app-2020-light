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
    static let identifier: String = "BannersCell"

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
            collectionView.register(BannerCell.nib, forCellWithReuseIdentifier: BannerCell.identifier)
        }
    }

    @IBOutlet weak var layout: UICollectionViewFlowLayout! {
        didSet {
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 240)
        }
    }

    @IBOutlet weak var pageControl: UIPageControl!
}

extension BannersCell: UICollectionViewDelegate {}

extension BannersCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier,
                                                      for: indexPath) as! BannerCell

        let banner = banners[indexPath.row]
        if let image = URL(string: AppConstants.BANNER_IMAGE_URL + banner.image) {
            cell.imageView.kf.setImage(with: image)
        }

        return cell
    }

    func scrollView(_ scrollView: UIScrollView, pageIndex: Int) {
        pageControl.currentPage = pageIndex
    }
}
