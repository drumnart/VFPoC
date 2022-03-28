//
//  Pagination.swift
//  VFPoC
//
//  Created by Sergey Gorin on 14/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Network

struct Pagination: JSONParseable {
    let records: Int
    let page: Int
    let hasNext: Bool
    
    public init(json: [String : Any] = [:]) {
        let requestPage: [String: Any] = json.get("requestPage", else: [:])
        records = json.get(requestPage.get("records"), else: json.get("records"))
        page = json.get(requestPage.get("page"), else: json.get("page"))
        hasNext = json.get(requestPage.get("hasNext"), else: json.get("hasNext"))
    }
    
    public init(recordsLimit: Int = 20, page: Int, hasNext: Bool = false) {
        self.records = recordsLimit
        self.page = page
        self.hasNext = hasNext
    }
    
    var jsonObject: [String: Any] {
        return ["requestPage": ["count": records, "page": page]]
    }
}
