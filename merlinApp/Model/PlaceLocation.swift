//
//  placeLocation.swift
//  merlinApp
//
//  Created by Devp.ios on 23/10/18.
//  Copyright © 2018 Devp.ios. All rights reserved.
//

import Foundation
import ObjectMapper
import GoogleMaps

class PlaceLocation: Mappable {
    
    var address: String! = "No disponible"
    var crossStreet: String! = ""
    var distance:Int! = 0
    var lat: Double! = 0
    var long: Double! = 0
    var city: String! = ""
    var country: String! = ""
    var mark: GMSMarker!
    
    init() {}
    func mapping(map: Map) {}
    required init (map: Map) {
        self.address <- map["address"]
        self.crossStreet <- map["crossStreet"]
        self.distance <- (map["distance"], IntTransform())
        self.lat <- map["lat"]
        self.long <- map["lng"]
        self.city <- map["city"]
        self.country <- map["country"]
    }
}

