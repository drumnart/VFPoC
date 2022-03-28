//
//  Currency.swift
//  VFPoC
//
//  Created by Sergey Gorin on 14/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Network

struct Currency: JSONParseable {
    let acode: String
    let precision: Int
    
    public init(json: [String : Any] = [:]) {
        acode = json.get("acode")
        precision = json.get("precision")
    }
}
