//
//  Collection.swift
//  PHTestApp
//
//  Created by Svyatoslav Bykov on 01.08.17.
//  Copyright © 2017 Svyatoslav Bykov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Collection {
    let id: Int
    let name: String
    let title: String
    let created_at: String
    let updated_at: String
    let featured_at: String
    let subscriber_count: Int
    let category_id: Int
    let collection_url: String
    let posts_count: Int
    let user:User
    let background_image_url:String
    let color:String

init (json:JSON) {
    id = json["id"].intValue
    name = json["name"].stringValue
    title = json["title"].stringValue
    created_at = json["created_at"].stringValue
    updated_at = json["updated_at"].stringValue
    featured_at = json["featured_at"].stringValue
    subscriber_count = json["subscriber_count"].intValue
    category_id = json["category_id"].intValue
    collection_url = json["collection_url"].stringValue
    posts_count = json["posts_count"].intValue
    user = User(json:json["user"] as JSON)
    background_image_url = json["background_image_url"].stringValue
    color = json["color"].stringValue
}

}



