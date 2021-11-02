//
//  JobCell.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 31/10/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import UIKit

class JobCellViewModel {

	let job: Job
	var title: String {job.title}
	var company: String {job.company}
	var locations: String {"(\(job.locations))"}
	var salary: String {job.salary}
	var jobDescription: String {job.description}
	var date: String {job.date}

	init(job: Job) {
		self.job = job
	}
}

class JobCell: UITableViewCell {

	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var subtilte: UILabel!
	@IBOutlet weak var salaryView: UIView!
	@IBOutlet weak var salary: UILabel!
	@IBOutlet weak var jobDescription: UILabel!
	@IBOutlet weak var date: UILabel!
	@IBOutlet weak var card: UIView!

	var share: ((Job) -> Void)?
	var shareOnFaceboook: ((Job) -> Void)?

	var viewModel: JobCellViewModel? {
		didSet  {
			guard let vm = viewModel else {return}
			configure(viewModel: vm)
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		card.layer.applySketchShadow(color: .black, alpha: 0.3, blur: 6, spread: 0, offset: .zero)
	}

	private func configure(viewModel: JobCellViewModel) {
		self.title.text = viewModel.title
		self.subtilte.text = viewModel.company + "," + viewModel.locations
		self.salary.text = viewModel.salary
		self.salaryView.isHidden = viewModel.salary.isEmpty
		self.jobDescription.text = viewModel.jobDescription
		self.date.text = viewModel.date

	}

	@IBAction func actShare() {
		guard let job = viewModel?.job else { return }
		share?(job)
	}

	@IBAction func actShareOnFacebook() {
		guard let job = viewModel?.job else { return }
		shareOnFaceboook?(job)
	}
}
