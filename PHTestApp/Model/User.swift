//
//  User.swift
//  PHTestApp
//
//  Created by Svyatoslav Bykov on 01.08.17.
//  Copyright © 2017 Svyatoslav Bykov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {
    let id: Int
    let letcreated_at: String
    let name: String
    let username: String
    let headline: String
    let twitter_username: String
    let website_url: String
    let profile_url: String
    let image_url:[String:Any]?
    
    init (json:JSON) {
        id = json["id"].intValue
        letcreated_at = json["letcreated_at"].stringValue
        name = json["name"].stringValue
        username = json["name"].stringValue
        headline = json["headline"].stringValue
        twitter_username = json["twitter_username"].stringValue
        website_url = json["website_url"].stringValue
        profile_url = json["profile_url"].stringValue
        image_url = json["image_url"].dictionaryObject
    }
}
