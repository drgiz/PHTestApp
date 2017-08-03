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
    
    private init() {
        self.networkManager = NetworkManager()
    }
    
    func getCollectionsFeed(response: @escaping (_ response: DataResponse<Any>) -> Void) {
        guard let url = URL(string: "https://api.producthunt.com/v1/posts?sort_by=created_at&order=asc&access_token=591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff&search[category]=1&per_page=10") else { return }
        networkManager.request(url: url, response: response)
    }
    
    
}
