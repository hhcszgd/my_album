//
//  SiftView.swift
//  zjlao
//
//  Created by WY on 2017/10/25.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SnapKit
@objc protocol SiftViewDidSelectProtocol {
    @objc func didSelectItem(item : ChooseTimeItem)
}
class SiftView: UIControl,UICollectionViewDataSource, UICollectionViewDelegate {
    let collectionView  = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    lazy var titles : [String]  = {
        return ["一个月内","1~3个月","3~6个月","6~12个月","1~2年","2年以上"]
    }()
    weak var delegate : SiftViewDidSelectProtocol?
    override init(frame: CGRect) {
        super.init(frame: frame )
        self.configCollectionView()
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configCollectionView() {
        self.addSubview(collectionView)

        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(ChooseTimeItem.self, forCellWithReuseIdentifier: "ChooseTimeItem")
        //        self.collectionView.register(AlbumDetailHeader.self , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "DDHeader")
//        self.collectionView.register(UINib.init(nibName: "AlbumDetailHeader", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "DDHeader")
//
//        self.collectionView.register(UICollectionReusableView.self , forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
        collectionView.backgroundColor = .white
        
        //        self.configRefresh()
    }
    func switchFlowLayout(direction : UICollectionViewScrollDirection) -> UICollectionViewFlowLayout {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumLineSpacing = 13
        flowlayout.minimumInteritemSpacing = 3
        if  direction == UICollectionViewScrollDirection.vertical {
            flowlayout.scrollDirection = UICollectionViewScrollDirection.vertical
            flowlayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20)

            let itemW = (self.bounds.width - flowlayout.minimumInteritemSpacing   - flowlayout.sectionInset.left - flowlayout.sectionInset.right  )/2

            let itemH = (self.bounds.width - flowlayout.minimumInteritemSpacing * 4   - flowlayout.sectionInset.top - flowlayout.sectionInset.bottom  )/3
            
            flowlayout.itemSize = CGSize(width: max ( itemW , 0.1) , height: max(itemH , 0.1))
            //            flowlayout.headerReferenceSize =  CGSize(width: 100, height: 118)
//            flowlayout.footerReferenceSize = CGSize(width: 100, height: 0)
            if #available(iOS 9.0, *) {
                flowlayout.sectionHeadersPinToVisibleBounds = true
            } else {
                // Fallback on earlier versions
            }
        }else{
            flowlayout.minimumLineSpacing = 3
            flowlayout.minimumInteritemSpacing = 3
            let itemW = (self.bounds.width - flowlayout.minimumInteritemSpacing   - flowlayout.sectionInset.left - flowlayout.sectionInset.right  )/2
            
            let itemH = (self.bounds.width - flowlayout.minimumInteritemSpacing * 4   - flowlayout.sectionInset.top - flowlayout.sectionInset.bottom  )/3
            
            flowlayout.itemSize = CGSize(width: max ( itemW , 1) , height: max(itemH , 1))
            flowlayout.scrollDirection = UICollectionViewScrollDirection.vertical//horizontal
            
//            flowlayout.headerReferenceSize =  CGSize(width: 100, height: 118)
//            flowlayout.footerReferenceSize = CGSize(width: 100, height:0)
            if #available(iOS 9.0, *) {
                flowlayout.sectionHeadersPinToVisibleBounds = true
            } else {
                // Fallback on earlier versions
            }
            //            flowlayout.sectionInset = UIEdgeInsetsMake(20, 10, 10, 10)
        }
        
        return flowlayout
        
    }
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
//    {
//        if  kind == UICollectionElementKindSectionHeader {
//
//            let reuseView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "DDHeader", for: indexPath)
//            if let header = reuseView as? AlbumDetailHeader{
//                header.model = headerModel
//            }
//            return reuseView
//        }else{
//
//            let reuseView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer", for: indexPath)
//            return reuseView
//        }
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        self.delegate?.didSelectItem(item: collectionView.cellForItem(at: indexPath) as! ChooseTimeItem)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseTimeItem", for: indexPath)
        if let realCell = cell as? ChooseTimeItem {
            realCell.label.text = titles[indexPath.item]
            return realCell
        }
        return cell
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.setCollectionViewLayout(self.switchFlowLayout(direction: UICollectionViewScrollDirection.vertical), animated: true )
//        self.collectionView.snp.makeConstraints { (make ) in
//            make.left.right.bottom.top.equalToSuperview()
//        }
        self.collectionView.frame = self.bounds
        self.collectionView.reloadData()
    }

}
