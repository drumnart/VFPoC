//
//  WebService.swift
//  VFPoC
//
//  Created by Sergey Gorin on 13/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Foundation
import Network

class WebService: Network {
    
    public static let shared = WebService()
    
    private convenience init() {
        let configuration = URLSessionConfiguration.default.with {
            $0.timeoutIntervalForRequest = 15
            $0.httpMaximumConnectionsPerHost = 10
        }
        let sessionManager = SessionManager(configuration: configuration)
        sessionManager.adapter = CommonRequestAdapter()
        self.init(sessionManager: sessionManager)
    }
}

/// Default conformation to `ParseableToCollection`
extension AnyToCollectionParseable where Self: Parseable {
    public static func makeCollection(_ object: Any) -> [Self] {
        let items = object as? [[String: Any]] ?? []
        return items.compactMap { Self($0) }
    }
}

/// Additional init for convinience
extension JSONParseable {
    public init(_ obj: Any?) {
        self.init(json: obj as? [String : Any] ?? [:])
    }
}

/// Common values for URLRequestResolver fields
extension URLRequestResolver {
    static var baseURLString: String { return TAPI.Config.baseURL }
    var method: HTTPMethod { return .get }
}

/// Common values for URLResolver
extension URLResolver {
    static var baseURLString: String { return TAPI.Config.baseURL }
}

open class CommonRequestAdapter: RequestAdapter {
    
    open override func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if let urlString = urlRequest.url?.absoluteString,
            urlString.hasPrefix(TAPI.Config.urlOrigin) {
            
            if let locale = Locale.preferredLanguages.first {
                urlRequest.setValue(locale, forHTTPHeaderField: "Accept-Language")
            }
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.setValue("keep-alive", forHTTPHeaderField: "Connection")
//            urlRequest.setValue(Auth.Keychain.getToken(), forHTTPHeaderField: "x-mapi-token")
        }
        
        return urlRequest
    }
}

// MARK: - RequestRetrier
open class CommonRequestRetrier: RequestRetrier {
    
    var maintenance: ((_ completion: @escaping (_ finished: Bool) -> Void) -> ())?
    
    init(maintenance: ((_ completion: @escaping (_ finished: Bool) -> Void) -> ())? = nil) {
        self.maintenance = maintenance
    }
    
    open override func should(_ manager: SessionManager, retry request: Request, with error: Error) -> Bool {
//        if let response = request.task?.response as? HTTPURLResponse, [401].contains(response.statusCode) {
//            Auth.Keychain.removeToken()
//            return true
//        }
        return false
    }
    
    open override func repair(completion: @escaping (_ finished: Bool) -> Void) {
        maintenance?(completion)
    }
}
