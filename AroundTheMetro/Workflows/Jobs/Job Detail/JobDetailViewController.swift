//
//  JobDetailViewController.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 10/11/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import UIKit
import SafariServices

protocol JobDetailUsecase {
	func viewDidLoad()
	func shareMessage() -> JobShareMessage
	func shareOnFacebookMessage() -> JobShareMessage
	func getUrl() -> URL?
}

protocol JobDetailActionDelegate: AnyObject{
	func share(message: JobShareMessage)
	func shareOnFacebook(message: JobShareMessage)
	func open(url: URL)
}

protocol JobDetailView: AnyObject {
	func setJobDetails(title: String, company: String, location: String, salary: String, detail: String, date: String, url: String)
}

class JobDetailViewController: UIViewController {

	@IBOutlet weak var jobTitle: UILabel!
	@IBOutlet weak var compnay: UILabel!
	@IBOutlet weak var location: UILabel!
	@IBOutlet weak var date: UILabel!
	@IBOutlet weak var salary: UILabel!
	@IBOutlet weak var salaryView: UIView!
	@IBOutlet weak var detail: UILabel!
	@IBOutlet weak var url: UILabel!

	weak var actions: JobDetailActionDelegate?
	var usecase: JobDetailUsecase!

    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.title = "Job Detail"
		usecase?.viewDidLoad()

		let tap = UITapGestureRecognizer(target: self, action: #selector(actOpenUrl))
		url.addGestureRecognizer(tap)
    }

	@IBAction private func actShare() {
		actions?.share(message: usecase.shareMessage())
	}

	@IBAction func actShareOnFacebook() {
		actions?.shareOnFacebook(message: usecase.shareOnFacebookMessage())
	}

	@objc private func actOpenUrl() {
		guard let url = usecase.getUrl() else {return}
//		actions?.open(url: url)
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
	}
}

extension JobDetailViewController: JobDetailView {
	func setJobDetails(title: String, company: String, location: String, salary: String, detail: String, date: String, url: String) {
		self.jobTitle.text = title
		self.compnay.text = company
		self.location.text = location
		self.salary.text = salary
		salaryView.isHidden = salary.isEmpty
		self.detail.text = detail
		self.date.text = date
		self.url.text = url
	}
}
