//
//  Layer+Utilities.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 01/11/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import Foundation
import UIKit

public extension CALayer {


	/// Apply shadow providing argumenst same as used in sketch
	///
	/// - Parameters:
	///   - color: shadow color
	///   - alpha: shadow alpha
	///   - x: x offset
	///   - y: y offset
	///   - blur: shadow blurr
	///   - spread: shadow spread
	func applySketchShadow( color: UIColor , alpha: Float, blur: CGFloat, spread: CGFloat, offset: CGSize = .zero) {
		shadowColor = color.cgColor
		shadowOpacity = alpha
		shadowOffset = offset
		shadowRadius = blur / 2.0
		if spread == 0 {
			shadowPath = nil
		} else {
			let dx = -spread
			let rect = bounds.insetBy(dx: dx, dy: dx)
			shadowPath = UIBezierPath(rect: rect).cgPath
		}
	}
}
