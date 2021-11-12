//
//  JobDetailUsecase.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 10/11/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import Foundation

class JobAllDetailUsecase {

	private let job: Job
	private let viewModel: JobDetailViewModel

	init(job: Job, viewModel: JobDetailViewModel) {
		self.job = job
		self.viewModel = viewModel
	}
}

extension JobAllDetailUsecase: JobDetailUsecase {
	func viewDidLoad() {
		viewModel.showJobDetail(job: self.job)
	}

	func shareMessage() -> JobShareMessage {
		return JobShareMessageGenerator.shareContent(job: job)
	}

	func shareOnFacebookMessage() -> JobShareMessage {
		return JobShareMessageGenerator.shareContent(job: job)
	}
}
