//
//  AssociatedObject.swift
//  VFPoC
//
//  Created by Sergey Gorin on 15/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import ObjectiveC

public struct AssociatedKey {
    fileprivate let rawValue: [CChar]
    
    init(_ rawValue: String) {
        self.rawValue = rawValue.cString(using: .utf8) ?? []
    }
}

extension NSObject {
    
    func getAssociatedObject<T>(forKey key: AssociatedKey) -> T? {
        return objc_getAssociatedObject(self, key.rawValue ) as? T
    }
    
    func setAssociatedObject<T>(_ value: T?,
                                forKey key: AssociatedKey,
                                policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        objc_setAssociatedObject(self, key.rawValue, value, policy)
    }
    
    @discardableResult
    func removeAssociatedObject<T>(forKey key: AssociatedKey) -> T? {
        defer {
            let value: T? = nil
            setAssociatedObject(value, forKey: key)
        }
        
        return getAssociatedObject(forKey: key)
    }
    
    func removeAllAssociatedObjects() {
        objc_removeAssociatedObjects(self)
    }
}

