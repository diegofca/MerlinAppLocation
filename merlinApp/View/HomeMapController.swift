//
//  ViewController.swift
//  merlinApp
//
//  Created by Devp.ios on 22/10/18.
//  Copyright © 2018 Devp.ios. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

private extension NSLayoutConstraint {
    func hasExceeded(verticalLimit: CGFloat) -> Bool {
        return self.constant < verticalLimit
    }
}

class HomeMapController:  UIViewController, BottomSheetDelegate, GMSMapViewDelegate, CLLocationManagerDelegate {
   
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var updatedLocationBtn: UIButton!
    @IBOutlet weak var containerSheet: UIView!
    @IBOutlet weak var detailPlace: UIView!
    
    var viewModel : HomeMapVM!
    var locationManager = CLLocationManager()
    var viewSheetController: BottomPlaceSheetViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVM();
        initializeTheLocationManager()
    }
    
    func initializeVM(){
        self.viewModel = HomeMapVM()
        self.viewModel.posy  = self.detailPlace.frame.origin.y
        self.detailPlace.viewShadow()
        let hideDetailGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.closeDetailView(_:)))
        hideDetailGesture.direction = .down
        detailPlace.addGestureRecognizer(hideDetailGesture)
    }
    
    func initializeTheLocationManager() {
        containerSheet.layer.cornerRadius = 15
        containerSheet.layer.masksToBounds = true
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.settings.zoomGestures = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: viewModel.gpsBtnBottom, right:0)
        setColorBtnIcon( color: Constants.PRIMARY_COLOR )
    }
    
    @IBAction func activeUpdateLocation(_ sender: Any) {
        viewModel.updateLocation = !viewModel.updateLocation
        if  viewModel.updateLocation { 
            setColorBtnIcon( color: Constants.PRIMARY_COLOR )
            locationManager.startUpdatingLocation()
        }else{
            setColorBtnIcon( color: Constants.SECUNDARY_COLOR )
            locationManager.stopUpdatingLocation()
        }
    }
    
    func setColorBtnIcon(color: UIColor){
        let buttonImage = UIImage(named: "arrowIcon")
        updatedLocationBtn.setImage(buttonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        updatedLocationBtn.tintColor = color
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        viewModel.mylocation.updateLocation(locations.last!)
        let camera = GMSCameraPosition.camera(withLatitude: viewModel.mylocation.getLatitude(), longitude: viewModel.mylocation.getLongitude(), zoom: viewModel.zoom)
        self.mapView?.animate(to: camera)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewSheet = segue.destination as? BottomPlaceSheetViewController{
            viewSheet.bottomSheetDelegate = self
            viewSheet.parentView = containerSheet
            viewSheetController = viewSheet
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // ---- View Sheet delegate
    func sendQuerySearch(textSearch: String) {
        viewModel.getRecommPlaces(textSearch, success: { (places) in
            if places.count > 0 {
                let sortPlaces: [Place] = self.viewModel.sortingPlace(places)
                self.viewSheetController.getVM().updateList(sortPlaces)
                //self.viewSheetController.viewModel.getPolylineRoute(listMarkets: places).map = self.mapView
            }else{
                self.viewModel.alertInfo("\(NSLocalizedString("homeMapView.placeslist.empty", comment: "")) \(textSearch)")
                self.viewSheetController.getVM().emptyList()
            }
        }) { (error) in
            print(error.localizedDescription)
            self.viewSheetController.getVM().errorUpdateList()
            self.viewModel.alertError( NSLocalizedString("homeMapView.conection.failed", comment: ""))
        }
    }
    
    func selectedPlace(_ namePlace: String , location: GMSMarker) {
        let camera = GMSCameraPosition.camera(withLatitude: location.position.latitude, longitude: location.position.longitude, zoom: viewModel.zoom)
        self.mapView?.animate(to: camera)
        mapView.selectedMarker = location
        self.activeUpdateLocation((Any).self)
        self.viewModel.alertSuccess("\(NSLocalizedString("homeMapView.conection.getlocated", comment: ""))\(namePlace)")
        self.viewModel.inSizeCardInfoPlace( self.viewSheetController.bottomOffset , self.detailPlace)
       // self.sendWayLocation(location: location)  -> Creacion de ruta
    }
    
    func sendMarkMap(mark: GMSMarker) {
        mark.map = mapView
    }
    
    func updateBottomSheet(frame: CGRect) {
        containerSheet.frame = frame
    }
    
    func sendWayLocation(location: GMSMarker) {
        
        let pointLocation = CLLocation(
            latitude:  CLLocationDegrees(location.position.latitude),
            longitude: CLLocationDegrees(location.position.longitude)
        )
        
        self.viewModel.getWayLocation(from: viewModel.mylocation.getLocation() , to: pointLocation, success: { (route) in
            route.map = self.mapView
        })
    }
    //-----------------------
    
    
    // gestures close detail
    @IBAction func closeDetailView(_ sender: UISwipeGestureRecognizer) {
        self.viewModel.outSizeCardInfoPlace(self.detailPlace)
    }
}



