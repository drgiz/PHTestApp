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

protocol PropertyListReadable {
    func propertyListRepresentation() -> [String:AnyObject]
    init?(propertyListRepresentation:[String:AnyObject]?)
}

extension Post: PropertyListReadable {
    func propertyListRepresentation() -> [String : AnyObject] {
        let representation:[String:AnyObject] = [
            "category_id":category_id as AnyObject,
            "comments_count":comments_count as AnyObject,
            "day":day as AnyObject,
            "id":id as AnyObject,
            "name":name as AnyObject,
            "tagline":tagline as AnyObject,
            "created_at":created_at as AnyObject,
            "discussion_url":discussion_url as AnyObject,
            "redirect_url":redirect_url as AnyObject,
            "screenshot_url_350px":screenshot_url_350px as AnyObject,
            "screenshot_url_850px":screenshot_url_850px as AnyObject,
            "thumbnail_url":thumbnail_url as AnyObject,
            "votes_count":votes_count as AnyObject]
        return representation
    }
    
    init?(propertyListRepresentation: [String : AnyObject]?) {
        guard let values = propertyListRepresentation else {return nil}
        if let category_id = values["category_id"] as? Int,
        let comments_count = values["comments_count"] as? Int,
        let day = values["day"] as? String,
        let id = values["id"] as? Int,
        let name = values["name"] as? String,
        let tagline = values["tagline"] as? String,
        let created_at = values["created_at"] as? String,
        let discussion_url = values["discussion_url"] as? String,
        let redirect_url = values["redirect_url"] as? String,
        let screenshot_url_350px = values["screenshot_url_350px"] as? String,
        let screenshot_url_850px = values["screenshot_url_850px"] as? String,
        let thumbnail_url = values["thumbnail_url"] as? String,
            let votes_count = values["votes_count"] as? Int {
            self.category_id = category_id
            self.comments_count = comments_count
            self.day = day
            self.id = id
            self.name = name
            self.tagline = tagline
            self.created_at = created_at
            self.discussion_url = discussion_url
            self.redirect_url = redirect_url
            self.screenshot_url_850px = screenshot_url_850px
            self.screenshot_url_350px = screenshot_url_350px
            self.thumbnail_url = thumbnail_url
            self.votes_count = votes_count
        } else {
            return nil
        }
    }
    
    
}
