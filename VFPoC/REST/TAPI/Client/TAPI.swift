//
//  TAPI.swift
//  VFPoC
//
//  Created by Sergey Gorin on 13/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Network
import Alamofire

typealias TAPI = TBXAPIClient

/// ToBox Marketplace 2.0 API
struct TBXAPIClient {
    
    typealias Result = Alamofire.Result
    
    enum Environment {
        case prod, dev
        
        var host: String {
            switch self {
            case .prod: return "3.121.191.187:8081"
            case .dev: return "192.168.1.175:8081"
            }
        }
    }
    
    public struct Config {
        public static let env: Environment = .prod
        public static let scheme = "http://"
        public static let host = env.host
        public static let urlOrigin = scheme + host
        public static var baseURL = urlOrigin + "/api"
    }
}
