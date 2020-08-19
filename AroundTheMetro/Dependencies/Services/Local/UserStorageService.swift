//
//  UserStorageService.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

struct Keys {
    static let country = "country"
    static let city = "city"
}

class UserStorageService: LocalStorageService {
    @UserDefaultsBacked(key: Keys.country, defaultValue: nil)
    var currentCountry: String?

    @UserDefaultsBacked(key: Keys.city, defaultValue: nil)
    var currentCity: String?
}
