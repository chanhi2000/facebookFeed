//
//  Reusable.swift
//  facebookFeed
//
//  Created by LeeChan on 12/13/20.
//  Copyright © 2020 MarkiiimarK. All rights reserved.
//

import Foundation

public protocol Reusable: AnyObject {
    static var reuseIdentifier: String {get}
}

public extension Reusable {
    static var reuseIdentifier: String {
        String(reflecting: self)
    }
}
