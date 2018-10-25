//
//  BottomSheetCell.swift
//  merlinApp
//
//  Created by Devp.ios on 22/10/18.
//  Copyright © 2018 Devp.ios. All rights reserved.
//

import UIKit

struct PlaceCell {
    let idCell: String
    let image: UIImage?
    let name: String
    let location: String
    let distance: String
}

class BottomSheetCell: UITableViewCell {
    
    var idCell: String = ""
    @IBOutlet weak var _imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var wayLocationBtn: UIButton!
    @IBOutlet weak var viewAnim: UIView!
    
    var viewModel: BottomSheetCellVM!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewModel = BottomSheetCellVM()
    }
    
    func setImage(){
        _imageView.layer.borderWidth=1.0
        _imageView.layer.masksToBounds = false
        _imageView.layer.borderColor = UIColor.white.cgColor
        _imageView.layer.cornerRadius = _imageView.frame.size.height/2
        _imageView.clipsToBounds = true
    }
    
    func configure(model: PlaceCell){
        idCell = model.idCell
        nameLabel.text = model.name
        locationLabel.text = model.location
        distanceLabel.text = model.distance + NSLocalizedString("bottomplacesheetCell.meters.label", comment: "")
        imageView?.image = model.image
    }
}
