//
//  NetworkManager.swift
//  PHTestApp
//
//  Created by Svyatoslav Bykov on 02.08.17.
//  Copyright © 2017 Svyatoslav Bykov. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    func request(url: URL, response: @escaping (_ response: DataResponse<Any>) -> Void) {
        Alamofire.request(url).validate().responseJSON(completionHandler: response)
    }
    
    func requestWithParameters (url: URL, parameters:[String:Any], response: @escaping (_ response: DataResponse<Any>) -> Void){
        Alamofire.request(url, parameters: parameters).validate().responseJSON(completionHandler: response)
    }
}
