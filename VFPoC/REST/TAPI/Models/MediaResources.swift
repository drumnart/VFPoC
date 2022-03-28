//
//  MediaResources.swift
//  VFPoC
//
//  Created by Sergey Gorin on 14/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Network

struct MediaResources: JSONParseable {
    let images: [ImageItem]
    let videos: [VideoItem]
    
    public init(json: [String : Any] = [:]) {
        images = json.get("images", else: []).map { ImageItem($0) }
        videos = json.get("videos", else: []).map { VideoItem($0) }
    }
}

extension MediaResources {
    
    func imagePath(at index: Int, for size: ImageSize) -> String {
        return images[safe: index]?.path(for: size) ?? .empty
    }
    
    func playlistPath(at index: Int) -> String {
        return videos[safe: index]?.playlistPath ?? .empty
    }
}
