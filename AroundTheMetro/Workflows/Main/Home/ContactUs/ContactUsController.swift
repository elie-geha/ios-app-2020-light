//
//  ContactUsController.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 21.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import MessageUI
import SVProgressHUD
import UIKit

class ContactUsController: NSObject {
    func present(from viewController: UIViewController) {
        guard MFMailComposeViewController.canSendMail() else {
            SVProgressHUD.showError(withStatus: "no_mail".localized)
            SVProgressHUD.dismiss(withDelay: 3.0)
            return
        }

        let contactUsVC = MFMailComposeViewController()
        contactUsVC.mailComposeDelegate = self
        contactUsVC.setCcRecipients(AppConstants.ContactUs.cc)
        contactUsVC.setToRecipients([AppConstants.ContactUs.recepient])
        contactUsVC.setSubject(AppConstants.ContactUs.subject)

        viewController.present(contactUsVC, animated: true)
    }
}

extension ContactUsController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
