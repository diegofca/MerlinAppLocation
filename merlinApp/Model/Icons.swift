//
//  Photos.swift
//  merlinApp
//
//  Created by Devp.ios on 24/10/18.
//  Copyright © 2018 Devp.ios. All rights reserved.
//

import Foundation
import ObjectMapper

enum IconDownloadState{
    case null, loaded, finish
}

class Icons: Mappable {
    var id:String!
    var name: String!
    var urlIcon: String!
    var suffix: String!
    var iconState: IconDownloadState = .null
    init() {}
    func mapping(map: Map) {
        self.urlIcon <- map["icon.prefix"]
        self.suffix <- map["icon.suffix"]
        self.id <- map["id"]
        self.name <- map["name"]
    }
    required init (map: Map) {}
}
