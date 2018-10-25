//
//  Location.swift
//  merlinApp
//
//  Created by Devp.ios on 23/10/18.
//  Copyright © 2018 Devp.ios. All rights reserved.
//

import GoogleMaps

class MapLocation  {
    
    var locationHostpot = CLLocation()
    var descHotspot: String = ""
    
    init() {
        locationHostpot = CLLocation(latitude: CLLocationDegrees(0), longitude: CLLocationDegrees(0))
    }
    
    init( lat : Double, lon: Double) {
        locationHostpot = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))
    }

    func getLongitude()-> CLLocationDegrees {
        return locationHostpot.coordinate.longitude
    }

    func getLatitude()-> CLLocationDegrees {
        return locationHostpot.coordinate.latitude
    }
    
    func updateLocation(_ uLocation: CLLocation) {
        locationHostpot = uLocation
    }
    
    func createMarker(titleMarker: String,descMarker:String, latitude: Double, longitude: Double) -> GMSMarker {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        marker.title = titleMarker
        marker.snippet = descMarker
        marker.icon = GMSMarker.markerImage(with: Constants.PRIMARY_COLOR )
        marker.isFlat = true
        return marker
    }
}
