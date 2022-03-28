//
//  Product.swift
//  VFPoC
//
//  Created by Sergey Gorin on 13/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Network

struct Product: JSONParseable {
    let id: Int
    let title: String
    let description: String
    let shop: Shop
    let comments: Product.Comments
    let likesCount: Int
    let media: MediaResources
    let skuInfo: SKUInfo
    let created: Date
    let sharedUrl: String
    
    public init(json: [String : Any] = [:]) {
        id = json.get("id")
        title = json.get("title")
        description = json.get("description")
        shop = Shop(json["shop"])
        comments = Product.Comments(json["comments"])
        likesCount = json.get("likesCount")
        media = MediaResources(json["resourceInfo"])
        skuInfo = Product.SKUInfo(json["skuInfo"])
        created = Date(utcString: json.get("created"))
        sharedUrl = json.get("sharedUrl")
    }
}

extension Product {
    
    var isDiscounted: Bool {
        return minDiscount.value > 0
    }
    
    var minPrice: Price {
        return skuInfo.minPrice
    }
    var maxPrice: Price {
        return skuInfo.maxPrice
    }
    var minDiscount: Price {
        return skuInfo.minDiscount
    }
    var maxDiscount: Price {
        return skuInfo.maxDiscount
    }
    
    var formattedPrice: String {
        if minPrice.value >= maxPrice.value {
            return minPrice.formattedValue
        }
        return minPrice.formattedValue + "-" + maxPrice.formattedValue
    }
    
    var formattedDiscount: String {
        if minDiscount.value >= maxDiscount.value {
            return minDiscount.formattedValue
        }
        return minDiscount.formattedValue + "-" + maxDiscount.formattedValue
    }
    
    private var pathPrefix: String {
        return TAPI.Config.baseURL + "/v1/product/"
    }
    
    var playlistPath: String {
        return pathPrefix + (media.videos.first?.playlistPath ?? "")
    }
    
    func imagePaths(for size: ImageSize) -> [String] {
        return media.images.compactMap { pathPrefix + $0.path(for: size) }
    }
    
    func shopAvatarPath(for size: ImageSize) -> String {
        return shop.imagePath(for: size)
    }
}

// Product specific subtypes

extension Product {
    
    struct SKUInfo: JSONParseable {
        let minPrice: Price
        let maxPrice: Price
        let minDiscount: Price
        let maxDiscount: Price
        
        public init(json: [String : Any] = [:]) {
            minPrice = Price(json["minPrice"])
            maxPrice = Price(json["maxPrice"])
            minDiscount = Price(json["minDiscount"])
            maxDiscount = Price(json["maxDiscount"])
        }
    }

    struct Comments: JSONParseable {
        let totalCount: Int
        let recent: [Comment]
    
        public init(json: [String : Any] = [:]) {
            totalCount = json.get("totalCount")
            recent = json.get("recent", else: []).map { Comment($0) }
        }
    }
}

