//
//  SubScriptionViewController.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 23/06/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import UIKit
import StoreKit
import SVProgressHUD
import SafariServices

struct SlideItem {
    let icon: UIImage?
    let title: String
}

class SubScriptionViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var monthlySubscriptionView: UIView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var monthlyPrice: UILabel!
    @IBOutlet var yearlyPrice: UILabel!
    @IBOutlet var yearlySubscriptionPricePerMonth: UILabel!
    @IBOutlet var termsButton: UIButton!
    @IBOutlet var privacyPolicyButton: UIButton!
    
    
    // MARK: - Properties
    var slideData = [SlideItem]() {
        didSet {
            pageControl.numberOfPages = slideData.count
            collectionView.reloadData()
        }
    }
    
    // MARK: - Callbacks
    
    var onFinish: (() -> Void)?
    var onSkip: (() -> Void)?
    
    // MARK: - Private variables
    private var products = [SKProduct]()
    
    // MARK: - LyfeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure screen ui
        customizeUI()
        
        //set slide data
        slideData = getSliderData()
        
        //get products
        fetchProducts()
    }
    
    // MARK: - UI
    private func customizeUI() {
        configureCollectionView()
        
        monthlySubscriptionView.layer.borderColor = UIColor(hex: "#2F8146")?.cgColor
        
        termsButton.setAttributedTitle(underlinedText("Terms of Use"), for: .normal)
        privacyPolicyButton.setAttributedTitle(underlinedText("Privacy Policy"), for: .normal)
    }
    
    private func underlinedText(_ text: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    private func showProgress(msg: String) {
        //		SVProgressHUD.show(UIImage(), status: msg)
        SVProgressHUD.showProgress(100, status: msg)
    }
    
    private func configureCollectionView() {
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor(hex: "#707070")?.cgColor
    }
    
    //MARK:- Data
    private func getSliderData() -> [SlideItem] {
        let item1 = SlideItem(icon: UIImage(named: "image1"), title: "paymentSlidertitle1".localized)
        let item2 = SlideItem(icon: UIImage(named: "image2"), title: "paymentSlidertitle2".localized)
        let item3 = SlideItem(icon: UIImage(named: "image3"), title: "paymentSlidertitle3".localized)
        let item4 = SlideItem(icon: UIImage(named: "image4"), title: "paymentSlidertitle4".localized)
        let item5 = SlideItem(icon: UIImage(named: "image5"), title: "paymentSlidertitle5".localized)
        //		let item6 = SlideItem(icon: UIImage(named: "image6"), title: "Title 6")
        return [item1,item2,item3,item4,item5]
    }
    
    private func fetchProducts() {
        self.showProgress(msg: "Loading Products ...")
        IAPManager.shared.getProducts { [weak self] (result) in
            guard let self = self else {return}
            SVProgressHUD.dismiss()
            switch result {
            case .success(let products):
                self.configureProducts(products: products)
            //				self.products = products
            //				let price = products.first?.priceFormatted ?? ""
            //				self.productPrice.text = price + " per month"
            case .failure(let error):
                SVProgressHUD.showError(withStatus: error.errorDescription)
            //				self.view.makeToast(error.errorDescription)
            }
        }
    }
    
    ///set product info
    private func configureProducts(products: [SKProduct]) {
        self.products = products
        for product in products {
            if product.productIdentifier == IAPManager.MONTHLY_SUBSCRIPTION_ID {
                monthlyPrice.text = product.priceFormatted + " / month"
            } else if product.productIdentifier == IAPManager.YEARLY_SUBSCRIPTION_ID {
                yearlyPrice.text = product.priceFormatted + " / yearly"
                
                let monthPrice = Double(truncating: product.price) / 12
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.locale = product.priceLocale
                yearlySubscriptionPricePerMonth.text = "(or "+(formatter.string(from: NSNumber(value: monthPrice)) ?? "") + " / month)"
            }
        }
    }
    
    private func buyProduct(_ product: SKProduct) {
        SVProgressHUD.show()
        IAPManager.shared.buy(product: product) { [weak self] (result) in
            guard let self = self else {return}
            SVProgressHUD.dismiss()
            switch result {
            case .success(let productId):
                //save subscription
                IAPManager.shared.productID = productId
                self.dismiss(animated: true, completion: nil)
            //				self.onFinish?()
            case .failure(let error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func buyYearlySubscription() {
        let result = products.filter{$0.productIdentifier == IAPManager.YEARLY_SUBSCRIPTION_ID}
        guard let product = result.first else {
            return
        }
        
        buyProduct(product)
    }
    
    @IBAction func buyMonthlySubscription() {
        let result = products.filter{$0.productIdentifier == IAPManager.MONTHLY_SUBSCRIPTION_ID}
        guard let product = result.first else {
            return
        }
        
        buyProduct(product)
    }
    
    @IBAction func exitScene(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //		onSkip?()
    }
    
    @IBAction func share(_ sender: Any) {
        let items: [Any] = ["Discover interesting places around metro stations. Available in more the 70+ cities. Download the Free App Here", URL(string: "https://apps.apple.com/us/app/id1276636784")!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @IBAction func terms(_ sender: Any) {
        open(url: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"))
    }
    
    @IBAction func privacyPolicy(_ sender: Any) {
        open(url: URL(string: "https://ad.aroundthemetro.com/privacy/"))
    }
    
    private func open(url: URL?) {
        if let url = url {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            self.present(vc, animated: true)
        }
    }
    
    //MARK:- Navigation
    func present(from viewController: UIViewController) {
        
        viewController.present(self, animated: true)
    }
}

//MARK:- UICollectionViewDataSource
extension SubScriptionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slideData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubscriptionCell.reuseIdentifier, for: indexPath) as! SubscriptionCell
        cell.set(item: slideData[indexPath.row])
        return cell
    }
}

//MARK:- UICollectionViewDelegate
extension SubScriptionViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        pageControl.currentPage = index
    }
}
