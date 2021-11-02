//
//  HomeCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import SVProgressHUD
import UIKit
import FirebaseAuth
import FBSDKShareKit

class HomeCoordinator: NSObject, CoordinatorType {
//    var onShare: (() -> Void)?
    var onMenu: (() -> Void)?

    private var router: UINavigationController
    private var context: AppContext

    private var placesCoordinator: PlacesCoordinator?

    private var homeViewController: HomeViewController?

    init(with router: UINavigationController, context: AppContext) {
        self.router = router
        self.context = context
    }

    func start() {

		navigateToHome()
//		if Auth.auth().currentUser == nil {
//			DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
//				self?.navigateToLogin()
//			}
//		}

    }

	var isLoggedIn: Bool {Auth.auth().currentUser != nil}
	private func navigateToHome() {

		homeViewController = Storyboard.Home.homeVC
		homeViewController?.title = context.countriesRepository.currentCity?.name

		updateBanners()

		homeViewController?.menuItems =
		[
			MenuItem(type: .metroPlan, onSelect: { [weak self] in
//				guard self?.isLoggedIn ?? false else {
//					self?.navigateToLogin()
//					return
//				}
				self?.openMetroPlan()
			}),
			MenuItem(type: .locateMetro, onSelect: { [weak self] in
//				guard self?.isLoggedIn ?? false else {
//					self?.navigateToLogin()
//					return
//				}
				self?.openLocateMetro()
			}),
            MenuItem(type: .restoraunts, onSelect: { [weak self] in
//                guard self?.isLoggedIn ?? false else {
//                    self?.navigateToLogin()
//                    return
//                }
                self?.openPlaces(with: .restoraunt)
            }),
			MenuItem(type: .boutiques, onSelect: { [weak self] in
//				guard self?.isLoggedIn ?? false else {
//					self?.navigateToLogin()
//					return
//				}
				self?.openPlaces(with: .boutique)
			}),
            MenuItem(type: .attractions, onSelect: { [weak self] in
//                guard self?.isLoggedIn ?? false else {
//                    self?.navigateToLogin()
//                    return
//                }
                self?.openPlaces(with: .attraction)
            }),
			MenuItem(type: .beautyAndHealth, onSelect: { [weak self] in
//				guard self?.isLoggedIn ?? false else {
//					self?.navigateToLogin()
//					return
//				}
				self?.openPlaces(with: .beautyAndHealth)
			}),
			MenuItem(type: .jobsInCity, onSelect: { [weak self] in
				self?.openJobList()
				/*
                let items: [Any] = ["Discover interesting places around metro stations. Available in more the 70+ cities. Download the Free App Here", URL(string: "https://apps.apple.com/us/app/id1276636784")!]
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                if (ac.popoverPresentationController != nil) {
//                    ac.popoverPresentationController?.sourceView = router.
                }
                self?.router.present(ac, animated: true)*/
                
			}),
			MenuItem(type: .appsWeLove, onSelect: { [weak self] in
				self?.showOfferWall()
//				guard self?.isLoggedIn ?? false else {
//					self?.navigateToLogin()
//					return
//				}
//				self?.openPlaces(with: .beautyAndHealth)
			})
		]
//		homeViewController?.logout =  { [weak self] in
//			self?.navigateToLogin()
//		}
		homeViewController?.onLeftBarButton = onMenu
//		homeViewController?.onRightBarButton = onShare
		router.setViewControllers([homeViewController].compactMap { $0 }, animated: false)
	}

	private func showOfferWall() {
		IronSource.setOfferwallDelegate(self)
		if IronSource.hasOfferwall() {
			IronSource.showOfferwall(with: router)
		}
	}
	
