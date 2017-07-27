//
//  GDYearMonthLabel.swift
//  zjlao
//
//  Created by WY on 15/07/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDYearMonthLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.text = "2017年7月"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
