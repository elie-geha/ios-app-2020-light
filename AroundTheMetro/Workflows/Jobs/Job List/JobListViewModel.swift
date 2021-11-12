//
//  JobListViewModel.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 01/11/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import Foundation

protocol JobListViewModel {
	var itemCount: Int {get}
	func loadingFirstPage()
	func loadingNexPage()
	func reload(items: [Job])
	func show(error: Error)
	func loadMoreItems(items: [Job])
	func job(at position: Int) -> Job
}

class AllJobListViewModel {

	private weak var view: JobListView?
	private var jobs = [Job]()

	init(view: JobListView) {
		self.view = view
	}
}

extension AllJobListViewModel: JobListViewModel {
	var itemCount: Int {jobs.count}


	func loadingFirstPage() {
		view?.showFirstPageLoading()
	}

	func loadingNexPage() {
		view?.showNextPageLoading()
	}

	func reload(items: [Job]) {
		view?.hideLoading()
		self.jobs = items
		view?.reloadData(items: items.map{JobCellViewModel(job: $0)})
	}

	func show(error: Error) {
		view?.hideLoading()
		view?.show(error: error.localizedDescription)
	}

	func loadMoreItems(items: [Job]) {
		view?.hideLoading()
		view?.loadMore(items: items.map{JobCellViewModel(job: $0)})
	}

	func job(at position: Int) -> Job {
		return jobs[position]
	}
}
