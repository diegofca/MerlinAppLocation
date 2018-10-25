//
//  LauncherViewController.swift
//  merlinApp
//
//  Created by MacBook Pro on 25/10/18.
//  Copyright © 2018 Devp.ios. All rights reserved.
//

import UIKit
import Lottie

class LauncherViewController: UIViewController {
    
    @IBOutlet weak var aninLaunchView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let animationView = LOTAnimationView(name: "world_locations")
        self.aninLaunchView.addSubview(animationView)
        animationView.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
