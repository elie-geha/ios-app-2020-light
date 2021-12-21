//
//  JobCoordinator.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 10/11/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import Foundation
import FBSDKShareKit

class JobCoordinator: NSObject {

	private let currentCity: String
	private let router: UINavigationController
    // MARK: - Context
    private var context: AppContext
    
	init(with router: UINavigationController, currentCity: String,
         context: AppContext) {
		self.router = router
		self.currentCity = currentCity
        self.context = context
	}

	func start() {
		openJobList()
	}

	private func openJobList() {
		let vc = Storyboard.Job.jobList
		let viewModel = AllJobListViewModel(view: vc)

		let reachibility = NetworkReachibility()
		let service = JobServiceWithFallbackToLocalData(remote: JobRemoteService(), local: JobLocalService(), reachibility: reachibility)
		let usecase = AllJobListUsecase(viewModel: viewModel, service: service, city: currentCity, reachibility: reachibility)

		vc.usecase = usecase
		vc.actions = self
        context.analytics.trackEvent(with: .jobsClicked)
		router.pushViewController(vc, animated: true)
	}

	private func openJobDetail(job: Job) {
		let vc = Storyboard.Job.jobDetail
		let viewModel = JobAllDetailViewModel(view: vc)
		let usecase = JobAllDetailUsecase(job: job, viewModel: viewModel)

		vc.usecase = usecase
		vc.actions = self
        context.analytics.trackEvent(with: .jobDetailsClicked)
		router.pushViewController(vc, animated: true)
	}

	private func showFacebookShare(msg: String, url: URL) {
		let textContent = ShareLinkContent()
		textContent.quote = msg
		textContent.contentURL = url
		textContent.hashtag = Hashtag("#aroundthemetro")

		// Share the content (photo) as a dialog with News Feed / Story
		let sharingDialog = ShareDialog.init(fromViewController: router, content: textContent, delegate: self)
		sharingDialog.show()

//		let messageDialog = MessageDialog(content: textContent, delegate: self)
//		messageDialog.show()
	}

	private func showActivityController(items: [Any]) {
		let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
		self.router.present(ac, animated: true)
	}
}

//MARK:- SharingDelegate
extension JobCoordinator: SharingDelegate {
	func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {}
	func sharer(_ sharer: Sharing, didFailWithError error: Error) {}
	func sharerDidCancel(_ sharer: Sharing) {}
}

//MARK:- JobListAction
extension JobCoordinator: JobListActionDelegate, JobDetailActionDelegate {
	func share(message: JobShareMessage) {
		showActivityController(items: [message.message, message.url])
	}

	func shareOnFacebook(message: JobShareMessage) {
		showFacebookShare(msg: message.message, url: message.url)
	}

	func showJobDetail(job: Job) {
		openJobDetail(job: job)
	}

	func open(url: URL) {
		guard UIApplication.shared.canOpenURL(url) else {return}
		UIApplication.shared.open(url, options: [:], completionHandler: nil)
	}
}
