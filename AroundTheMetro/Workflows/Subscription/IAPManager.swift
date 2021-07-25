//
//  IAPManager.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 23/06/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import Foundation
import StoreKit
import AppReceiptValidator
import SVProgressHUD

// IAPManager.IAPManagerError
extension IAPManager.IAPManagerError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .noProductIDsFound: return "No In-App Purchase product identifiers were found."
		case .noProductsFound: return "No In-App Purchases were found."
		case .productRequestFailed: return "Unable to fetch available In-App Purchase products at the moment."
		case .paymentWasCancelled: return "In-App Purchase process was cancelled."
		case .transactionReceiptNotFound: return "Transaction was failed."
		case .subscriptionExpired: return "Subscription is expired"
		}
	}
}

class IAPManager: NSObject {

	enum IAPManagerError: Error {
		///It indicates that the product identifiers could not be found
		case noProductIDsFound
		///No IAP products were returned by the App Store because none was found
		case noProductsFound
		///The user cancelled an initialized purchase process
		case paymentWasCancelled
		///The app cannot request App Store about available IAP products for some reason.
		case productRequestFailed
		///in the receipt there was no entry for the transaction
		case transactionReceiptNotFound
		case subscriptionExpired
	}

	static let shared = IAPManager()
	private var onReceiveProductsHandler: ((Result<[SKProduct], IAPManagerError>) -> Void)?
	var onBuyProductHandler: ((Result<String, Error>) -> Void)?

	private override init() {
		super.init()
	}

	deinit {
		self.stopObserving()
	}

	//MARK:- Fetch Products
	private func getProductIDs() -> [String]? {
		/*//get file url
		guard let url = Bundle.main.url(forResource: "IAP_ProductIDs", withExtension: "plist") else { return nil }
		//read data
		do {
			let data = try Data(contentsOf: url)
			let productIDs = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? [String] ?? []
			return productIDs
		} catch {
			print(error.localizedDescription)
			return nil
		}*/
		return [IAPManager.MONTHLY_SUBSCRIPTION_ID, IAPManager.YEARLY_SUBSCRIPTION_ID]
	}

	func getProducts(withHandler productsReceiveHandler: @escaping (_ result: Result<[SKProduct], IAPManagerError>) -> Void) {
		onReceiveProductsHandler = productsReceiveHandler

		//get products id
		guard let productIDs = getProductIDs() else {
			productsReceiveHandler(.failure(.noProductIDsFound))
			return
		}

		//request
		let productIdList = Set(productIDs)
		let request = SKProductsRequest(productIdentifiers: productIdList)
		request.delegate = self
		request.start()
	}
}

//SKProductsRequestDelegate
extension IAPManager: SKProductsRequestDelegate {

	func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
		let products = response.products
		DispatchQueue.main.async { [weak self] in
			if products.count > 0 {
				self?.onReceiveProductsHandler?(.success(products))
			} else {
				self?.onReceiveProductsHandler?(.failure(.noProductsFound))
			}
		}
	}

	func request(_ request: SKRequest, didFailWithError error: Error) {
		DispatchQueue.main.async { [weak self] in
			self?.onReceiveProductsHandler?(.failure(.productRequestFailed))
		}
	}

	func requestDidFinish(_ request: SKRequest) { }
}

//SKProduct
extension SKProduct {
	var priceFormatted: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.locale = self.priceLocale
		return formatter.string(from: self.price) ?? ""
	}
}

//MARK:- Buy Product
extension IAPManager: SKPaymentTransactionObserver {

	func startObserving() {
		SKPaymentQueue.default().add(self)
	}

	private func stopObserving() {
		SKPaymentQueue.default().remove(self)
	}

	var canMakePayments: Bool {
		SKPaymentQueue.canMakePayments()
	}

	func buy(product: SKProduct, withHandler handler: @escaping ((_ result: Result<String, Error>) -> Void)) {

		SKPaymentQueue.default().remove(self)
		SKPaymentQueue.default().add(self)
		
		let payment = SKPayment(product: product)
		SKPaymentQueue.default().add(payment)

		// Keep the completion handler.
		onBuyProductHandler = handler
	}

	func restore(withHandler handler: @escaping ((_ result: Result<String, Error>) -> Void)) {

		SKPaymentQueue.default().remove(self)
		SKPaymentQueue.default().add(self)

		SKPaymentQueue.default().restoreCompletedTransactions()

		// Keep the completion handler.
		onBuyProductHandler = handler
	}

	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {

		transactions.forEach { (transaction) in
			DispatchQueue.main.async { [weak self] in
				guard let self = self else {return}

				switch transaction.transactionState {
				case .purchased, .restored:
					//switch self.verify(productIdentifier: transaction.payment.productIdentifier) {
					//case .success(_):
//						self.saveSubscription()

						self.onBuyProductHandler?(.success(transaction.payment.productIdentifier))
					//case .failure(let error):
					//	self.onBuyProductHandler?(.failure(error))
				//	}
					SKPaymentQueue.default().finishTransaction(transaction)
				case .failed:
					if let error = transaction.error as? SKError {
						if error.code != .paymentCancelled {
							self.onBuyProductHandler?(.failure(error))
						} else {
							self.onBuyProductHandler?(.failure(IAPManagerError.paymentWasCancelled))
						}
						print("IAP Error:", error.localizedDescription)
					}
					SKPaymentQueue.default().finishTransaction(transaction)
				case .deferred, .purchasing: break
				@unknown default: break
				}
			}
		}
	}

