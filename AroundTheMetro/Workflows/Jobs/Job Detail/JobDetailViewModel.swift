//
//  JobDetailViewModel.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 10/11/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import UIKit

protocol JobDetailViewModel {
	func showJobDetail(job: Job)
}

class JobAllDetailViewModel {

	weak var view: JobDetailView?

	init(view: JobDetailView) {
		self.view = view
	}
}

extension JobAllDetailViewModel: JobDetailViewModel {
	func showJobDetail(job: Job) {
		view?.setJobDetails(title: job.title, company: job.company, location: job.locations, salary: job.salary, detail: job.description, date: job.date)
	}
}
