//
//  Price.swift
//  VFPoC
//
//  Created by Sergey Gorin on 14/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Network

protocol PriceSpec {
    var currency: Currency { get }
    var value: Int { get }
}

struct Price: JSONParseable, PriceSpec {
    let currency: Currency
    let value: Int
    
    public init(json: [String : Any] = [:]) {
        currency = Currency(json["currency"])
        value = json.get("value")
    }
    
    public init(value: Int, currency: Currency) {
        self.value = value
        self.currency = currency
    }
}

extension Price {
    
    /// formatted amount with carrency char
    public var formattedValue: String {
        return CurrencyFormatter.format(value, currencyCode: currency.acode) ?? String(value)
    }
    
    public static func + (lhs: Price, rhs: Price) -> Price {
        guard lhs.currency.acode.isEmpty || rhs.currency.acode.isEmpty
            || lhs.currency.acode == rhs.currency.acode else {
            print("[FAIL] Operation with Incompatible currencies!")
            return Price()
        }
        return Price(
            value: lhs.value + rhs.value,
            currency: lhs.currency.acode.isEmpty ? rhs.currency : lhs.currency
        )
    }
    
    public static func - (lhs: Price, rhs: Price) -> Price {
        guard lhs.currency.acode.isEmpty || rhs.currency.acode.isEmpty
            || lhs.currency.acode == rhs.currency.acode else {
            print("[FAIL] Operation with Incompatible currencies!")
            return Price()
        }
        return Price(
            value: lhs.value - rhs.value,
            currency: lhs.currency.acode.isEmpty ? rhs.currency : lhs.currency
        )
    }
}
