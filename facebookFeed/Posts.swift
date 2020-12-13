//
//  Posts.swift
//  facebookFeed
//
//  Created by LeeChan on 8/25/16.
//  Copyright © 2016 MarkiiimarK. All rights reserved.
//

import UIKit

class Post: SafeJsonObject {
    var name: String?
    var profileImageName: String?
    var statusText: String?
    var statusImageName: String?
    var statusImageUrl: String?
    var numLikes: NSNumber?
    var numComments: NSNumber?
    
    var location: Location?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "location" {
            location = Location()
            location?.setValuesForKeys(value as! [String: AnyObject])
        } else {
            super.setValue(value, forKey: key)
        }
    }
}

class SafeJsonObject: NSObject {
    
    override func setValue(_ value: Any?, forKey key: String) {
        let selectorString = "set\(key.uppercased().first!)\(String(key.dropFirst())):"
        let selector = Selector(selectorString)
        if responds(to: selector) {
            super.setValue(value, forKey: key)
        }
    }
}
class Location: NSObject {
    var city: String?
    var state: String?
}

class Feed: SafeJsonObject {
    var feedUrl, title, link, author, type: String?
}
