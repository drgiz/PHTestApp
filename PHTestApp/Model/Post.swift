//
//  Post.swift
//  PHTestApp
//
//  Created by Svyatoslav Bykov on 03.08.17.
//  Copyright © 2017 Svyatoslav Bykov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Post {
    let category_id: Int
    let comments_count: Int
    let day: String
    let id: Int
    let name: String
    let tagline: String
    let created_at: String
    let discussion_url: String
    let redirect_url: String
    let screenshot_url_350px: String
    let screenshot_url_850px: String
    let thumbnail_url: String
    let votes_count: Int
    
    init (json:JSON) {
        category_id = json["category_id"].intValue
        comments_count = json["comments_count"].intValue
        day = json["day"].stringValue
        id = json["id"].intValue
        name = json["name"].stringValue
        tagline = json["tagline"].stringValue
        created_at = json["created_at"].stringValue
        discussion_url = json["discussion_url"].stringValue
        redirect_url = json["redirect_url"].stringValue
        screenshot_url_350px = json["screenshot_url"]["350px"].stringValue
        screenshot_url_850px = json["screenshot_url"]["850px"].stringValue
        thumbnail_url = json["thumbnail"]["image_url"].stringValue
        votes_count = json["votes_count"].intValue
    }
}
