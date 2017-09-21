//
//  GDImagePickview.swift
//  zjlao
//
//  Created by WY on 2017/9/19.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
//enum GDImagePickerviewType {
//    case all
//    case albums
//}
@objc protocol GDImagePickerviewDelegate : NSObjectProtocol{
    @objc optional func scrollDirection() -> UICollectionViewScrollDirection
    @objc optional func columnCount() -> Int//纵向时指定
    @objc optional func rowCount() -> Int//横向时指定
    @objc optional func itemMargin() -> CGFloat
    @objc optional func collectionInset() -> UIEdgeInsets
    @objc optional func getSelectedPHAssets(assets:[PHAsset]?)
}
class GDImagePickview: UIView {
    private var collection  : UICollectionView!
    private var table : UITableView?
    private var collectionAssets : PHFetchResult<PHAsset> = PHFetchResult.init()
    private var tableModels : [NSObject]?
    private var albumName : String?
//    private var  type : GDImagePickerviewType = .all
    weak var delegate : GDImagePickerviewDelegate?
    /// initialize the phtot pickerView
    ///
    /// - Parameters:
    ///   - albumName: the target photots of the album named albumName , first judge , if nil judge type paramete  , if not nil , ignore type paramete
    ///   - type: second judge , type of showing content
    ///   - deriction: scroll deriction
    override init(frame : CGRect ) {
        super.init(frame: CGRect.zero)
        let flowLayout = UICollectionViewFlowLayout.init()
        collection = UICollectionView.init(frame: self.bounds, collectionViewLayout: flowLayout)
        self.addSubview(collection)
        collection.backgroundColor = UIColor.white
        collection.allowsMultipleSelection = true
        collection.register(GDPhotoItem.self , forCellWithReuseIdentifier: "GDPhotoItem")
        self.getAllImages()
 
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.configCollection()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GDImagePickview{
    func configTable()  {
        
    }
}
extension GDImagePickview : UICollectionViewDelegate , UICollectionViewDataSource{
    func configCollection()  {
         collection.frame = self.bounds
        collection.delegate = self
        collection.dataSource = self
        if let flowLayout  = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumInteritemSpacing = self.itemMargin
            flowLayout.minimumLineSpacing = self.itemMargin
            flowLayout.sectionInset = self.collectionInset
            flowLayout.scrollDirection = self.scrollDirection
            flowLayout.itemSize = self.itemSize
        }
        self.collection.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionAssets.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collection.dequeueReusableCell(withReuseIdentifier: "GDPhotoItem", for: indexPath)
        if let realItem  = item as? GDPhotoItem {
            let asset = self.collectionAssets.object(at: indexPath.item)
            realItem.asset = asset
        }

        return item
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        mylog((collectionView.indexPathsForSelectedItems?.count ?? 0))
        return (collectionView.indexPathsForSelectedItems?.count ?? 0) >= 9 ? false : true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        mylog("取消选中:\(indexPath); 所有选中的indexpath : \(collectionView.indexPathsForSelectedItems)")
    }
}
extension GDImagePickview{
    
    private var columnCount : Int{
        get {
            if let count  = self.delegate?.columnCount?() {
                return count
            }
            return 3
        }
    }
    private var rowCount : Int {
        get {
            if let count  = self.delegate?.rowCount?() {
                return count
            }
            return 3
        }
    }
    private var itemMargin : CGFloat{
        get {
            if let margin  = self.delegate?.itemMargin?() {
                return margin
            }
            return 2
        }
    }
    private var collectionInset : UIEdgeInsets{
        get{
            if let inset  = self.delegate?.collectionInset?() {
                return inset
            }
            return UIEdgeInsets.init(top: 2, left: 2, bottom: 2, right: 2)
        }
    }
    private var scrollDirection : UICollectionViewScrollDirection {
        get{
            if let direction  = self.delegate?.scrollDirection?() {
                return direction
            }
            return UICollectionViewScrollDirection.vertical
        }
    }
    
    private var itemSize : CGSize {
        if self.scrollDirection == UICollectionViewScrollDirection.horizontal{
            let insetWidth = self.collectionInset.top + self.collectionInset.bottom
            let itemMarginWidth = CGFloat(self.rowCount - 1 ) * itemMargin
            let itemWH = (self.collection.bounds.size.height - insetWidth - itemMarginWidth) / CGFloat(self.rowCount)
            return  CGSize(width: itemWH, height: itemWH)
        }else{
            let insetWidth = self.collectionInset.left + self.collectionInset.right
            let itemMarginWidth = CGFloat(self.columnCount - 1 ) * itemMargin
            let itemWH = (self.collection.bounds.size.width - insetWidth - itemMarginWidth) / CGFloat(self.columnCount)
            return CGSize(width: itemWH, height: itemWH)
        }
    }
    
}
import Photos
extension GDImagePickview{
    func getAllImages() {
        let options = PHFetchOptions.init()
        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false )]
        let fetchResult = PHAsset.fetchAssets(with: options )
        self.collectionAssets = fetchResult
    }
    func done(){
       let result = self.collection.indexPathsForSelectedItems?.flatMap({ (indexPath) -> PHAsset  in
            return  self.collectionAssets.object(at: indexPath.item)
        })
        self.delegate?.getSelectedPHAssets?(assets:result)
    }
}

class GDPhotoItem: UICollectionViewCell {
    private let imageView = UIImageView()
    var asset : PHAsset?{
        didSet{
            if let asset  = asset{
                PHImageManager.default().requestImage(for: asset, targetSize:CGSize(width: 100, height: 100   ), contentMode: PHImageContentMode.default, options: nil) { (imgOption , dictInfo) in
                    if let image = imgOption {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame )
        self.backgroundColor = UIColor.white
        self.contentView.addSubview(imageView)
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
     
    }
    override var isSelected: Bool{
        didSet{
            self.imageView.alpha = isSelected ? 0.5 : 1
        }
     
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
        
    }
}
