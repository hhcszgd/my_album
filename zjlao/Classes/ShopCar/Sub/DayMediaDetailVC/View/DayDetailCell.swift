//
//  DayDetailCell.swift
//  zjlao
//
//  Created by WY on 21/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit

class DayDetailCell: GDBaseCell {
    weak var delegate : GDTrendsCellDelegate?

    let dLbl = UILabel()
    let myLbl = UILabel()
    let wLbl = UILabel()
    
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
                var targetText  : String = ""
                if let tempYear  = cellModel.y {
                    targetText.append(tempYear)
                }
                if let tempMonth = cellModel.m {
                    targetText.append("-\(tempMonth)")
                }

                self.myLbl.text = targetText
                if (cellModel.items == nil  ){return}
                for (_ , model) in (cellModel.items?.enumerated())! {
                    let pic = GDPicView.init(frame: CGRect.zero)
                    pic.addTarget(self , action: #selector(subitemClick(sender:)), for: UIControlEvents.touchUpInside)
                    if let controlModel  = model as? BaseControlModel {
                        pic.controlModel = controlModel
                        self.picsContainer.addSubview(pic)
                    }
                }
            }
            
        }
        get{return super.model}
    }
    
    func subitemClick(sender:GDPicView)  {
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
        self.picsContainer.backgroundColor = UIColor(red: 240 / 256, green:  240 / 256, blue:  240 / 256, alpha: 1)
        
        
        self.contentView.addSubview(topContainer)
        self.contentView.addSubview(picsContainer)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
    }
    func seeMoreClick(sender:UIButton) {
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 2.0
        let topH : CGFloat = 44.0
        let picW : CGFloat = (SCREENWIDTH - 3 * margin ) / 4
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
        dLbl.frame = CGRect(x: 10, y: 0, width: topH, height: topH)
        wLbl.frame = CGRect(x: dLbl.frame.maxX, y: topH/2 - wLbl.font.lineHeight, width: 188, height: wLbl.font.lineHeight)
        myLbl.frame = CGRect(x: wLbl.frame.origin.x, y: topH/2 , width: wLbl.frame.size.width, height: wLbl.frame.size.height)
      
        picsContainer.frame = CGRect(x: 0, y: topH, width: self.bounds.size.width, height: bottomH)
        for (index , view) in self.picsContainer.subviews.enumerated() {
            let theRow = index  / 4
            let indexInRow = index  % 4
            view.frame = CGRect(x: CGFloat(indexInRow) * picW + CGFloat(indexInRow ) * margin, y: CGFloat(theRow) * picH + CGFloat(theRow + 1) * margin, width: picW, height: picH)
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
