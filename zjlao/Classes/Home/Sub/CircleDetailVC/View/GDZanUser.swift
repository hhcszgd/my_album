//
//  GDZanUser.swift
//  zjlao
//
//  Created by WY on 19/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDZanUser: GDBaseControl  {
/**
     if let comment_user_name = goodDict["comment_user_name"] as? String{
     goodModel.title = comment_user_name
     }
     
     if let comment_user_id = goodDict["comment_user_id"] as? String{
     goodModel.additionalTitle = comment_user_id
     }
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleLabel)
        
        titleLabel.textColor = UIColor.lightGray
        subTitleLabel.textColor = UIColor.lightGray
        titleLabel.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.subTitleLabel.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(self.subTitleLabel)
    }
    var model : BaseControlModel?{
        didSet{
            if let modelReal = model {
                self.titleLabel.text = model?.title
                let nameSize = self.titleLabel.text?.sizeSingleLine(font: (self.titleLabel.font)!)
//                self.button.titleLabel?.sizeToFit()
                let h = self.titleLabel.font.lineHeight 
                
                if modelReal.switchState {
                    self.subTitleLabel.text = ","
                    self.subTitleLabel.isHidden = false
                    self.subTitleLabel.sizeToFit()
                    self.bounds = CGRect(x: 0, y: 0, width: self.subTitleLabel.bounds.size.width + (nameSize?.width ?? 0 ), height: h)
                    self.titleLabel.frame = CGRect(x: 0, y: 0, width: (nameSize?.width ?? 0 ), height: (nameSize?.height ?? 0 ))
                    self.subTitleLabel.frame = CGRect(x: self.titleLabel.frame.maxX, y: 0, width: self.subTitleLabel.bounds.size.width, height: subTitleLabel.bounds.size.height)
                }else{
                      self.bounds = CGRect(x: 0, y: 0, width: (nameSize?.width ?? 0 ), height: h)
                    self.subTitleLabel.isHidden = true
                    self.titleLabel.frame =  CGRect(x: 0, y: 0, width: (nameSize?.width ?? 0 ), height: (nameSize?.height ?? 0 ))
                }
                self.layoutIfNeeded()
            }
//            self.imageView.sd_setImage(with: URL(string: newValue?.imageUrl ?? ""))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
/*
 //
 //  GDZanUser.swift
 //  zjlao
 //
 //  Created by WY on 19/04/2017.
 //  Copyright © 2017 com.16lao.zjlao. All rights reserved.
 //
 
 import UIKit
 
 class GDZanUser: GDBaseControl  {
 
 override init(frame: CGRect) {
 super.init(frame: frame)
 self.addSubview(self.imageView)
 self.imageView.image = UIImage(named: "qieziImgPlaceholder")
 }
 var model : BaseControlModel?{
 willSet{
 self.imageView.sd_setImage(with: URL(string: newValue?.imageUrl ?? ""))
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

 */
