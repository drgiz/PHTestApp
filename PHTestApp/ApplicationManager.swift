//
//  ApplicationManager.swift
//  PHTestApp
//
//  Created by Svyatoslav Bykov on 02.08.17.
//  Copyright © 2017 Svyatoslav Bykov. All rights reserved.
//

import Foundation
import Alamofire

enum Category: String {
    case Tech = "1"
    case Games = "2"
    case Podcasts = "3"
    case Books = "4"
}

class ApplicationManager {
    static let shared = ApplicationManager()
    let networkManager: NetworkManager
    let storageManager: StorageManager
    let baseURL = "https://api.producthunt.com/v1/"
    let access_token = "591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff"
    let kPosts = "posts"
    
    private init() {
        self.networkManager = NetworkManager()
        self.storageManager = StorageManager()
    }
    
    func getPostsFeed(withCategory: String? = nil, numberOfPosts: Int? = nil, response: @escaping (_ response: DataResponse<Any>) -> Void) {
        let url = baseURL+"posts"
        var parameters = ["sort_by":"created_at",
                          "order":"asc",
                          "access_token":access_token]
        if let category = withCategory {
            parameters["search[category]"] = category
        }
        if let numberOfPosts = numberOfPosts {
            parameters["per_page"] = String(numberOfPosts)
        }
        networkManager.requestWithParameters(url: url, parameters: parameters, response: response)
    }
    
    func savePosts(posts:[Post]) {
        let encodedData = posts.map{$0.propertyListRepresentation()}
        storageManager.saveDataForKey(value: encodedData, key: kPosts)
    }
    
    func loadPosts() -> [Post] {
        guard let encodedData = storageManager.loadDataForKey(key: kPosts) as? [AnyObject] else {return []}
        return encodedData.map{$0 as? [String:AnyObject]}.flatMap{Post(propertyListRepresentation: $0)}
    }
    
}
