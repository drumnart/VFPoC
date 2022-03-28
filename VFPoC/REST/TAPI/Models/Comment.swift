//
//  Comment.swift
//  VFPoC
//
//  Created by Sergey Gorin on 13/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Network

struct Comment: JSONParseable {
    let id: Int
    let parentId: Int
    let productId: Int
    let comment: String
    
    public init(json: [String : Any] = [:]) {
        id = json.get("id")
        parentId = json.get("parentId")
        productId = json.get("productId")
        comment = json.get("comment")
    }
}
