//
//  Result.swift
//  VFPoC
//
//  Created by Sergey Gorin on 04/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
}

enum LoadingState {
    case started
    case finished(Result<()>)
    case canceled
}

enum Change {
    
    struct Diff {
        let deleted: [IndexPath]
        let inserted: [IndexPath]
        let updated: [IndexPath]
        
        var isEmpty: Bool {
            return deleted.isEmpty && inserted.isEmpty && updated.isEmpty
        }
        
        let isJustSignal: Bool
        
        static let justSignal = Diff(justAsSignal: true)
        static let none = Diff()
        
        init(deleted: [IndexPath] = [], inserted: [IndexPath] = [], updated: [IndexPath] = []) {
            self.deleted = deleted
            self.inserted = inserted
            self.updated = updated
            self.isJustSignal = false
        }
        
        private init(justAsSignal: Bool) {
            self.deleted = []
            self.inserted = []
            self.updated = []
            self.isJustSignal = true
        }
    }
    
    case startedLoading
    case finishedLoading(Result<()>)
    case canceled
    case changedData
}
