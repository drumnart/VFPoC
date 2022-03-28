//
//  Discount.swift
//  VFPoC
//
//  Created by Sergey Gorin on 14/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Network

enum Promotype: String {
    case none
    case discount = "DISCOUNT"
    case coupon = "COUPON"
}

struct Discount: JSONParseable, PriceSpec {
    let currency: Currency
    let value: Int
    let promotype: Promotype
    
    public init(json: [String : Any] = [:]) {
        currency = Currency(json["currency"])
        value = json.get("value")
        promotype = Promotype(rawValue: json.get("promotype")) ?? .none
    }
}

extension Discount {
    
    /// formatted amount with carrency char
    public var formattedValue: String {
        return CurrencyFormatter.format(value, currencyCode: currency.acode) ?? String(value)
    }
}
