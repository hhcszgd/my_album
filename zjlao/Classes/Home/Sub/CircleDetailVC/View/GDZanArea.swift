//
//  GDZanArea.swift
//  zjlao
//
//  Created by WY on 23/05/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDZanArea: UIView {
    lazy var collection  = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var models : [BaseControlModel]?{
        didSet{
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
