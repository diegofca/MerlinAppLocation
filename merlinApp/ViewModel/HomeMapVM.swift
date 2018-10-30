//
//  HomeMapVM.swift
//  merlinApp
//
//  Created by Devp.ios on 23/10/18.
//  Copyright © 2018 Devp.ios. All rights reserved.
//

import CoreLocation
import GoogleMaps
import AlertBar
import Alamofire
import SwiftyJSON

class HomeMapVM {
    
    //Config Map variables ---
    var mylocation = MapLocation()
    var zoom : Float = 18
    var gpsBtnBottom: CGFloat = 70
    var posy: CGFloat!
    var updateLocation:Bool = true
    
    var places: [Place]!
    
    func getRecommPlaces(_ searchText: String, success:@escaping ([Place]) -> Void, failure:@escaping (Error) -> Void) {
        Services.getExplorerPlaces(location: mylocation, qSearch: searchText ,success: { (resultPlaces) in
            success(resultPlaces)
        }, failure: { (error) in
            failure(error)
        })
    }
    
    func alertSuccess(_ text:String){
        let options = AlertBar.Options(
            shouldConsiderSafeArea: true,
            isStretchable: true,
            textAlignment: .center
        )
        AlertBar.show(type: .notice, message: text, options: options)
    }
    
    func alertInfo(_ text:String){
        let options = AlertBar.Options(
            shouldConsiderSafeArea: true,
            isStretchable: true,
            textAlignment: .center
        )
        AlertBar.show(type: .info, message: text, options: options)
    }
    
    func alertError(_ text:String){
        let options = AlertBar.Options(
            shouldConsiderSafeArea: true,
            isStretchable: true,
            textAlignment: .center
        )
        AlertBar.show(type: .error, message: text, options: options)
    }
    
    func sortingPlace(_ sortToListPlace: [Place]) -> [Place] {
        var pointLocation: CLLocation!
        for pl in sortToListPlace {
            pointLocation = CLLocation(
                latitude:  CLLocationDegrees(pl.location.lat),
                longitude: CLLocationDegrees(pl.location.long)
            )
            pl.location.distance = self.getDistance( self.mylocation.getLocation(), pointLocation )
        }
        return sortToListPlace.sorted( by: { (first: Place, second: Place) -> Bool in
            first.location.distance < second.location.distance })
    }
    
    // No termine de implementarlo por que no tengo cuenta de pago en GoogleMaps y excedi las peticiones
    func getWayLocation(from source: CLLocation, to destination: CLLocation, success:@escaping (GMSPolyline) -> Void){
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.coordinate.latitude),\(source.coordinate.longitude)&destination=\(destination.coordinate.latitude),\(destination.coordinate.longitude)&sensor=false&mode=driving&key=\(Constants.APIGOOGLE)")!
        
        Alamofire.request(url).responseJSON {(responseData) -> Void in
            
            let json = try? JSON(data: responseData.data!)
            let routes = json!["routes"].arrayValue
            
            if (routes.count > 0) {
                let overview_polyline = routes[0]
                let dictPolyline = overview_polyline["overview_polyline"] as? NSDictionary
                let points = dictPolyline?.object(forKey: "points") as? String
                
                success(self.showPath(polyStr: points!))
               /* DispatchQueue.main.async {
                    let bounds = GMSCoordinateBounds(coordinate: source, coordinate: destination)
                    let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(170, 30, 30, 30))
                    self.mapView!.moveCamera(update)
                }*/
            }
        }
    }
    
    func getDistance(_ posInit: CLLocation,_ posDestinatio: CLLocation) -> Int {
        let distanceInMeters = posInit.distance(from: posDestinatio)
        return Int(distanceInMeters)
    }
    
    private func showPath(polyStr :String) -> GMSPolyline{
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        return polyline
    }
    
    func outSizeCardInfoPlace(_ view :UIView){
        UIView.animate(withDuration: 0.5, animations: {
            view.frame.origin.y = self.posy + 8
        }, completion: nil)
    }
    
    func inSizeCardInfoPlace(_ posY: CGFloat, _ view :UIView){
        UIView.animate(withDuration: 0.5, animations: {
            view.frame.origin.y = UIScreen.main.bounds.height - view.frame.size.height - posY - 8
        }, completion: nil)
    }
    
}
