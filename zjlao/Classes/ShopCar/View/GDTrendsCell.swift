//
//  GDTrendsCell.swift
//  zjlao
//
//  Created by WY on 17/4/2.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//
/**
 一排最多四张 , 最多三排
 */
import UIKit
import SnapKit

protocol GDTrendsCellDelegate : NSObjectProtocol{
    func trendsCellItemClick(model : BaseControlModel ,  imageControl : GDPicView)
    func trendsCellMoreClick(model : GDTrendsCellModel)
}
class GDTrendsCell: GDBaseCell {
    weak var delegate : GDTrendsCellDelegate?
    let dLbl = UILabel()
    let myLbl = UILabel()
    let wLbl = UILabel()
    let seeMore = UIButton()

    let topContainer = UIView()
    
    let picsContainer = UIView()
    
    override var model: GDBaseModel?{
        set{
            super.model = newValue
            for view in self.picsContainer.subviews {
                view.removeFromSuperview()
            }
            if let cellModel  =  model as? GDTrendsCellModel {
                self.dLbl.text = cellModel.d
                self.wLbl.text = cellModel.w
//                cellModel.my?.range(of: <#T##String#>)
                let a = cellModel.my?.index((cellModel.my?.endIndex)!, offsetBy: -3)
                let b = cellModel.my?.endIndex
//                Range 
                
                let c = a! ..< b!
                self.myLbl.text = cellModel.my?.replacingCharacters(in: c, with: "")
                
                if (cellModel.items == nil  ){return}
                for (index , model) in (cellModel.items?.enumerated())! {
                    if index >= 12 {return }
                    let pic = GDPicView.init(frame: CGRect.zero)
                    pic.addTarget(self , action: #selector(subitemClick(sender:)), for: UIControlEvents.touchUpInside)
                    if let controlModel  = model as? BaseControlModel {
                        pic.controlModel = controlModel
//                        mylog(controlModel.imageUrl)
//                        mylog(controlModel.extensionTitle2)
                        self.picsContainer.addSubview(pic)
                    }
                }
            }

        }
        get{return super.model}
    }
    
    @objc func subitemClick(sender:GDPicView)  {
        mylog(sender.controlModel?.title)
        mylog(sender.controlModel?.subTitle)
        mylog(sender.controlModel?.imageUrl)
        self.delegate?.trendsCellItemClick(model: sender.controlModel ?? BaseControlModel.init(dict: nil ), imageControl: sender)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.topContainer.addSubview(dLbl)
        self.topContainer.addSubview(myLbl)
        self.topContainer.addSubview(wLbl)
        dLbl.font = GDFont.systemFont(ofSize: 31)
        myLbl.font = GDFont.systemFont(ofSize: 13)
        wLbl.font = GDFont.systemFont(ofSize: 13)
        self.topContainer.backgroundColor = UIColor.white
        self.picsContainer.backgroundColor = contentBackgroundColor
        self.topContainer.addSubview(self.seeMore)
//        self.seeMore.setTitle("查看更多>>>", for: UIControlState.normal)
        self.seeMore.setImage(UIImage(named: "arrowLight"), for: UIControlState.normal)
        self.seeMore.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        self.seeMore.setTitleColor(UIColor.blue, for: UIControlState.normal)
        self.seeMore.addTarget(self, action: #selector(seeMoreClick(sender:)), for: UIControlEvents.touchUpInside)
        
        self.contentView.addSubview(topContainer)
        self.contentView.addSubview(picsContainer)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
    }
    @objc func seeMoreClick(sender:UIButton) {
        if let targetModel  = self.model as? GDTrendsCellModel{
            self.delegate?.trendsCellMoreClick(model: targetModel)
            
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 5.0
        let topH : CGFloat = 44.0
        let picW : CGFloat = (SCREENWIDTH - 5 * margin ) / 4
//        let picW : CGFloat = (SCREENWIDTH - 3 * margin ) / 4

        let picH : CGFloat = picW
        let rows = self.picsContainer.subviews.count / 4
        let left = self.picsContainer.subviews.count % 4
        var bottomH : CGFloat = 0
        if  left == 0  {
            bottomH = CGFloat(rows) * picW + CGFloat(rows + 1) * margin
        }else{
            bottomH = CGFloat(rows + 1) * picW + CGFloat(rows + 2) * margin
        }
        
        
        topContainer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: topH)
        dLbl.frame = CGRect(x: 10, y: 0, width: topH * 1, height: topH)
        wLbl.frame = CGRect(x: dLbl.frame.maxX, y: topH/2 - wLbl.font.lineHeight, width: 188, height: wLbl.font.lineHeight)
        myLbl.frame = CGRect(x: wLbl.frame.origin.x, y: topH/2 , width: wLbl.frame.size.width, height: wLbl.frame.size.height)
        seeMore.frame = CGRect(x: topContainer.bounds.size.width - topH / 2  , y: topH / 4 , width: topH / 2 , height: topH / 2)
        picsContainer.frame = CGRect(x: 0, y: topH, width: self.bounds.size.width, height: bottomH)
        for (index , view) in self.picsContainer.subviews.enumerated() {
            let theRow = index  / 4
            let indexInRow = index  % 4
            view.frame = CGRect(x: CGFloat(indexInRow) * (picW +  margin ) + margin/*CGFloat(indexInRow + 1 ) * margin*/, y: CGFloat(theRow) * picH + CGFloat(theRow + 1) * margin, width: picW, height: picH)
        }
//        if self.model?.items?.count ?? 0 >= 12  {
//            self.seeMore.isHidden = false
//        }else{self.seeMore.isHidden = true}
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
