//
//  CurrencyFormatter.swift
//  VFPoC
//
//  Created by Sergey Gorin on 14/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Foundation

class CurrencyFormatter: Foundation.NumberFormatter {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override fileprivate init() {
        super.init()
        
        numberStyle = .currency
        minimumFractionDigits = 0
        maximumFractionDigits = 2
    }
    
    static let sharedInstance = CurrencyFormatter()
    
    // Convert number to string for representing formatted currency styled value in locale of user
    static func format(_ value: Int,
                       precision: Int = 2,
                       currencyCode: String? = nil) -> String? {
        
        let formatter = CurrencyFormatter.sharedInstance
        formatter.currencyCode = currencyCode
        formatter.maximumFractionDigits = precision
        formatter.multiplier = NSDecimalNumber(decimal: pow(0.1, precision))
        return formatter.string(for: Decimal(value))
    }
}

func getCurrencySymbol(from currencyCode: String) -> String? {
    
    let locale = NSLocale(localeIdentifier: currencyCode)
    if locale.displayName(forKey: .currencySymbol, value: currencyCode) == currencyCode {
        let newlocale = NSLocale(localeIdentifier: currencyCode.dropLast() + "_en")
        return newlocale.displayName(forKey: .currencySymbol, value: currencyCode)
    }
    return locale.displayName(forKey: .currencySymbol, value: currencyCode)
}
