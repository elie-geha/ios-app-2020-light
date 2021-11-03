//
//  Job.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 31/10/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import Foundation

struct Job: Decodable {
	var salaryMin: String?
	var salaryMax: String?
	var salaryType: String?
	var salaryCurrencyCode: String?
	let salary: String
	let locations: String
	let site: String
	let date: String
	let description: String
	let url: String
	let title: String
	let company: String
}
