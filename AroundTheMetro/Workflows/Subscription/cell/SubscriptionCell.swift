//
//  SubscriptionCell.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 23/06/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import UIKit

class SubscriptionCell: UICollectionViewCell {

	static let reuseIdentifier = "SubscriptionCell"
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var title: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	func set(item: SlideItem) {
		self.imageView.image = item.icon
		self.title.text = item.title
	}

}
