//
//  Post.swift
//  facebookFeed
//
//  Created by LeeChan on 8/25/16.
//  Copyright © 2016 MarkiiimarK. All rights reserved.
//

import Foundation

struct Post: Decodable {
    let name: String?
    let profileImageName: String?
    let statusText: String?
    let statusImageName: String?
    let statusImageUrl: String?
    let numLikes: Int
    let numComments: Int
    let location: Location?
    
    private enum CodingKeys: String, CodingKey {
        case name, profileImageName, statusText, statusImageName, statusImageUrl, numLikes, numComments, location
    }
}

extension Post : Hashable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

//extension Post : Hashable {
//    static func == (lhs: Post, rhs: Post) -> Bool {
//        <#code#>
//    }
//}

//class SafeJsonObject: NSObject {
//    override func setValue(_ value: Any?, forKey key: String) {
//        let selectorString = "set\(key.uppercased().first!)\(String(key.dropFirst())):"
//        let selector = Selector(selectorString)
//        if responds(to: selector) {
//            super.setValue(value, forKey: key)
//        }
//    }
//}
