//
//  GDHomeCircleCell.swift
//  zjlao
//
//  Created by WY on 17/4/5.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SDWebImage
class GDHomeCircleCell: UICollectionViewCell , UICollectionViewDelegate , UICollectionViewDataSource {
    let subcellWidth : CGFloat = 78
    var selectedItem  : GDCollectionImageCell = GDCollectionImageCell.init(frame: CGRect.zero)
    var selectedItemModel  : BaseControlModel?{
        willSet {
            self.resetItemContentSubview(model: newValue)
        }
    }
    weak var delete : UICollectionViewCellClick?
    let bigImgView = UIButton.init()
    let iconImageView = UIImageView.init()
    let nameLbl = UILabel()
    let timeLbl = UILabel()
    let descripLbl = UILabel()
    let backgroundImgView = UIImageView()
    var currentPage : String = "1"
    var circleID : String = "" 
    var circleModels  : [BaseControlModel]? = [BaseControlModel](){
        willSet{//动态设置附近的人现实还是隐藏

        }
        didSet{
            if circleModels != nil  {
                if circleModels!.count > 0  {
                    self.hiddenSubViews(isHidden: false)
                    self.collection.reloadData()
                }else{
                    self.backgroundImgView.image = UIImage(named: "emptyMultilens")
                    self.hiddenSubViews(isHidden: true)
                }
            }else{
                
                self.backgroundImgView.image = UIImage(named: "emptyMultilens")
                self.hiddenSubViews(isHidden: true)
            }
            
        }
    }
    var memberModels  : [BaseControlModel] = [BaseControlModel](){
        willSet{//动态设置附近的人现实还是隐藏
            
        }
        didSet{
            self.collection.reloadData()
        }
    }
    
    
    
    lazy var collection : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: self.subcellWidth, height: self.subcellWidth)
        let temp = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        temp.register(GDCollectionImageCell.self , forCellWithReuseIdentifier: "GDCollectionImageCell")
        return temp
    }()
//    var model  : BaseControlModel = BaseControlModel(dict : nil )
        /*{
        var tempModel = BaseControlModel(dict: nil)
        tempModel.imageUrl = "https://gd2.alicdn.com/imgextra/i2/419536424/TB2m6J6e9JjpuFjy0FdXXXmoFXa-419536424.jpg"
        tempModel.subImageUrl = "https://gd2.alicdn.com/imgextra/i2/419536424/TB2m6J6e9JjpuFjy0FdXXXmoFXa-419536424.jpg"
        var items = [BaseControlModel]()
        for picIndex in 0...7{
            let picDict = ["imageUrl":"https://gd2.alicdn.com/imgextra/i2/419536424/TB2m6J6e9JjpuFjy0FdXXXmoFXa-419536424.jpg" ]
            let picModel = BaseControlModel(dict: picDict as [String : AnyObject]?)
            items.append(picModel)
        }
        tempModel.items = items
        return tempModel
        }()*/
