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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        label.textColor = UIColor.white
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = UIColor.blue//UIColor(hex: "")
    }

}
