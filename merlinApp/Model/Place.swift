//
//  Place.swift
//  merlinApp
//
//  Created by Devp.ios on 23/10/18.
//  Copyright © 2018 Devp.ios. All rights reserved.
//

import Foundation
import ObjectMapper

class Place : Mappable {
    
    var id: String!
    var name : String!
   
    var location: PlaceLocation!
    var icon: [Icons]!
    
    init() {}
    func mapping(map: Map) {
        self.id <- map["venue.id"]
        self.name <- map["venue.name"]
        self.location <- map["venue.location"]
        self.icon <- map["venue.categories"]
    }
    required init (map: Map) {}
}

class GroupPlaces: Mappable {
    var type : String?
    var name : String?
    var places : [Place]?
    required init(map: Map) {}
    func mapping(map: Map) {
        self.type <- map["type"]
        self.name <- map["name"]
        self.places <- map["items"]
    }

}

// Clase para mapeo de list del objecto PLACE
class PlaceList : Mappable{
    var headerLocation: String?
    var groupsPlaces : [GroupPlaces]?
    required init(map: Map) {}
    func mapping(map: Map) {
        self.headerLocation <- map["response.headerLocation"]
        self.groupsPlaces <- map["response.groups"]
    }
}
