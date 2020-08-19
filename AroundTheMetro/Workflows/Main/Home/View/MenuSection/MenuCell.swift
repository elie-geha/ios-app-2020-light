//
//  MenuCell.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

struct MenuItem {
    var type: HomeMenuType
    var onSelect: () -> Void
}

class MenuCell: UITableViewCell {
    static let identifier: String = "MenuCell"

    var menuItems: [MenuItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(ImageCell.nib, forCellWithReuseIdentifier: ImageCell.identifier)
        }
    }

    @IBOutlet weak var layout: UICollectionViewFlowLayout!{
        didSet {
            layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 16)/2, height: 140)
        }
    }
}

extension MenuCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        menuItems[indexPath.row].onSelect()
    }
}

extension MenuCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath)
            as! ImageCell

        let menuItem = menuItems[indexPath.row]
        cell.imageView.image = UIImage(named: menuItem.type.backgroundImageName)
        cell.iconView.image = UIImage(named: menuItem.type.iconName)
        cell.title = menuItem.type.title
        
        return cell
    }
}
