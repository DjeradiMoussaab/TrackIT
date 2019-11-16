//
//  BorderRadiusView.swift
//  TrackIT
//
//  Created by Mac on 11/16/19.
//  Copyright © 2019 mossab. All rights reserved.
//

import UIKit

class BorderRadiusView: UIView {
    override func awakeFromNib() {
        self.layer.cornerRadius = 10.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
    }
}

class BorderRadiusImageView: UIImageView {
    override func awakeFromNib() {
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
    }
}
