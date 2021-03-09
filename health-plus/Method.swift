//
//  Method.swift
//  health-plus
//
//  Created by Yo Higashida on 2021/03/09.
//

import Foundation

class Method {
    class func empty(_ str: String?) -> Bool {
        if str == nil {
            return true
        } else if str!.isEmpty {
            return true
        } else {
            return false
        }
    }
}