	func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {

		SVProgressHUD.dismiss()
		if queue.transactions.isEmpty {
			self.onBuyProductHandler?(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "No Purchases Found"])))
			return
		}
		for transaction: SKPaymentTransaction in queue.transactions as [SKPaymentTransaction] {
			let result = self.verify(productIdentifier: transaction.transactionIdentifier ?? "")
			switch result {
			case .success(_):
				productID = transaction.payment.productIdentifier
				self.onBuyProductHandler?(.success(transaction.payment.productIdentifier))
			case .failure(let error):
				self.onBuyProductHandler?(.failure(error))
			}
		}

		if (isSubscribed) {
			// do nothing
		} else {
			//NotificationManager.sharedInstance.showNotification(message: "Nothing to restore")
		}
	}
}

//MARK:- Verify Transaction
extension IAPManager {

	func verify(productIdentifier: String) -> Result<InAppPurchaseReceipt,Error> {
		let validation = AppReceiptValidator().validateReceipt()
		switch validation {
		case .success(let reciept,_,_):
			var expiryDate: Date?
			var subscriptionReceipt: InAppPurchaseReceipt?
			for inAppPurchaseReceipt in reciept.inAppPurchaseReceipts {
				if inAppPurchaseReceipt.productIdentifier == productIdentifier {
					expiryDate = inAppPurchaseReceipt.subscriptionExpirationDate
					subscriptionReceipt = inAppPurchaseReceipt
				}
			}
			guard let expiry = expiryDate?.timeIntervalSince1970, let receiptValue = subscriptionReceipt else {
				return .failure(IAPManagerError.transactionReceiptNotFound)
			}

//			let expiry = expiry?.timeIntervalSince1970 ?? 0.0

			if expiry >= Date().timeIntervalSince1970 {
				return .success(receiptValue)
			}else {
				return .failure(IAPManagerError.subscriptionExpired)
			}

			/*
			for inAppPurchaseReceipt in reciept.inAppPurchaseReceipts {
				guard inAppPurchaseReceipt.transactionIdentifier == transactionIdentifier else {
					continue
				}
				let expiry = inAppPurchaseReceipt.subscriptionExpirationDate?.timeIntervalSince1970 ?? 0.0

				if expiry >= Date().timeIntervalSince1970 {
					return .success(inAppPurchaseReceipt)
				}else {
					return .failure(IAPManagerError.subscriptionExpired)
				}
			}
			return .failure(IAPManagerError.transactionReceiptNotFound)
*/
		case .error(let error,_, _):
			return .failure(error)
		}
	}
}

//MARK: Store In App Purchase
extension IAPManager {
	private static let PRODUCT = "PRODUCT"
	static let MONTHLY_SUBSCRIPTION_ID = "com.AugmentedDiscovery.monthly"
	static let YEARLY_SUBSCRIPTION_ID = "com.AugmentedDiscovery.yearly.subscription"
	static let SUBSCRIPTION_UPDATED_NOTIFICATION = "SUBSCRIPTION_UPDATED_NOTIFICATION"
//	private static let SUBSCRIPTION_EXPIRED_DATE = "SUBSCRIPTION_EXPIRED_DATE"
	var isSubscribed: Bool {
		return !productID.isEmpty
	}

	/*
	var subscriptionExpiredDate: Date?  {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		let dateString = UserDefaults.standard.string(forKey: IAPManager.SUBSCRIPTION_EXPIRED_DATE) ?? ""
		return formatter.date(from: dateString)
	}

	func setSubscriptionExpiredDate(_ date: Date?) {

		//delete record if date is nil
		guard let date = date else {
			return UserDefaults.standard.removeObject(forKey: IAPManager.SUBSCRIPTION_EXPIRED_DATE)
		}

		// save expired date
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		UserDefaults.standard.setValue(formatter.string(from: date), forKey: IAPManager.SUBSCRIPTION_EXPIRED_DATE)
	}*/

	var productID: String {
		get {
			UserDefaults.standard.string(forKey: IAPManager.PRODUCT) ?? ""
		}set {
			UserDefaults.standard.setValue(newValue, forKey: IAPManager.PRODUCT)
			NotificationCenter.default.post(name: Notification.Name(IAPManager.SUBSCRIPTION_UPDATED_NOTIFICATION), object: nil)
		}
	}

	func deleteSubscription() {
		UserDefaults.standard.removeObject(forKey: IAPManager.PRODUCT)
	}
}


//MARK:- Update Server
extension IAPManager {
/*
	func upgradeMemberShip(){
		guard Connectivity.isConnectedToNetwork() else {return}
		let accessToken = AppInstance.instance.accessToken ?? ""
		let userid = AppInstance.instance.userId ?? 0

		Async.background({
			UpgradeMemberShipManager.instance.upgradeMemberShip(userId: userid, AccessToken: accessToken, completionBlock: { (success, sessionError, error) in
				if success != nil{
					Async.main({
						AppInstance.instance.userProfile?.data?.isPro = 1
					})
				}else if sessionError != nil{
					Async.main({
						log.error("sessionError = \(sessionError?.error ?? "")")
					})
				}else {
					Async.main({
						log.error("error = \(error?.localizedDescription ?? "")")
					})
				}
			})
		})
	}*/
}
