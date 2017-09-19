//
//  GDImagePickview.swift
//  zjlao
//
//  Created by WY on 2017/9/19.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
enum GDImagePickerviewType {
    case all
    case albums
}
@objc protocol GDImagePickerviewDelegate : NSObjectProtocol{
    @objc optional func scrollDirection() -> UICollectionViewScrollDirection
    @objc optional func columnCount() -> Int
    @objc optional func rowCount() -> Int
}
class GDImagePickview: UIView {
    private var collection  : UICollectionView!
    private var table : UITableView?
    private var collectionModels : [NSObject]?
    private var tableModels : [NSObject]?
    
    var albumName : String?
    private var  type : GDImagePickerviewType = .all
    
    
    weak var delegate : GDImagePickerviewDelegate?
    private var  deriction : UICollectionViewScrollDirection  {
            get{
                if let delegateDirection = self.delegate?.scrollDirection?() {
                    return delegateDirection
                }else{
                    return UICollectionViewScrollDirection.vertical
                }
            }
    }
    /// initialize the phtot pickerView
    ///
    /// - Parameters:
    ///   - albumName: the target photots of the album named albumName , first judge , if nil judge type paramete  , if not nil , ignore type paramete
    ///   - type: second judge , type of showing content
    ///   - deriction: scroll deriction
    init(frame : CGRect  , albumName : String? = nil  , type : GDImagePickerviewType = .all) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.yellow
        let flowLayout = UICollectionViewFlowLayout.init()
        collection = UICollectionView.init(frame: self.bounds, collectionViewLayout: flowLayout)
        self.addSubview(collection)
        if let albumName  =  albumName {
            //show the photos of album named albumName
            //get data and show(collectionModels)
        }else{
            switch type {
            case .all :
                //show all photos of the imgLibrary
                //get datas and show(collectionModels)
                break
            case .albums :
                //show app albums , and then , show photos of the choosed album
                let table = UITableView.init()
                self.table = table
                self.addSubview(table)
                //get datas and show  (tableModels)
                break
            }
        }
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if let albumName  =  albumName {
            //show the photos of album named albumName
            self.configCollection()
        }else{
            switch type {
            case .all :
                //show all photos of the imgLibrary
                self.configCollection()
                break
            case .albums :
                //show app albums , and then , show photos of the choosed album
                self.configTable()
                break
            }
        }
        
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

extension GDImagePickview{
    func configTable()  {
        
    }
}
extension GDImagePickview{
    func configCollection()  {
        
    }
}
extension GDImagePickview{}

