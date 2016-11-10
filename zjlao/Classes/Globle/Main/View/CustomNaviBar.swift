//
//  CustomNaviBar.swift
//  mh824appWithSwift
//
//  Created by wangyuanfei on 16/8/25.
//  Copyright © 2016年 www.16lao.com. All rights reserved.
//



import UIKit

@objc protocol CustomNaviBarDelegate {
    func popToPreviousVC() -> Void
}


    enum NaviBarType {
        case withBackBtn
        case withoutBackBtn
    }
class CustomNaviBar: UIView {
    weak var delegate  :  CustomNaviBarDelegate?
    let backBtn = UIButton(frame: CGRect(x: 0, y: 20, width: 44, height: 44))
   fileprivate let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 88.0, height: 44))
    var title : NSAttributedString {
        set{
            titleLabel.isHidden = false
            titleLabel.attributedText =  newValue
        }
        get{
            if let a = titleLabel.attributedText {
                return a
            }else{
                return NSAttributedString()
            }
        }
    }
    
    var  currentType : NaviBarType  = .withBackBtn
    
//    var backBtnHidden : Bool {//计算属性
//        get {
//            return self.backBtn.hidden
//        }
//        set{
//            self.backBtn.hidden = backBtnHidden
//        }
//    }
//    var test : CGFloat = 10 {//存储属性
//        willSet{
////            newValue/oldValue 
//        }
//        didSet{
//        
//        }
//    }
    
    
    
    let leftSubViewsContainer : UIView = UIView()

    
    var leftBarButtons  = [UIView]() {
        
        willSet{
            
        }
        didSet{
            for oldSub in leftSubViewsContainer.subviews {
                oldSub.removeFromSuperview()
            }
            
            if currentType == .withBackBtn {
                let leftSubViewsContainerW = 44.0  * CGFloat( leftBarButtons.count)  > UIScreen.main.bounds.size.width * 0.5 - 44.0 ? UIScreen.main.bounds.size.width * 0.5 - 44.0 : CGFloat( 44 * leftBarButtons.count)
                leftSubViewsContainer.frame = CGRect(x: 44, y: 20, width: leftSubViewsContainerW, height: 44)
                for (index , newSub) in leftBarButtons.enumerated() {
                    if 44.0  * CGFloat(index+1)  > UIScreen.main.bounds.size.width * 0.5 - 44.0 {
                        leftSubViewsContainer.frame = CGRect(x: 44, y: 20, width: 44.0  * CGFloat(index), height: 44)
                        return
                    }
                    
                    leftSubViewsContainer.addSubview(newSub)
                    newSub.frame = CGRect(x: index * 44, y: 0, width: 44, height: 44)
                    
                }
            }else{
                let leftSubViewsContainerW = 44.0  * CGFloat( leftBarButtons.count)  > UIScreen.main.bounds.size.width * 0.5  ? UIScreen.main.bounds.size.width * 0.5 : CGFloat( 44 * leftBarButtons.count)
                leftSubViewsContainer.frame = CGRect(x: 0, y: 20, width: leftSubViewsContainerW, height: 44)
                for (index , newSub) in leftBarButtons.enumerated() {
                    if 44.0  * CGFloat(index+1)  > UIScreen.main.bounds.size.width * 0.5  {
                        leftSubViewsContainer.frame = CGRect(x: 0, y: 20, width: 44.0  * CGFloat(index), height: 44)
                        return
                    }
                    
                    leftSubViewsContainer.addSubview(newSub)
                    newSub.frame = CGRect(x: index * 44, y: 0, width: 44, height: 44)
                }
            }
            

        }
        
    }
    
    
    
    let rightSubViewsContainer : UIView = UIView()
    
    var rightBarButtons  = [UIView]() {
        
        willSet{
            
        }
        didSet{
            for oldSub in rightSubViewsContainer.subviews {
                oldSub.removeFromSuperview()
            }
            let rightSubViewsContainerW = 44.0  * CGFloat( rightBarButtons.count)  > UIScreen.main.bounds.size.width * 0.5  ? UIScreen.main.bounds.size.width * 0.5  : CGFloat( 44 * rightBarButtons.count)
            rightSubViewsContainer.frame = CGRect(x: UIScreen.main.bounds.size.width - rightSubViewsContainerW, y: 20, width: rightSubViewsContainerW, height: 44)
            for (index , newSub) in rightBarButtons.enumerated() {
                if 44.0  * CGFloat(index + 1 )  > UIScreen.main.bounds.size.width * 0.5  {
                    rightSubViewsContainer.frame = CGRect(x: UIScreen.main.bounds.size.width - 44.0 * CGFloat(index), y: 20, width: 44.0  * CGFloat(index), height: 44)
                    return
                }
                
                rightSubViewsContainer.addSubview(newSub)
                newSub.frame = CGRect(x: index * 44, y: 0, width: 44, height: 44)
            }
        }
        
    }
    
    var navTitleView   =  NavTitleView(){
        willSet {
            navTitleView.removeFromSuperview()
        }
        
        didSet {
            self.addSubview(navTitleView)
            let inset =   navTitleView.insets
            var x : CGFloat = 0.0
            let y : CGFloat = 20 + inset.top
            var w : CGFloat = 0.0
            let h : CGFloat = 44.0 - inset.top - inset.bottom
            
            
            
            if leftBarButtons.count>0 && rightBarButtons.count>0 {//左右都有
                x = leftSubViewsContainer.frame.maxX + inset.left
//                y = inset.top
                w = rightSubViewsContainer.frame.minX - inset.right - x
//                h = 44.0 - inset.top - inset.bottom
            }else if leftBarButtons.count>0{//左有 ,右没有
                x = leftSubViewsContainer.frame.maxX + inset.left
                w = UIScreen.main.bounds.size.width - inset.right - x
            }else if rightBarButtons.count>0{//左没有,右有
                x = backBtn.frame.maxX + inset.left
                w = rightSubViewsContainer.frame.minX - inset.right - x
            }else {//左右都没有
                x = backBtn.frame.maxX + inset.left
                w = UIScreen.main.bounds.size.width - inset.right - x
            }
            navTitleView.frame = CGRect(x: x, y: y, width: w, height: h);
        }
    }
    convenience init(type:NaviBarType){
        self.init(frame: CGRect.zero)
        currentType = type
        switch currentType {
        case .withBackBtn:
            leftSubViewsContainer.backgroundColor = UIColor.randomColor()
            rightSubViewsContainer.backgroundColor = UIColor.randomColor()
            
            self.addSubview(backBtn)
            self.addSubview(leftSubViewsContainer)
            self.addSubview(rightSubViewsContainer)
            backBtn.backgroundColor = UIColor.randomColor()
            backBtn.addTarget(self, action:#selector(backAction(_:)) , for:UIControlEvents.touchUpInside)
            break
        case .withoutBackBtn:
            leftSubViewsContainer.backgroundColor = UIColor.randomColor()
            rightSubViewsContainer.backgroundColor = UIColor.randomColor()
            self.addSubview(leftSubViewsContainer)
            self.addSubview(rightSubViewsContainer)
            break

        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.isHidden = true;
        titleLabel.textAlignment = NSTextAlignment.center
        self.addSubview(titleLabel)
        titleLabel.center = CGPoint(x: UIScreen.main.bounds.size.width/2.0, y: 42);
        leftSubViewsContainer.backgroundColor = UIColor.randomColor()
        rightSubViewsContainer.backgroundColor = UIColor.randomColor()

//        self.addSubview(backBtn)
        self.addSubview(leftSubViewsContainer)
        self.addSubview(rightSubViewsContainer)
        backBtn.backgroundColor = UIColor.randomColor()
        backBtn.addTarget(self, action:#selector(backAction(_:)) , for:UIControlEvents.touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**更改自身透明度的方法*/
    func changeAlpha(_ value : CGFloat) -> Void {
        self.alpha = value
        
    }
    /**更改背景色透明度*/
    func changeBackgroundColorAlpha(_ value : CGFloat) -> Void {
        
        self.backgroundColor = THEMECOLOR!.withAlphaComponent(value)
    }
    @objc fileprivate  func backAction(_ sender : UIButton) -> () {
        
        delegate?.popToPreviousVC()
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
