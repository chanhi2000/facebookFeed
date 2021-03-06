//
//  Location.swift
//  facebookFeed
//
//  Created by LeeChan on 12/13/20.
//  Copyright © 2020 MarkiiimarK. All rights reserved.
//

import Foundation

struct Location : Decodable {
    let city: String
    let state: String
}

extension Location: Hashable {}