//        {
//        willSet {
//            self.iconImageView.sd_setImage(with: URL(string: newValue.imageUrl!))
//            self.bigImgView.sd_setImage(with: URL(string: newValue.imageUrl!))
//        }
//    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCollection()
        self.setupSubviews()
        self.contentView.backgroundColor = homeBackgroundColor
        self.bigImgView.backgroundColor = homeBackgroundColor
        self.iconImageView.backgroundColor = homeBackgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews()  {
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(nameLbl)
        self.contentView.addSubview(timeLbl)
        self.contentView.addSubview(descripLbl)
        self.contentView.addSubview(backgroundImgView)
        backgroundImgView.contentMode = UIViewContentMode.scaleAspectFit
        self.contentView.addSubview(bigImgView)
        bigImgView.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.timeLbl.textAlignment = NSTextAlignment.right
        
//        self.bigImgView.image = UIImage(named: "bg_icon_im")
        self.bigImgView.setImage(UIImage(named: "qieziImgPlaceholder"), for: UIControlState.normal)
//        self.iconImageView.image = UIImage(named: "qieziImgPlaceholder")
        self.nameLbl.text = "andlu"
        self.nameLbl.textColor = homeTextColor
        self.timeLbl.text = "1sectionAgo"
        self.timeLbl.textColor = homeTextColor
        self.descripLbl.text = "hello everyone this is my album"
        self.descripLbl.textColor = homeTextColor
        self.bigImgView.adjustsImageWhenHighlighted = false
        self.bigImgView.addTarget(self , action: #selector(bigImageClick), for: UIControlEvents.touchUpInside)
        bigImgView.backgroundColor = UIColor.white
//        bigImgView.imageView?.contentMode = UIViewContentMode.scaleToFill
        
    }
    func setupCollection ()  {
        let itemW : CGFloat = self.subcellWidth
        let itemH = itemW
        collection.delegate = self
        collection.dataSource = self
        collection.alwaysBounceVertical = false
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = homeBackgroundColor
        self.contentView.addSubview(collection)
        collection.mj_footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
        
    }
    func loadMore()  {
        self.delete?.circleMediaLoadmore!(item: self)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
//        mylog(self.circleModels)
        if circleModels == nil  {
            return 0
        }
        return circleModels!.count
    }
    func bigImageClick()  {
        mylog("点击大图 媒体id是 : \(self.selectedItemModel?.extensionTitle) imgUrl:\(self.selectedItemModel?.imageUrl)")
        self.delete?.collectionViewCellClick?(item: self)
        
    }
    func hiddenSubViews(isHidden:Bool)  {
        self.bigImgView.isHidden = isHidden
        self.collection.isHidden = isHidden
        self.iconImageView.isHidden = isHidden
        self.nameLbl.isHidden = isHidden
        self.timeLbl.isHidden = isHidden
        self.descripLbl.isHidden = isHidden
        self.backgroundImgView.isHidden = !isHidden
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let collectionItemW : CGFloat = self.subcellWidth
        let bigImgViewW : CGFloat = self.bounds.size.width - collectionItemW
        let bottomH = self.bounds.size.height - bigImgViewW
        let bottomW = self.bounds.size.width //bigImgViewW
        self.backgroundImgView.frame = self.bounds
        self.bigImgView.frame = CGRect(x: 0, y: 0, width: bigImgViewW, height: bigImgViewW)
        self.collection.frame =  CGRect(x: bigImgViewW, y: 0, width: collectionItemW, height: self.bounds.size.height - bottomH)
        let iconMarginToBorder : CGFloat = 13.0
        self.iconImageView.frame = CGRect(x: iconMarginToBorder, y: bigImgViewW + iconMarginToBorder, width: bottomH - iconMarginToBorder, height: bottomH - iconMarginToBorder)
        let txtMargin : CGFloat = 10
        self.nameLbl.frame = CGRect(x: self.iconImageView.frame.maxX + txtMargin * 4, y: self.iconImageView.frame.minY, width: (bottomW - bottomH - txtMargin * 2) / 2  , height: self.nameLbl.font.lineHeight)
        self.timeLbl.frame = CGRect(x: self.nameLbl.frame.maxX, y: self.iconImageView.frame.minY, width: bottomW - self.nameLbl.frame.maxX - txtMargin * 2 , height: self.timeLbl.font.lineHeight)
        
        self.descripLbl.frame = CGRect(x: self.iconImageView.frame.maxX + txtMargin, y: self.bounds.size.height - self.descripLbl.font.lineHeight, width: bottomW - bottomH - txtMargin, height: self.descripLbl.font.lineHeight)
        
        
    }
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let item  = collectionView.dequeueReusableCell(withReuseIdentifier: "GDCollectionImageCell", for: indexPath)
        item.backgroundColor = UIColor.white
        if let cell  = item as? GDCollectionImageCell {
            //set model
            cell.model = self.circleModels![indexPath.item]
            return cell
        }
        mylog(item)
        return item
        
    }
    //点击小图代理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = collectionView.cellForItem(at: indexPath)
        if let itemReal  = item as? GDCollectionImageCell {
            self.selectedItemModel = itemReal.model
            self.delete?.collectionViewCellClick?(item: itemReal)
            mylog(itemReal.model.imageUrl)

        }
    }
    
    func resetItemContentSubview(model : BaseControlModel?) {
        if model != nil   && self.circleModels != nil &&  self.circleModels!.count > 0{
            if let modelImgUrlStr =  model?.imageUrl{
                let bigImgUrl  = URL(string: modelImgUrlStr)
                if let urlReal  = bigImgUrl {
//                    self.bigImgView.setImageFor(UIControlState.normal, with: urlReal)
                    self.bigImgView.sd_setImage(with: urlReal, for: UIControlState.normal, placeholderImage: nil , options:  [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])

//                    self.bigImgView.sd_setImage(with: urlReal)
                }
            }
            if let modelImgUrlStr =  model?.additionalImageUrl{
                let iconUrl  = URL(string: modelImgUrlStr)
                if let urlReal  = iconUrl {
                    self.iconImageView.sd_setImage(with: urlReal)
                    
                }
            }
            self.nameLbl.text = model?.title
            self.timeLbl.text =  (model?.extensionTitle1 ?? "") + " " + (model?.subTitle ?? "" )  
            self.descripLbl.text = model?.additionalTitle
            
            self.nameLbl.sizeToFit()
            self.timeLbl.sizeToFit()
            
            let iconMarginToBorder : CGFloat = 5.0
            self.nameLbl.frame = CGRect(x: self.iconImageView.frame.maxX + 5 , y: self.timeLbl.frame.origin.y, width: self.nameLbl.bounds.size.width, height: self.timeLbl.bounds.size.height)
            self.timeLbl.frame = CGRect(x: self.nameLbl.frame.maxX + 5, y: self.nameLbl.frame.minY, width: self.bounds.size.width - self.nameLbl.frame.maxX - 5 * 2 , height: self.timeLbl.bounds.size.height)
            

            
            
            
        }else{
//            self.bigImgView.image = nil
            self.bigImgView.setImage(nil, for: UIControlState.normal)
            self.iconImageView.image = nil
            self.nameLbl.text = nil
            self.timeLbl.text = nil
            self.descripLbl.text = nil

        }
        self.collection.reloadData()
        
    }
    
    
    //    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    //        if let collection = scrollView as? UICollectionView {
    //            let cells = collection.visibleCells
    //            let index = collection.indexPath(for: cells.last!)
    //            self.pageControl.currentPage = (index?.item)!
    //        }
    //
    //    }
    
}
