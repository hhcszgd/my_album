//
//  GDFullMediaUserView.swift
//  zjlao
//
//  Created by WY on 20/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//点赞人视图

import UIKit

class GDFullMediaUserView: GDBaseControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
    }
    var model : GDFullMediaUser?{
        willSet{
            self.imageView.sd_setImage(with: URL(string: newValue?.comment_user_avatar ?? ""))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
