//
//  JobService.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 31/10/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import Foundation

protocol JobService {
	func getJobs(page: Int, location: String, keyword: String, completion: @escaping (Result<[Job],Error>) -> Void)
}

class JobServiceWithFallbackToLocalData: JobService {

	let remote: JobRemoteService
	let local: JobLocalService
	let reachibility: Reacibility

	init(remote: JobRemoteService, local: JobLocalService, reachibility: Reacibility) {
		self.remote = remote
		self.local = local
		self.reachibility = reachibility
	}

	func getJobs(page: Int, location: String, keyword: String, completion: @escaping (Result<[Job], Error>) -> Void) {

		//fallback to local data if network is not available
		guard reachibility.isNetworkAvailable else {
			local.getJobs(page: page, location: location, keyword: keyword, completion: completion)
			return
		}

		//fetch from server
		remote.getJobs(page: page, location: location, keyword: keyword) {  [weak self] result in
			switch result {
			case .success(let jobs):
				//save jobs 
				self?.local.set(page: page, location: location, keyword: keyword, jobs: jobs)
			case .failure(_): break
			}
			completion(result)
		}
	}
}


class JobLocalService: JobService {

	private var pages: [Int: [Job]] = [:]
	private var location: String = ""
	private var keyword: String = ""

	func getJobs(page: Int, location: String, keyword: String, completion: @escaping (Result<[Job], Error>) -> Void) {
		if filterMatch(location: location, keyword: keyword),
		   let jobs = pages[page] {
			completion(.success(jobs))
		}else {
			let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Internet connection is offline"])
			completion(.failure(error))
		}
	}

	func set(page: Int, location: String, keyword: String, jobs: [Job]) {
		if filterMatch(location: location, keyword: keyword) {
			//append data to existing dictionary if filters are same
			pages[page] = jobs
		}else {
			//set new pages dictionary
			self.location = location
			self.keyword = keyword
			self.pages = [page:jobs]
		}
	}

	private func filterMatch(location: String, keyword: String) -> Bool  {
		return self.location.caseInsensitiveCompare(location) == .orderedSame && self.keyword.caseInsensitiveCompare(keyword) == .orderedSame
	}
}

class JobRemoteService: JobService {

	func getJobs(page: Int, location: String, keyword: String, completion: @escaping (Result<[Job],Error>) -> Void) {
		let errorHandler: (Error) -> Void = { error in
			completion(.failure(error))
		}
		let successHandler: (Data) -> Void = { responseData in
			do {
				let response = try JSONDecoder().decode([Job].self, from: responseData)
				completion(.success(response))
			} catch(let error) {
				completion(.failure(error))
			}
		}
		NetworkAdapter.request(target: .getJobs(page: page, location: location, keyword: keyword),
							   success: successHandler,
							   error: errorHandler,
							   failure: errorHandler)
	}
}
