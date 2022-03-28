//
//  TAPI+Interests.swift
//  VFPoC
//
//  Created by Sergey Gorin on 13/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Network

extension TAPI {
 
    typealias Interests = VFPoC.Interest
    typealias HomeFeed = VFPoC.HomeFeed
}

extension Interest {
    
    private enum Router: URLRequestResolver {
        case fetchAll()
        
        var path: String {
            switch self {
            case .fetchAll: return "/v1/preference"
            }
        }
    }
    
    struct InterestsResponse: JSONParseable {
        let interests: [Interest]
        let pagination: Pagination
        
        public init(json: [String : Any] = [:]) {
            interests = json.get("preferences", else: []).map { Interest($0) }
            pagination = Pagination(json)
        }
    }
    
    @discardableResult
    public static func fetchAll(respondingIn queue: DispatchQueue = .main,
                                completion: ((TAPI.Result<InterestsResponse>) -> ())? = nil) -> DataRequest {
        return WebService.shared
            .request(Router.fetchAll())
            .respond(in: queue, completion: completion)
    }
}

extension Encodable {
    
    func encoded() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    var jsonString: String? {
        guard let data = encoded() else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    var jsonObject: [String: Any] {
        guard let data = encoded() else { return [:] }
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
        } catch {
            print("[ERROR]: " + error.localizedDescription)
        }
        return [:]
    }
}

struct HomeFeed {
    
    private enum Router: URLRequestResolver {
        case fetch(params: FilterParams, pageParams: Pagination)
        
        var path: String {
            switch self {
            case .fetch: return "/v1/product/feed"
            }
        }
        
        var parameters: [String: Any] {
            switch self {
            case let .fetch(params, pagingParams):
                return params.jsonObject + pagingParams.jsonObject
            }
        }
        
        var method: HTTPMethod { return .post }
    }
    
    struct FilterParams: Codable {
        let gender: Int?
        let birthYear: Int?
        let preference: [Int]
        
        static let `default` = FilterParams(gender: nil, birthYear: nil, preference: [])
    }
    
    struct Response: JSONParseable {
        let products: [Product]
        let pagination: Pagination
        
        public init(json: [String : Any] = [:]) {
            products = json.get("products", else: []).map { Product($0) }
            pagination = Pagination(json)
        }
    }
    
    @discardableResult
    public static func fetch(params: FilterParams = .default,
                             pageParams: Pagination = Pagination(page: 0),
                             respondingIn queue: DispatchQueue = .main,
                             completion: ((TAPI.Result<Response>) -> ())? = nil) -> DataRequest {
        return WebService.shared
            .request(Router.fetch(params: params, pageParams: pageParams))
            .respond(in: queue, completion: completion)
    }
}
