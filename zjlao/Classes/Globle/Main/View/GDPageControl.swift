//
//  GDPageControl.swift
//  zjlao
//
//  Created by WY on 17/4/5.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
enum GDAlignment {
    case center
    case left
    case right
}
protocol GDPageControlDelegate : NSObjectProtocol {
    func currentPageChanged(currentPage:Int ) 
}
class GDPageControl: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    weak var delegate : GDPageControlDelegate?
    
    var selectedImage : UIImage?
    var normalImage : UIImage?
    
    var previousOffset : CGPoint = CGPoint.zero

    var scrollView : UIScrollView?{
        didSet{
            
            scrollView?.addObserver(self , forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
            /*
            if let collection = scrollView as? UICollectionView {
                if let flowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout  {
                    let direction :  UICollectionViewScrollDirection =  flowLayout.scrollDirection
                    if direction == UICollectionViewScrollDirection.vertical {
                        
                    }else{
                        
                        
                        
                    }
                }
                let offset = collection.contentOffset
                let index  : Int = Int( offset.x / collection.bounds.size.width )
                if offset.x > self.previousOffset.x { // xiang you
                    if offset.x > collection.contentSize.width - collection.bounds.size.width{return}
                    let pass = offset.x -  CGFloat(index) * collection.bounds.size.width
                    if abs(pass) > collection.bounds.size.width / 2 {
                        self.currentPage = index + 1
                        //                    mylog("nvnvnvnvvnvnvn")
                    }
                }else{//xiang zuo
                    if offset.x < 0  {return}
                    let less = CGFloat(index + 1) * collection.bounds.size.width - offset.x
                    //                mylog(abs(less))
                    if abs(less) > collection.bounds.size.width / 2 {
                        self.currentPage = index
                    }
                }
                self.previousOffset = offset
            }

        */
        }
    }
    
    
    var align : GDAlignment = GDAlignment.center
    var selectedBtn = UIButton()
    var numberOfPages : Int  = 0 {
        willSet{
            for view  in self.subviews { view.removeFromSuperview() }
            for index  in 0..<newValue {
                let btn = UIButton()
                btn.adjustsImageWhenHighlighted = false
                self.addSubview(btn)
                if index == 0 {
                    if let tempSelectedImg = self.selectedImage {
                        btn.setImage(tempSelectedImg, for: UIControlState.selected)
                    }else{
                        btn.setImage(UIImage(named: "tinyStar"), for: UIControlState.selected)
                    }
                    if let tempNormalImg = self.normalImage {
                        btn.setImage(tempNormalImg, for: UIControlState.normal)
                    }else{
                        btn.setImage(UIImage(named: "tinyBlackStar"), for: UIControlState.normal)
                    }
                    self.selectedBtn = btn
                    self.currentPage = 0
                }else{
                    if let tempSelectedImg = self.selectedImage {
                        btn.setImage(tempSelectedImg, for: UIControlState.selected)
                    }else{
                        btn.setImage(UIImage(named: "whiteDot"), for: UIControlState.selected)
                    }
                    if let tempNormalImg = self.normalImage {
                        btn.setImage(tempNormalImg, for: UIControlState.normal)
                    }else{
                        btn.setImage(UIImage(named: "blackDot"), for: UIControlState.normal)
                    }
                }
            }
        }
    }
    var currentPage : Int  = 0 {
        willSet{
            if newValue >= self.subviews.count || newValue < 0{return}
            self.selectedBtn.isSelected = false
            self.selectedBtn = self.subviews[newValue] as! UIButton
            self.selectedBtn.isSelected = true
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let itemW : CGFloat = 10
        let itemH  = itemW
        let margin : CGFloat = 0
        let totalWidth = CGFloat(self.subviews.count) * (itemW + margin) + margin
        let originFrame = self.frame
        if self.align == GDAlignment.center {
            self.bounds = CGRect(x: 0, y: 0, width: totalWidth, height: itemH)
            self.center = CGPoint(x: (self.superview?.center.x)!, y: originFrame.origin.y + itemH / 2)
        }else if (self.align == GDAlignment.left){
            self.frame = CGRect(x: 0, y: originFrame.origin.y, width: totalWidth, height: itemH)
        }else if (self.align == GDAlignment.right){
            self.frame = CGRect(x: (self.superview?.bounds.size.width)! - totalWidth, y: originFrame.origin.y, width: totalWidth, height: itemH)
        }
        for (index , view ) in self.subviews.enumerated() {
            view.frame = CGRect(x: margin + CGFloat(index) * (margin + itemW), y: 0, width: itemW, height: itemH)
        }
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil  {
            self.scrollView?.removeObserver(self , forKeyPath: "contentOffset")
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    deinit {
//        self.scrollView.removeObserver(self , forKeyPath: "contentOffset")
//    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath! == "contentOffset" {
            if let newPoint = change?[NSKeyValueChangeKey.newKey] as? CGPoint{
                //                mylog("监听contentOffset\(newPoint)")//下拉变小
                let offset = newPoint
                var scrollViewWidth : CGFloat =  0
                if let scrollview = self.scrollView {
                    scrollViewWidth = scrollview.bounds.size.width
                }
                
                let index  : Int = Int( offset.x / scrollViewWidth )
                if offset.x > self.previousOffset.x { // xiang you
                    if offset.x > scrollView?.contentSize.width   ?? 0 - scrollViewWidth{return}
                    let pass = offset.x -  CGFloat(index) * scrollViewWidth
                    if abs(pass) > scrollViewWidth / 2 {
                        if self.currentPage != index + 1 {
                            
                            self.currentPage = index + 1
                            self.delegate?.currentPageChanged(currentPage: self.currentPage)
                        }
                        //                    mylog("nvnvnvnvvnvnvn")
                    }
                }else{//xiang zuo
                    if offset.x < 0  {return}
                    let less = CGFloat(index + 1) * scrollViewWidth - offset.x
                    //                mylog(abs(less))
                    if abs(less) > scrollViewWidth / 2 {
                        if self.currentPage != index {
                            
                            self.currentPage = index
                            self.delegate?.currentPageChanged(currentPage: self.currentPage)
                        }
                    }
                }
                self.previousOffset = offset

                
            }
//            mylog(self.currentPage)
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