	private func navigateToLogin() {
		guard let login = UIStoryboard(name: "Auth", bundle: .main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {return}
		let nav = UINavigationController(rootViewController: login)
		nav.setNavigationBarHidden(true, animated: false)
//		nav.modalPresentationStyle = .fullScreen
		login.showHome = { [weak self] in
			self?.router.dismiss(animated: true, completion: nil)
		}
		router.present(nav, animated: true, completion: nil)
	}

    private func openMetroPlan() {
        let vc = Storyboard.Home.metroPlanVC
        vc.city = context.countriesRepository.currentCity
        vc.title = context.countriesRepository.currentCity?.name
        router.pushViewController(vc, animated: true)
    }

	private func openJobList() {
		let vc = Storyboard.Job.jobList
		let viewModel = AllJobListViewModel(view: vc)

		let reachibility = NetworkReachibility()
		let service = JobServiceWithFallbackToLocalData(remote: JobRemoteService(), local: JobLocalService(), reachibility: reachibility)
		let usecase = AllJobListUsecase(viewModel: viewModel, service: service, city: context.countriesRepository.currentCity?.name ?? "", reachibility: reachibility)

		vc.usecase = usecase
		vc.share = { [weak self] (job) in
			guard let self = self else {return}
			let content = self.shareContent(job: job)
			self.showFacebookShare(msg: content.1, url: content.0)
		}

		vc.shareOnFacebook = { [weak self] job in
			guard let self = self else {return}
			let content = self.shareContent(job: job)
			self.showActivityController(items: [content.1,content.0])
		}

		vc.showDetail = { [weak self] job in

		}

		router.pushViewController(vc, animated: true)
	}

	private func shareContent(job: Job) -> (URL,String){
		let url = URL(string: "https://apps.apple.com/us/app/id1276636784")!
		let message = "I found this Job Offer: (\(job.title)) on Around the Metro. Download the App for Free and find your dream job today."
		return (url,message)
	}

	private func showFacebookShare(msg: String, url: URL) {
		// Same as previous session
//		let image = UIImage(named: "AppIcon")!
//		let photo = SharePhoto(image: image, userGenerated: true)
//		let photoContent = SharePhotoContent()
//		photoContent.photos = [photo]
		let textContent = ShareLinkContent()
		textContent.quote = msg
		textContent.contentURL = url
		textContent.hashtag = Hashtag("#aroundthemetro")

		// Share the content (photo) as a dialog with News Feed / Story
		let sharingDialog = ShareDialog.init(fromViewController: router, content: textContent, delegate: self)
		sharingDialog.show()
	}

	private func showActivityController(items: [Any]) {
		let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
		self.router.present(ac, animated: true)
	}

    private func openLocateMetro() {
        guard let country = context.countriesRepository.currentCountry,
            let city = context.countriesRepository.currentCity else { return }

        SVProgressHUD.show()

        context.metroLocationsRepository.getMetroLocations(
            country: country,
            city: city) { [weak self] result in
                switch result {
                case .success(let stations):
                    SVProgressHUD.dismiss()
                    let vc = Storyboard.Home.locateMetroVC
                    vc.stations = stations
                    vc.title = city.name
                    self?.router.pushViewController(vc, animated: true)
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    SVProgressHUD.dismiss(withDelay: 3.0)
                }
        }
    }

    private func openPlaces(with placeType: PlaceType) {
        placesCoordinator = PlacesCoordinator(with: router, context: context, type: placeType)
        placesCoordinator?.start()
    }

    func updateBanners() {
        guard let country = context.countriesRepository.currentCountry,
            let city = context.countriesRepository.currentCity else { return }

        context.bannersRepository.getBanners(country: country, city: city, with: { [weak self] result in
            switch result {
            case .success(let banners):
                self?.homeViewController?.banners = banners
            case .failure(_):
                // TODO: Handle error
                break
            }
        })
    }
}

extension HomeCoordinator: ISOfferwallDelegate {
	func offerwallHasChangedAvailability(_ available: Bool) {
//		if available {
//			IronSource.showOfferwall(with: self)
//		}else {
//			confirmLocation()
//		}
	}

	func offerwallDidShow() {

	}

	func offerwallDidFailToShowWithError(_ error: Error!) {

	}

	func offerwallDidClose() {

	}

	func didReceiveOfferwallCredits(_ creditInfo: [AnyHashable : Any]!) -> Bool {
		return true
	}

	func didFailToReceiveOfferwallCreditsWithError(_ error: Error!) {

	}
}

//MARK:- SharingDelegate
extension HomeCoordinator: SharingDelegate {
	func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {

	}

	func sharer(_ sharer: Sharing, didFailWithError error: Error) {

	}

	func sharerDidCancel(_ sharer: Sharing) {

	}


}
