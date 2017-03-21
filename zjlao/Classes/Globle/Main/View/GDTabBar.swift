//
//  GDTabBar.swift
//  zjlao
//
//  Created by WY on 17/1/15.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDTabBar: UITabBar {

    
    static let share: GDTabBar = {
        let tempTabBar = GDTabBar()
        return tempTabBar
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        self.backgroundColor = randomColor
        self.tintColor = UIColor.orange
        self.barTintColor = UIColor.white
        //        self.backgroundImage = UIImage(named: "tab_me_click")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        for (index ,item)  in self.items!.enumerated() {
            if index == 0  {
                
            }
            if index == 2  {
                item.imageInsets = UIEdgeInsetsMake(-14, 0, 14, 0)
                item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -26)
            }
        }
    }
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    


}
