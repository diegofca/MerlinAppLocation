//
//  Services.swift
//  merlinApp
//
//  Created by Devp.ios on 23/10/18.
//  Copyright © 2018 Devp.ios. All rights reserved.
//

import Alamofire
import AlamofireImage
import ObjectMapper
import AlamofireObjectMapper

class Services {
    
    // GET PLACESS EXPLORER
    static func getExplorerPlaces(location: MapLocation, qSearch: String, success:@escaping ([Place]) -> Void, failure:@escaping (Error) -> Void ) {
        
        let escapedString = qSearch.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        let url: String = "\(Constants.BASE_URL)\(Constants.EXPLORE_LB)\(Constants.CLIENT_ID)\(Constants.SECRET_ID)\(Constants.ll_LB)\(location.getLatitude()),\(location.getLongitude())\(Constants.QUERY_LB)\(escapedString!)\(Constants.v_LB)\(Utils.getDate())"
        
        Alamofire.request(url).responseObject {(response: DataResponse<PlaceList>) in
            if response.result.isSuccess {
                let lPlaces = response.result.value!
                success((lPlaces.groupsPlaces?[0].places)!)
            }
            if response.result.isFailure {
                let error : Error = response.result.error!
                failure(error)
            }
        }
    }
    
    // Servicio de descarga de imagenes
    static func getImageUrl(name: String, imageUrl: String, success:@escaping (UIImage) -> Void, failure:@escaping (Error) -> Void ) {
        Alamofire.request (imageUrl, method: .get,
            parameters:  nil,
            encoding:  URLEncoding.default,
            headers: nil ).responseImage {
                response in
                    if response.result.isSuccess {
                        if let imageResult = response.result.value {
                            let image = imageResult
                            success(image)
                        }
                    }
                    if response.result.isFailure {
                        let error : Error = response.result.error!
                            failure(error)
                    }
            }
    }
}
