//
//  Utils.swift
//  merlinApp
//
//  Created by Devp.ios on 24/10/18.
//  Copyright © 2018 Devp.ios. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    // Funcion utilizada para aplicar view shadow a view
    func viewShadow(){
        
        self.layer.position = self.center
        self.layer.cornerRadius = 8.0
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2.0
        self.layer.shadowOffset = CGSize.zero
    }
}

extension UIViewController {
    func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        return spinnerView
    }
    
    func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        if let nav = self.navigationController {
            nav.view.endEditing(true)
        }
    }
}

class Utils{
    static func remplaceUrlIcon(url: String) -> String{
        var rUrl = url.replacingOccurrences(of: "https://ss3.4sqi.net/", with: "https://foursquare.com/", options: .literal, range: nil)
        rUrl = rUrl + "64"
        return rUrl
    }
    
    static func getDate()-> String{
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        let result: String = "\(year!)\(month!)\(day!)"
        return result
    }
    
}
