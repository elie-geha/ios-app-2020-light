//
//  UIView+Factory.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 21.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

public enum UIError: Error {
    case noNibName
    case nibNotFound
}

public extension UIView {
    @objc class var nibName: String {
        return String(describing: self)
    }

    class var nib: UINib {
        return UINib(nibName: nibName, bundle: .current)
    }

    class func instantiate() throws -> UIView {
        do {
            let viewToInstantiate: UIView = try instantiateNibNamed(nibName)
            return viewToInstantiate
        } catch {
            throw error
        }
    }

    class func nib(for nibName: String?) throws -> UINib {
        guard let nibName = nibName else {
            throw UIError.nibNotFound
        }
        let nib: UINib = UINib(nibName: nibName, bundle: Bundle(for: self.classForCoder()))
        return nib
    }

    class func instantiateNibNamed(_ nibName: String?) throws -> UIView {
        guard let nibName = nibName else {
            throw UIError.noNibName
        }
        do {
            guard let view = try nib(for: nibName).instantiate(withOwner: nil, options: nil).first as? UIView else {
                throw UIError.nibNotFound
            }
            return view
        } catch {
            throw UIError.nibNotFound
        }
    }
}

