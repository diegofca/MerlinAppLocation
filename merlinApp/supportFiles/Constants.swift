//
//  Constants.swift
//  merlinApp
//
//  Created by Devp.ios on 22/10/18.
//  Copyright © 2018 Devp.ios. All rights reserved.
//

import Foundation
import UIKit

class Constants{
    //Api constatns
    static let BASE_URL = "https://api.foursquare.com/v2/venues/"
    static let CLIENT_ID = "client_id=XKT4FEQY1FKUCMJTJP5KQTZHLLY2WR5BD53BPYALOBITBBNS"
    static let SECRET_ID = "&client_secret=40TSU1LMIJPVTBKIBRLINNGDAQBJZPKIVM2CN3XMYHSTWFAX"
    
    static let EXPLORE_LB = "explore?"
    static let SEARch_LB = "search?"
    static let QUERY_LB = "&query="
    static let ll_LB = "&ll="
    static let v_LB = "&v="
    static let NEAR_LB = "&near=500"
    
    //GOOGLE MAPS
    static let APIGOOGLE = "AIzaSyAx2IUiWVJ-AcazOe5o0jn__apphAUHN7E"
    
    //RESOURCES LOTTIE
    static let IMAGE_LOADING = "loading"
    static let WORLD_LOCATIONS_LD = "world_locations"
    static let LOCATIONS_SIGNAL = "location_signal_rev"
    static let EMPTY_BOX = "empty_box"
    
    //Primary color
    static let PRIMARY_COLOR: UIColor = UIColor(red:0.24, green:0.64, blue:0.97, alpha:1.0)
    static let SECUNDARY_COLOR: UIColor = UIColor.lightGray

}
