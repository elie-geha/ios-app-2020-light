//
//  PageType.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 26.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

enum PageType {
    case changeCity
    case login
    case profile
    case home
    case leftMenu
    case locateMetro
    case metroPlan
    case places(PlaceType)
    case details(PlaceType)
}
