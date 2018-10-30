//
//  BottomePlaceSheetVM.swift
//  merlinApp
//
//  Created by Devp.ios on 23/10/18.
//  Copyright © 2018 Devp.ios. All rights reserved.
//

import Foundation
import UIKit
import Lottie
import GoogleMaps

//Protocols
protocol HomeMapVMDelegate {
    func updateList(_ places: [Place])
    func errorUpdateList()
    func emptyList()
}

protocol HomeViewModelType {
    var delegate: HomeMapVMDelegate? { get set }
}
// -----------------------------------------------

class BottomPlaceSheetVM: HomeViewModelType {
    var delegate: HomeMapVMDelegate?
    
    let tagAddersViews :Int = 101
    var bottomPadding: CGFloat = 0

    // Genera animacion a la vista seleccionada
    func loadLottieAnim(_ viewcenter: UIView, success:@escaping (LOTAnimationView) -> Void) {
        let animationView = LOTAnimationView(name: Constants.LOCATIONS_SIGNAL)
        animationView.tag = tagAddersViews
        animationView.contentMode = .scaleAspectFill
        animationView.tintColor = UIColor.red
        animationView.frame = CGRect(x: 0, y: 0, width: viewcenter.frame.width, height: viewcenter.frame.height/2)
        viewcenter.addSubview(animationView)
        animationView.loopAnimation = true
        success(animationView)
    }
    
    func emptyLottieAnim(_ viewcenter: UIView, success:@escaping (LOTAnimationView) -> Void) {
        let animationView = LOTAnimationView(name: Constants.EMPTY_BOX)
        animationView.tag = tagAddersViews
        animationView.contentMode = .scaleAspectFit
        animationView.tintColor = UIColor.red
        animationView.frame = CGRect(x: 0, y: 0, width: viewcenter.frame.width, height: viewcenter.frame.height/3)
        viewcenter.addSubview(animationView)
        animationView.loopAnimation = true
        success(animationView)
    }
    
    func clearAnimViews(parent: UIView){
        for view in parent.subviews {
            if(view.tag == tagAddersViews){
                view.removeFromSuperview()
            }
        }
    }
    
    // instancia imagen de pelicula a la vista seleccionada
    func finishLoadImage(_ animView: UIView,_ imageView: UIView ) {
        self.clearAnimViews(parent: animView)
    }
    
    // Metodo para carga de imagen de item Movie de las listas
    func getImage(_ cell: BottomSheetCell,_ place: Place) -> Place {
        place.icon?[0].iconState = .loaded
        cell._imageView.image = nil
        let url = Utils.remplaceUrlIcon(url: (place.icon?[0].urlIcon)! ) + (place.icon?[0].suffix)!
        self.getImageItem(name: place.name , pathImage: url , success: { (getImage) in
            DispatchQueue.main.async() {
                if cell.idCell == place.id {
                    cell._imageView.image = getImage
                    cell._imageView.image = cell._imageView.image?.withRenderingMode(.alwaysTemplate)
                    cell._imageView.tintColor = Constants.SECUNDARY_COLOR
                    place.icon?[0].iconState = .finish
                    self.finishLoadImage(cell.viewAnim, cell._imageView)
                }else{
                    cell._imageView.image = nil
                }
            }
        }, failure: { (error) in
            self.finishLoadImage(cell.viewAnim, cell._imageView)
        })
        return place
    }
    
    // Llamado al servicio de descarga de imagen por Http
    func getImageItem(name: String, pathImage: String, success:@escaping (UIImage) -> Void, failure:@escaping (Error) -> Void){
        Services.getImageUrl(name: name, imageUrl: pathImage, success: { (resultImage) in
            success(resultImage)
        }) { (error) in
            failure(error)
        }
    }
    
    
}
