//
//  SlideMenuCell.swift
//  HappyBike
//
//  Created by Norbert Nagy on 27/05/2017.
//  Copyright © 2017 Norbert Nagy. All rights reserved.
//

import UIKit

class SlideMenuCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    var bgColor = UIColor.black
    var selectedColor = UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        label.textColor = UIColor.white
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = bgColor
    }
    
    func selectCell(_ selected: Bool) {
        if selected {
            contentView.backgroundColor = selectedColor//UIColor(hex: "")
        } else {
            contentView.backgroundColor = bgColor//UIColor(hex: "")
        }
    }
}
