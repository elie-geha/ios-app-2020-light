//
//  JobListUsecase.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 01/11/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import Foundation

protocol JobListUsecase {
	func getJobs()
	func didScroll(percentage: CGFloat)
}

class AllJobListUsecase {

	private let viewModel: JobListViewModel
	private let service: JobService
	private var page = 1
	private let city: String
	private var isLoading = false
	private let reachibility: Reacibility

	init(viewModel: JobListViewModel, service: JobService, city: String, reachibility: Reacibility) {
		self.viewModel = viewModel
		self.service = service
		self.city = city
		self.reachibility = reachibility
	}
}

extension AllJobListUsecase: JobListUsecase {
	func getJobs() {
		isLoading = true
		page = 1
		viewModel.loadingFirstPage()
		service.getJobs(page: page, location: city, keyword: "") { [weak self] result in
			self?.isLoading = false
			switch result {
			case .success(let jobs):
				self?.viewModel.reload(items: jobs)
			case .failure(let error):
				self?.viewModel.show(error: error)
			}
		}
	}

	func didScroll(percentage: CGFloat) {
		guard percentage > 0.9, !isLoading, reachibility.isNetworkAvailable  else {
			return
		}
		isLoading = true
		let newPage = page + 1
		viewModel.loadingNexPage()
		service.getJobs(page: newPage, location: city, keyword: "") { [weak self] result in
			self?.isLoading = false
			switch result {
			case .success(let jobs):
				self?.viewModel.loadMoreItems(items: jobs)
			case .failure(let error):
				self?.viewModel.show(error: error)
			}
		}
	}
}
