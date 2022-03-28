//
//  UserDefaults+Extensions.swift
//  VFPoC
//
//  Created by Sergey Gorin on 18/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum Key: String {
        case firstRun
        case pendingAppUpdate
        case birthYear
        case gender
        case interests
        case onboardingFinished
        case shouldSkipOnboarding
    }
    
    static func getValue(forKey key: Key) -> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
    
    static func setValue(_ value: Any?, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    static func removeValue(forKey key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    static var isFirstRun: Bool {
        get {
            if ((getValue(forKey: .firstRun) as? Bool) == nil) {
                setValue(false, forKey: .firstRun)
                return true
            } else {
                return getValue(forKey: .firstRun) as? Bool ?? false
            }
        }
        set {
            setValue(newValue, forKey: .firstRun)
        }
    }
    
    static var needToUpdateApp: Bool {
        get { return getValue(forKey: .pendingAppUpdate) as? Bool ?? false }
        set { setValue(newValue, forKey: .pendingAppUpdate) }
    }
    
    static var birthYear: Int? {
        get { return getValue(forKey: .birthYear) as? Int }
        set { setValue(newValue, forKey: .birthYear) }
    }
    
    static var gender: Gender {
        get {
            guard let rawValue = getValue(forKey: .gender) as? Int else {
                return .unknown
            }
            return Gender(rawValue: rawValue) ?? .unknown
        }
        set {
            setValue(newValue.rawValue, forKey: .gender)
        }
    }
    
    static var userInterests: [Interest] {
        get {
            let decoded = getValue(forKey: .interests) as? [Data]
            return decoded?.compactMap { try? JSONDecoder().decode(Interest.self, from: $0) } ?? []
        }
        set {
            let encoded = newValue.map { try? JSONEncoder().encode($0) }
            setValue(encoded, forKey: .interests)
        }
    }
    
    static var isOnboardingFinished: Bool {
        get { return getValue(forKey: .onboardingFinished) as? Bool ?? false }
        set {
            setValue(newValue, forKey: .onboardingFinished)
            setValue(true, forKey: .shouldSkipOnboarding)
        }
    }
    
    static var shouldSkipOnboarding: Bool {
        get { return getValue(forKey: .shouldSkipOnboarding) as? Bool ?? false }
        set { setValue(newValue, forKey: .shouldSkipOnboarding) }
    }
}
