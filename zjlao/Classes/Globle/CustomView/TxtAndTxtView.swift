//
//  TxtAndTxtView.swift
//  zjlao
//
//  Created by WY on 2017/9/14.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class TxtAndTxtView: GDBaseControl {
    
    let container = UIView()
    var bottomTitle : String?{
        didSet{
            self.subTitleLabel.text = bottomTitle ?? "0"
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    var topTitle  : String?{
        didSet{
            self.titleLabel.text = topTitle ?? "0"
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        self.backgroundColor = UIColor.randomColor()
        self.addSubview(self.container)
        self.container.addSubview(self.titleLabel)
        self.titleLabel.textColor = UIColor.gray
        self.titleLabel.font = GDFont.systemFont(ofSize: 15)
        self.titleLabel.textAlignment = NSTextAlignment.center
        
        self.subTitleLabel.font = GDFont.systemFont(ofSize: 13)//UIFont.systemFont(ofSize: 14*SCALE)
        self.subTitleLabel.textColor = UIColor.lightGray
        self.subTitleLabel.textAlignment = NSTextAlignment.center
        self.container.addSubview(self.subTitleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let  selfW = self.bounds.size.width
        let  selfH = self.bounds.size.height
        
        var containerW : CGFloat = 0.0
        var  containerH : CGFloat = 0.0
        if selfW < selfH {
            containerW = selfW
            containerH = containerW
        }else {
            
            containerH = selfH
            containerW = containerH
        }
        self.container.bounds = CGRect(x: 0, y: 0, width: containerW, height: containerH)
        self.container.center = CGPoint(x: selfW/2, y: selfH/2)
        
        //        self.bottomTitleLabel.sizeToFit()
        let margin : CGFloat = 5.0 ;
        let bottomTitleW =  selfW
        let bottomTitleH = self.subTitleLabel.font.lineHeight
        //        let bottomTitleX : CGFloat = 0.0 ;
        let bottomTitleY = selfH - bottomTitleH - margin
        
        let leftH = self.container.bounds.size.height - margin * 3 - bottomTitleH //conainer的剩余高度
        
        let imageViewH = leftH
        let imageViewW = self.container.bounds.size.width
        //        let imageViewX = margin
        let imageViewY = margin
        
        self.titleLabel.frame = CGRect(x: 0, y: 0, width: imageViewW, height: imageViewH)
        self.titleLabel.center = CGPoint(x: self.container.bounds.size.width/2, y: imageViewY + imageViewH/2)
        self.subTitleLabel.bounds = CGRect(x: 0, y: 0, width: bottomTitleW, height: bottomTitleH)
        self.subTitleLabel.center = CGPoint(x: self.container.bounds.size.width/2, y: bottomTitleY + bottomTitleH/2)
        
    }
}
