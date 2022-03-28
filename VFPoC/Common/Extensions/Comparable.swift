//
//  Comparable.swift
//  VFPoC
//
//  Created by Sergey Gorin on 18/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Foundation

/// Comparing with Optionals

/// Returns a Boolean value indicating whether the first value is equal to the second
public func == <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?): return l == r
    case (nil, nil): return nil == nil
    default: return false
    }
}

/// Returns a Boolean value indicating whether the first value is not equal to the second
public func != <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    return !(lhs == rhs)
}

/// Returns a Boolean value indicating whether the first value is less then the second
public func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

/// Returns a Boolean value indicating whether the first value is greater then the second
public func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

/// Returns a Boolean value indicating whether the first value is less then
/// or the same as the second
public func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}

/// Returns a Boolean value indicating whether the first value is greater then
/// or the same as the second
public func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(rhs > lhs)
    }
}
