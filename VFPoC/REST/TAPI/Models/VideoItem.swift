//
//  VideoItem.swift
//  VFPoC
//
//  Created by Sergey Gorin on 15/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Network

struct VideoItem: JSONParseable {
    let id: String
    let claims: [Int]
    
    var playlistPath: String {
        return "/video/playlist/\(id)"
    }
    
    public init(json: [String : Any] = [:]) {
        id = json.get("id")
        claims = json.get("claims", else: [])
    }
}
