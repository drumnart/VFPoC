//
//  Shop.swift
//  VFPoC
//
//  Created by Sergey Gorin on 13/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Network

struct Shop: JSONParseable {
    let id: Int
    let name: String
    let media: MediaResources
    
    public init(json: [String : Any] = [:]) {
        id = json.get("id")
        name = json.get("name")
        media = MediaResources(json["resourceInfo"])
    }
}

extension Shop {
    
    private var pathPrefix: String {
        return TAPI.Config.baseURL + "/v1/shop/"
    }
    
    func imagePaths(for size: ImageSize) -> [String] {
        return media.images.compactMap { pathPrefix + $0.path(for: size) }
    }
    
    func imagePath(at index: Int = 0, for size: ImageSize) -> String {
        return pathPrefix + media.imagePath(at: index, for: size)
    }
    
    func playlistPath(at index: Int = 0) -> String {
        return pathPrefix + media.playlistPath(at: index)
    }
}
