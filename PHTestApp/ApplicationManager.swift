//
//  ApplicationManager.swift
//  PHTestApp
//
//  Created by Svyatoslav Bykov on 02.08.17.
//  Copyright © 2017 Svyatoslav Bykov. All rights reserved.
//

import Foundation
import Alamofire

class ApplicationManager {
    static let shared = ApplicationManager()
    let networkManager: NetworkManager
    let baseURL = "https://api.producthunt.com/v1/"
    let access_token = "591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff"
    
    private init() {
        self.networkManager = NetworkManager()
    }
    
    func getPostsFeed(withCategory: Int? = nil, numberOfPosts: Int? = nil, response: @escaping (_ response: DataResponse<Any>) -> Void) {
        let url = baseURL+"posts"
        var parameters = ["sort_by":"created_at",
                          "order":"asc",
                          "access_token":access_token]
        if let category = withCategory {
            parameters["search[category]"] = String(category)
        }
        if let numberOfPosts = numberOfPosts {
            parameters["per_page"] = String(numberOfPosts)
        }
        networkManager.requestWithParameters(url: url, parameters: parameters, response: response)
    }
    
}
