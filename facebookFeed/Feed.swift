//
//  Feed.swift
//  facebookFeed
//
//  Created by LeeChan on 12/13/20.
//  Copyright © 2020 MarkiiimarK. All rights reserved.
//

import Foundation

struct Feed {
    let feedUrl: String
    let title: String
    let link: String
    let author: String
    let type: String
}

extension Feed: SafeJsonObject {
    
}
