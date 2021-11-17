//
//  CityListViewController.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 31/10/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import UIKit

protocol JobListUsecase {
	func getJobs()
	func didScroll(percentage: CGFloat)
	func shareMessage(at position: Int) -> JobShareMessage
	func shareOnFacebookMessage(at position: Int) -> JobShareMessage
	func job(at position: Int) -> Job
}

protocol JobListView : AnyObject {
	func showEmptyView()
	func showFirstPageLoading()
	func showNextPageLoading()
	func hideLoading()
	func toggle(networkStatus: String, isShow: Bool)
	func loadMore(items: [JobCellViewModel])
	func reloadData(items: [JobCellViewModel])
	func show(error: String)
}

protocol JobListActionDelegate: AnyObject {
	func share(message: JobShareMessage)
	func shareOnFacebook(message: JobShareMessage)
	func showJobDetail(job: Job)
}

class JobListViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
//	@IBOutlet weak var networkStatusHeight: NSLayoutConstraint!
//	@IBOutlet weak var networkStatus: UILabel!
	@IBOutlet weak var error: UILabel!
	@IBOutlet weak var errorBottom: NSLayoutConstraint!

	var usecase: JobListUsecase?
	private var items: [JobCellViewModel] = [] {
		didSet {
			tableView.reloadData()
		}
	}
	weak var actions: JobListActionDelegate?

//	var share: ((Job) -> Void)?
//	var	shareOnFacebook: ((Job) -> Void)?
//	var showDetail: ((Job) -> Void)?

	override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationItem.title = "Jobs"

		setupTableView()
		usecase?.getJobs()
    }

	private func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self
		let refreshControl = UIRefreshControl(frame: .zero)
		refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
		tableView.refreshControl = refreshControl
	}

	@objc private func refresh() {
		usecase?.getJobs()
	}

	private func toggleErrorView(show: Bool) {
		self.errorBottom.constant = show ? 0 : -(self.view.safeAreaInsets.bottom + 44)
		UIView.animate(withDuration: 0.3) { [weak self] in
			self?.view.layoutIfNeeded()
		}
	}
}

extension JobListViewController: JobListView {

	func showEmptyView() {
		self.items = []
		let emptyView = UIView(frame: self.view.frame)
		tableView.tableFooterView = emptyView
	}

	func showFirstPageLoading() {
		tableView.refreshControl?.beginRefreshing()
	}

	func showNextPageLoading() {
		let indicator = UIActivityIndicatorView()
		indicator.startAnimating()
		tableView.tableFooterView = indicator
	}

	func hideLoading() {
		tableView.refreshControl?.endRefreshing()
		tableView.tableFooterView = nil
	}

	func toggle(networkStatus: String, isShow: Bool) {
	}

	func loadMore(items: [JobCellViewModel]) {
		self.items.append(contentsOf: items)
		tableView.reloadData()
	}

	func reloadData(items: [JobCellViewModel]) {
		self.items = items
	}

	func show(error: String) {
		self.error.text = error
		self.toggleErrorView(show: true)
		DispatchQueue.main.asyncAfter(deadline: .now()+3) { [weak self] in
			self?.toggleErrorView(show: false)
		}
	}

}

extension JobListViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: JobCell.self), for: indexPath) as! JobCell
		cell.viewModel = items[indexPath.row]
		cell.share =  { [weak self] (cell) in
			guard let position = self?.tableView.indexPath(for: cell)?.row,
				  let msg = self?.usecase?.shareMessage(at: position) else {return}
			self?.actions?.share(message: msg)
		}
		cell.shareOnFaceboook =  { [weak self] (cell) in
			guard let position = self?.tableView.indexPath(for: cell)?.row,
				  let msg = self?.usecase?.shareMessage(at: position) else {return}
			self?.actions?.shareOnFacebook(message: msg)
		}
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let job = usecase?.job(at: indexPath.row) else {return}
		self.actions?.showJobDetail(job: job)
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let height = scrollView.contentSize.height - scrollView.frame.size.height
		let scrolledPercentage = scrollView.contentOffset.y / height
		usecase?.didScroll(percentage: scrolledPercentage)
	}
}
