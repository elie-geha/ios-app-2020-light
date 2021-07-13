//
//  ProfileViewController.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 13/07/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage

class ProfileViewController: UIViewController {

	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var emailInitial: UILabel!
	@IBOutlet weak var email: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

		if let user = Auth.auth().currentUser {
			email.text = user.email
			profileImage.sd_setImage(with: user.photoURL)
			emailInitial.isHidden = user.photoURL != nil
			emailInitial.text = String(user.email?.first ?? "A").uppercased()
		}
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

	func present(from viewController: UIViewController) {
		viewController.modalPresentationStyle = .fullScreen
		viewController.present(self, animated: true) { [weak self] in
			guard let self = self else { return }
			DispatchQueue.main.asyncAfter(deadline: .now()+1) { [weak self] in
				guard let self = self else { return }
//				self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.makeSlidingImages), userInfo: nil, repeats: true)
//				self.timer?.fire()
			}
		}
	}

}
