//
//  SKU.swift
//  VFPoC
//
//  Created by Sergey Gorin on 14/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Network

struct SKU: JSONParseable {
    let price: Price
    let discount: [Discount]
    
    public init(json: [String : Any] = [:]) {
        price = Price(json["price"])
        discount = json.get("discount", else: []).map { Discount($0) }
    }
}
