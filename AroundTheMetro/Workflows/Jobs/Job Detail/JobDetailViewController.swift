//
//  JobDetailViewController.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 10/11/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import UIKit

protocol JobDetailUsecase {
	func viewDidLoad()
	func shareMessage() -> JobShareMessage
	func shareOnFacebookMessage() -> JobShareMessage
}

protocol JobDetailActionDelegate: AnyObject{
	func share(message: JobShareMessage)
	func shareOnFacebook(message: JobShareMessage)
}

protocol JobDetailView: AnyObject {
	func setJobDetails(title: String, company: String, location: String, salary: String, detail: String, date: String)
}

class JobDetailViewController: UIViewController {

	@IBOutlet weak var jobTitle: UILabel!
	@IBOutlet weak var compnay: UILabel!
	@IBOutlet weak var location: UILabel!
	@IBOutlet weak var date: UILabel!
	@IBOutlet weak var salary: UILabel!
	@IBOutlet weak var salaryView: UIView!
	@IBOutlet weak var detail: UILabel!

	weak var actions: JobDetailActionDelegate?
	var usecase: JobDetailUsecase!

    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.title = "Job Detail"
		usecase?.viewDidLoad()
    }

	@IBAction private func actShare() {
		actions?.share(message: usecase.shareMessage())
	}

	@IBAction func actShareOnFacebook() {
		actions?.shareOnFacebook(message: usecase.shareOnFacebookMessage())
	}
}

extension JobDetailViewController: JobDetailView {
	func setJobDetails(title: String, company: String, location: String, salary: String, detail: String, date: String) {
		self.jobTitle.text = title
		self.compnay.text = company
		self.location.text = location
		self.salary.text = salary
		salaryView.isHidden = salary.isEmpty
		self.detail.text = detail
		self.date.text = date
	}
}
