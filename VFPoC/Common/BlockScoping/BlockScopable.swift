//
//  BlockScopable.swift
//  VFPoC
//
//  Created by Sergey Gorin on 04/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import class Foundation.NSObject

typealias BlockScopable = Appliable & Runnable

extension NSObject: BlockScopable {}

protocol Appliable {}

extension Appliable {
    
    @discardableResult
    public func apply(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
    
    @discardableResult
    public func with(_ closure: (Self) -> Void) -> Self {
        return apply(closure)
    }
}

public protocol Runnable {}

public extension Runnable {
    
    @discardableResult
    public func run<T>(_ closure: (Self) -> T) -> T {
        return closure(self)
    }
}

// Operators

infix operator <~ : AssignmentPrecedence
extension Appliable where Self: Appliable {
    static func <~ (left: Self, right: (Self) -> ()) -> Self {
        right(left)
        return left
    }
}

infix operator ~> : AssignmentPrecedence
extension Runnable where Self: Runnable {
    static func ~> <T>(left: Self, right: (Self) ->T) -> T {
        return right(left)
    }
}
