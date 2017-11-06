//
//  ChooseTimeItem.swift
//  zjlao
//
//  Created by WY on 2017/10/26.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SnapKit
class ChooseTimeItem: UICollectionViewCell {
    let label = UILabel()
    var para : String  {
        if label.text == nil  {
            return ""
        }
        switch label.text! {
        case "一个月内":
            return "0,1"
            
        case "1~3个月":
            return "1,3"
            
        case "3~6个月":
            return "3,6"
            
        case "6~12个月":
            return "6,12"
            
        case "1~2年":
            return "12,24"
            
        case "2年以上":
            return "24,0"
        default:
            return "0,1"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame )
        label.text = "hello"
        self.contentView.addSubview(label)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.frame = self.bounds
//        label.snp.remakeConstraints { (make ) in
//            make.edges.equalToSuperview()
//        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
