//
//  BottomSheetCellVM.swift
//  merlinApp
//
//  Created by MacBook Pro on 24/10/18.
//  Copyright © 2018 Devp.ios. All rights reserved.
//

import Foundation
import GoogleMaps

class BottomSheetCellVM {
    
    func getMark(_ _titleMarker: String,_ _descMarker: String,_ _latitude: Double,_ _longitude:Double) -> GMSMarker {
        let location = MapLocation()
        return location.createMarker(titleMarker: _titleMarker, descMarker: _descMarker, latitude: _latitude, longitude: _longitude)
    }

}
