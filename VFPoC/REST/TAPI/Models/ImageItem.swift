//
//  ImageItem.swift
//  VFPoC
//
//  Created by Sergey Gorin on 14/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Network
import UIKit.UIScreen

struct ImageConfig {
    let id: Int
    let width: CGFloat
    let height: CGFloat
   
    var resolution: CGSize {
        return CGSize(width: width, height: height)
    }
    
    var isSquare: Bool {
        return width == height
    }
}

enum ImageClaim: Int {
    case res_1440x1080 = 0
    case res_1242x930 = 1
    case res_1080x810 = 2
    case res_750x562 = 3
    case res_480x360 = 4
    case res_320x240 = 5
    case res_750x750 = 6
    case res_480x480 = 7
    case res_320x320 = 8
    
    var id: Int { return rawValue }
    
    var config: ImageConfig {
        switch self {
        case .res_1440x1080: return ImageConfig(id: rawValue, width: 1440, height: 1080)
        case .res_1242x930: return ImageConfig(id: rawValue, width: 1242, height: 930)
        case .res_1080x810: return ImageConfig(id: rawValue, width: 1080, height: 810)
        case .res_750x562: return ImageConfig(id: rawValue, width: 750, height: 562)
        case .res_480x360: return ImageConfig(id: rawValue, width: 480, height: 360)
        case .res_320x240: return ImageConfig(id: rawValue, width: 320, height: 240)
        case .res_750x750: return ImageConfig(id: rawValue, width: 750, height: 750)
        case .res_480x480: return ImageConfig(id: rawValue, width: 480, height: 480)
        case .res_320x320: return ImageConfig(id: rawValue, width: 320, height: 320)
        }
    }
}

enum ShopAvatarClaim: Int {
    case res_320x320 = 0
    case res_150x150 = 1
    
    var id: Int { return rawValue }
    
    var config: ImageConfig {
        switch self {
        case .res_320x320: return ImageConfig(id: rawValue, width: 320, height: 320)
        case .res_150x150: return ImageConfig(id: rawValue, width: 150, height: 150)
        }
    }
}

public enum ImageSize {
    case screen_1_1
    case screen_4_3
    case thumbnail_1_1
    case thumbnail_4_3
    case avatar_1_1
}

struct ImageItem: JSONParseable {
    let id: String
    let claims: [Int]
    let configs: [ImageConfig]
    
    public init(json: [String : Any] = [:]) {
        id = json.get("id")
        claims = json.get("claims", else: [])
        configs = claims
            .compactMap { ImageClaim(rawValue: $0)?.config }
            .sorted { $0.width < $1.width }
    }
    
    private var pathPrefix: String { return  "/image/\(id)/" }
    
    func path(for size: ImageSize) -> String {
        let claimId = claim(for: size) ?? -1
        
        return pathPrefix + (claimId > 0 ? String(claimId) : .empty)
    }
    
    func claim(for size: ImageSize) -> Int? {
        
        guard claims.count > 0 else { return nil }
        
        let screen = UIScreen.main
        let widthPoints = screen.bounds.width
        let scale = screen.scale
        let isSquare: Bool
        let config: ImageConfig

        switch size {
        case .screen_4_3:
            isSquare = false
            switch (widthPoints, scale) {
            case (320, _): config = ImageClaim.res_480x360.config
            case (414, 3): config = ImageClaim.res_1080x810.config
            default: config = ImageClaim.res_750x562.config
            }
        
        case .screen_1_1:
            isSquare = true
            switch (widthPoints, scale) {
            case (320, _): config = ImageClaim.res_480x480.config
            default: config = ImageClaim.res_750x750.config
            }
            
        case .thumbnail_4_3:
            isSquare = false
            switch (widthPoints, scale) {
            case (320, _): config = ImageClaim.res_320x240.config
            case (375, _), (414, 2): config = ImageClaim.res_480x360.config
            case (414, _): config = ImageClaim.res_750x562.config
            default: config = ImageClaim.res_480x360.config
            }
            
        case .thumbnail_1_1:
            isSquare = true
            switch (widthPoints, scale) {
            case (320, _): config = ImageClaim.res_320x320.config
            default: config = ImageClaim.res_480x480.config
            }
            
        case .avatar_1_1:
            isSquare = true
            switch (widthPoints, scale) {
            default: config = ShopAvatarClaim.res_150x150.config
            }
        }
        
        if claims.contains(config.id) {
            return config.id
        }
        
        return configs.last(where: {
            $0.width <= config.width && $0.isSquare == isSquare
        })?.id
    }
}
