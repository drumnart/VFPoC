//
//  Foundation+Extensions.swift
//  VFPoC
//
//  Created by Sergey Gorin on 04/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }
}

extension Date {
    
    struct Formatter {
        static let utc: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return formatter
        }()
    }
    
    init(utcString: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") {
        let formatter = Formatter.utc
        formatter.dateFormat = format
        self = formatter.date(from: utcString) ?? Date(timeIntervalSinceReferenceDate: 0)
    }
}

extension Dictionary {
    public func get<T>(_ key: Key) -> T? {
        return self[key] as? T
    }
    
    public func get<T>(_ key: Key, `else` `default`: T) -> T {
        return self[key] as? T ?? `default`
    }

    subscript <T>(_ key: Key, _ `default`: T) -> T {
        return get(key, else: `default`)
    }
    
    public func get(_ key: Key) -> Int {
        return self[key] as? Int ?? Int()
    }
    
    public func get(_ key: Key) -> Double {
        return self[key] as? Double ?? Double()
    }
    
    public func get(_ key: Key) -> Float {
        return self[key] as? Float ?? Float()
    }
    
    public func get(_ key: Key) -> NSNumber {
        return self[key] as? NSNumber ?? NSNumber()
    }
    
    public func get(_ key: Key) -> String {
        return self[key] as? String ?? String()
    }
    
    public func get(_ key: Key) -> Bool {
        return self[key] as? Bool ?? Bool()
    }
    
    public func get(_ key: Key) -> Array<Any> {
        return self[key] as? [Any] ?? []
    }
    
    public func get(_ key: Key) -> Dictionary<Key, Any> {
        return self[key] as? [Key: Any] ?? [:]
    }
    
    public func get(_ key: Key) -> NSNull {
        return self[key] as? NSNull ?? NSNull()
    }
    
    public func merge(with other: Dictionary) -> Dictionary {
        return merge(self, other)
    }
    
    public static func + (lhs: [Key: Value], rhs: [Key: Value]) -> Dictionary {
        return lhs.merge(with: rhs)
    }
}

extension ExpressibleByDictionaryLiteral where Key : Hashable {
    func merge<K, V>(_ left: [K: V], _ right: [K: V]) -> [K: V] {
        return left.reduce(right) {
            var new = $0 as [K: V]
            new.updateValue($1.1, forKey: $1.0)
            return new
        }
    }
}

extension DispatchQueue {
    
    static var currentLabel: String? {
        return String(validatingUTF8: __dispatch_queue_get_label(nil))
    }
    
    static func main(_ closure: @escaping () -> Void) {
        if self === DispatchQueue.main && Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
    static func delay(_ delay: TimeInterval, in queue: DispatchQueue = .main, closure: @escaping () -> Void) {
        queue.asyncAfter(deadline: DispatchTime.now() + delay, execute: closure)
    }
}

func delay(_ delay: TimeInterval, in queue: DispatchQueue = .main, closure: @escaping () -> Void) {
    DispatchQueue.delay(delay, in: queue, closure: closure)
}

extension NotificationCenter {
    
    func addUniqueObserver(_ observer: AnyObject,
                           selector: Selector,
                           name: NSNotification.Name?,
                           object: AnyObject?) {
        removeObserver(observer, name: name, object: object)
        addObserver(observer, selector: selector, name: name, object: object)
    }
    
    func addOneTimeObserver(forName name: NSNotification.Name?,
                            object: Any?,
                            queue: OperationQueue? = .main) {
        var token: NSObjectProtocol?
        token = addObserver(forName: name, object: object, queue: queue) { [unowned self] _ in
            token.let{ self.removeObserver($0) }
        }
    }
}

extension Notification.Name {
    func post(object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: self, object: object, userInfo: userInfo)
    }
}

extension String {
    
    static let empty = ""
    
    /// Length of the string
    var length: Int {
        return count
    }
    
    /// Empty or only whitespace and newline characters
    var isBlank: Bool {
        return trimmed().isEmpty
    }
    
    /// Returns a new trimmed string
    func trimmed(in characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        return trimmingCharacters(in: characterSet)
    }
}

