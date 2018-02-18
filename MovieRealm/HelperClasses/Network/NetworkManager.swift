//
//  NetworkManager.swift
//  MovieRealm
//
//  Created by Siddhant Jain on 17/02/18.
//  Copyright © 2018 Siddhant. All rights reserved.
//

import UIKit
import Alamofire
import Reachability

class NetworkManager: NSObject {
    // MARK: - Variables
    var isReachable = false
    fileprivate var reachability: Reachability?

    // MARK: - Initialize Methods
    class var sharedInstance: NetworkManager {
        struct Static {
            static var instance: NetworkManager?
            static var token: Int = 0
        }
        if Static.instance == nil {
            Static.instance = NetworkManager()
        }
        return Static.instance!
    }
    
    override init() {
        super.init()
        reachability = Reachability.init()
        isReachable = reachability?.connection != .none
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability!.startNotifier()
        } catch {
        }
    }
    
    // MARK: - Request Method
    func requestFor(path: String, param: [String: Any]?, httpMethod: HTTPMethod, includeHeader: Bool, success:@escaping (_ response: [String: Any]) -> Void, failure:@escaping (_ response: [String: Any], _ error: Error?) -> Void) {
        
        var completeURL = Constant.serverURL + path
        completeURL = completeURL.replacingOccurrences(of: " ", with: "%20")
       // let headerParam: HTTPHeaders?
//        if includeHeader {
//            headerParam = ["Authorization": "Bearer FlochatIosTestApi"
//            ]
//        }
        if isReachable {
            Alamofire.request(completeURL, method: httpMethod, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                debugPrint(response)
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? [String: Any] {
                        success(responseDict)
                    } else {
                        failure(["title": "Error", "message": "Oops! Something went wrong."], response.result.error)
                    }
                case .failure:
                    if let responseDict = response.result.value as? [String: Any] {
                        failure(responseDict, response.result.error)
                    } else {
                        failure(["title": "Error", "message": "Oops! Something went wrong."], response.result.error)
                    }
                }
            }
        } else {
            failure(["title": "No Internet!", "message": "Please check your Internet connection."], nil)
        }
    }

    // MARK: - Rechability
    @objc func reachabilityChanged(_ notification: Notification) {
        if let reachability = notification.object as? Reachability, reachability.connection != .none {
            isReachable = true
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
           
        } else {
            isReachable = false
            UIApplication.shared.keyWindow?.currentViewController()?.showAlert(title: "No Internet Connection", message: "", buttons: ["Okay"], actions: nil)
        }
    }
}
