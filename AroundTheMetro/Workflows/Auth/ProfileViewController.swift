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
    @IBOutlet weak var currentCity: UILabel!
    
    var city: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
		if let user = Auth.auth().currentUser {
			email.text = user.email
            
			profileImage.sd_setImage(with: user.photoURL)
			emailInitial.isHidden = user.photoURL != nil
			emailInitial.text = String(user.email?.first ?? "A").uppercased()
		}

		let logout = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(actLogout))
		self.navigationItem.rightBarButtonItem = logout
        
        currentCity.text = city
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
	}
   
	@objc private func actLogout() {
		showConfirmationAlert()
	}

	private func showConfirmationAlert() {
		let okay = UIAlertAction(title: "Okay", style: .default) { [weak self] (_) in
			do {
				try Auth.auth().signOut()
				self?.navigationItem.rightBarButtonItems = []
				NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: Constants.LOGIN_UPDATED)))
			}catch {

			}
		}
		let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
		let alert = UIAlertController(title: "Do you want to logout of app?", message: "", preferredStyle: .alert)
		alert.addAction(okay)
		alert.addAction(cancel)
		self.present(alert, animated: true, completion: nil)
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
