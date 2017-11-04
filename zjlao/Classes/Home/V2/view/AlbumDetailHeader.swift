//
//  AlbumDetailHeader.swift
//  zjlao
//
//  Created by WY on 2017/10/25.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SnapKit

class AlbumDetailHeader: UICollectionReusableView,UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var creatTime: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var model  = AlbumDetailHeaderModel(dict:nil){
        didSet{
            creatTime.text = "创建于 " + model.create_at
            nameLabel.text =  model.album_name
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if model.membersModel.count == 0{return}
        let itemMargin : CGFloat = 2
        let itemSize = CGSize(width: 28, height: 28)
        var  collectionWidth =  itemSize.width * CGFloat(model.membersModel.count) + itemMargin * CGFloat (model.membersModel.count - 1)
        collectionWidth = min(collectionWidth, self.bounds.width)
        collection.snp.remakeConstraints { (make ) in
            make.height.equalTo(28)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(30)
            make.width.equalTo(collectionWidth)
        }
    }
    func configCollectionView() {
        collection.delegate = self
        collection.dataSource = self
        self.collection.register(AlbumMemberView.self, forCellWithReuseIdentifier: "AlbumMemberView")
        collection.backgroundColor = .white
        collection.showsHorizontalScrollIndicator = false 
        collection.setCollectionViewLayout(self.switchFlowLayout(direction: UICollectionViewScrollDirection.horizontal), animated: true)
        //        self.configRefresh()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){}
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.membersModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumMemberView", for: indexPath)
        if let realCell = cell as? AlbumMemberView {
//            realCell.model = self.albumMedias[indexPath.item]
            return realCell
        }
        return cell
    }
    func switchFlowLayout(direction : UICollectionViewScrollDirection) -> UICollectionViewFlowLayout {
        let flowlayout = UICollectionViewFlowLayout()
        if  direction == UICollectionViewScrollDirection.vertical {
            flowlayout.scrollDirection = UICollectionViewScrollDirection.vertical
            flowlayout.minimumLineSpacing = 2
            flowlayout.minimumInteritemSpacing = 2
            let itemW = 28.0
            flowlayout.itemSize = CGSize(width: itemW, height: itemW)

        }else{
            let itemW = 28.0
            flowlayout.scrollDirection = UICollectionViewScrollDirection.horizontal
            flowlayout.minimumLineSpacing = 2
            flowlayout.minimumInteritemSpacing = 2
            flowlayout.itemSize = CGSize(width: itemW, height: itemW)

        }
        
        return flowlayout
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collection.isHidden = true 
//        self.configCollectionView()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        /**/
        
        if ((self.traitCollection.verticalSizeClass   != previousTraitCollection?.verticalSizeClass)
            || (self.traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass)) {
            // your custom implementation here
            if self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.regular{//竖屏
                self.collection.setCollectionViewLayout(self.switchFlowLayout(direction: UICollectionViewScrollDirection.vertical), animated: true)
            }else{//横屏
                self.collection.setCollectionViewLayout(self.switchFlowLayout(direction: UICollectionViewScrollDirection.horizontal), animated: true)
            }
        }
                self.collection.reloadData()
    }
}
