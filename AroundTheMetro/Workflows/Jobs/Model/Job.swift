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

class JobShareMessageGenerator {

	static func shareContent(job: Job) -> JobShareMessage {
		let url = URL(string: "https://apps.apple.com/us/app/id1276636784")!
		let message = "I found this Job Offer: (\(job.title)) on Around the Metro. Download the App for Free and find your dream job today."
		return JobShareMessage(url: url, message: message)
	}
}

struct JobShareMessage {
	let url: URL
	let message: String
}
