//
//  Preference.swift
//  VFPoC
//
//  Created by Sergey Gorin on 12/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Network

struct Interest: JSONParseable, Codable {
    let id: Int
    let name: String
    let imageId: String
    
    public init(json: [String : Any] = [:]) {
        id = json.get("id")
        name = json.get("name")
        imageId = json.get("imageId")
    }
    
    public init(id: Int, name: String, imageId: String) {
        self.id = id
        self.name = name
        self.imageId = imageId
    }
}

extension Interest {
    
    var imagePath: String {
        return TAPI.Config.baseURL + "/v1/preference/image/" + imageId
    }
}
