//
//  UserStorageService.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

enum Keys {
    static let country = "country"
    static let city = "city"
    static let  isFirstLaunch = "isFirstLaunch"
}

class UserStorageService: LocalStorageService {
    @UserDefaultsBacked(key: Keys.country)
    var currentCountry: String?

    @UserDefaultsBacked(key: Keys.city)
    var currentCity: String?

    @UserDefaultsBacked(key: Keys.isFirstLaunch, defaultValue: true)
    var isFirstLaunch: Bool
}
