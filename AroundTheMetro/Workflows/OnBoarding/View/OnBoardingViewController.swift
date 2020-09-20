//
//  OnBoardingViewController.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 01.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet var stepImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var pageControl: UIPageControl!

    @IBOutlet var actionButton: UIButton!

    // MARK: - Properties

    var steps: [OnBoardingStepType] = [] {
        didSet {
            currentStep = steps.first

            if isViewLoaded {
                updateUI()
            }
        }
    }

    // MARK: - Callbacks

    var onFinish: EmptyCallback?
    var onSkip: EmptyCallback?

    // MARK: - Private variables

    private var currentStep: OnBoardingStepType?

    private var currentStepIndex: Int? {
        guard let currentStep = currentStep else { return nil }

        return steps.firstIndex(of: currentStep)
    }

    // MARK: - LyfeCicle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // MARK: - Actions

    @IBAction func onNext() {
        guard let currentStepIndex = currentStepIndex, currentStepIndex != steps.count - 1 else {
            onFinish?()
            return
        }

        currentStep = steps[currentStepIndex + 1]
        updateUI()
    }

    // MARK: - Private

    private func updateUI() {
        guard let currentStep = currentStep else { return }

        pageControl.numberOfPages = steps.count
        pageControl.currentPage = currentStepIndex ?? 0

        stepImage.image = currentStep.image
        
        titleLabel.text = currentStep.title
        titleLabel.textColor = currentStep.titleColor

        descriptionLabel.text = currentStep.description

        if currentStepIndex == steps.count - 1 {
            actionButton.setTitle("onboarding.go".localized, for: .normal)
        } else {
            actionButton.setTitle("onboarding.next".localized, for: .normal)
        }
    }
}
