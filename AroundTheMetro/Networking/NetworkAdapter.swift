//
//  NetworkAdapter.swift
//  Login-ATM
//
//  Created by Siamak Eshghi on 2017-12-25.
//  Copyright © 2017 SiamakEshghi. All rights reserved.
//

import Moya

struct NetworkAdapter {
    static let provider = MoyaProvider<UndergroundTarget>()
    
    static func request(target: UndergroundTarget,
                        success successCallback: @escaping (_ data: Data) -> Void,
                        error errorCallback: ((Swift.Error) -> Void)?,
                        failure failureCallback: ((MoyaError) -> Void)?) {
        provider.request(target) { (result) in
            switch result {
            case .success(let response):
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    successCallback(response.data)
                } else {
                    let error = NSError(domain:"com.AugmentedDiscovery.AroundTheMetro.networkLayer",
                                        code: 0,
                                        userInfo:[NSLocalizedDescriptionKey: "HTTP Error"])
                    print("Error Network Status: \(error.localizedDescription)")
                errorCallback?(error)
                }
            case .failure(let error):
                print("Network request failure: \(String(describing: error.errorDescription))")
                failureCallback?(error)
            }
        }
    }
}
