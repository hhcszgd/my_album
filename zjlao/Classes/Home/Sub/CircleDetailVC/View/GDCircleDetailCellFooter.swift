//
//  GDCircleDetailCellFooter.swift
//  zjlao
//
//  Created by WY on 09/06/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit
protocol GDCircleDetailCellFooterDelete : NSObjectProtocol {
    func seeMoreCmmments(mediaID:String)
}
class GDCircleDetailCellFooter: UITableViewHeaderFooterView {
    let  backColor = UIColor(red: 240 / 256, green:  240 / 256, blue:  240 / 256, alpha: 1)
    let countLabel = UILabel()
    let seeMoreBtn = UIButton()
    let line = UIView()
    var mediaID : String?
    
    var commentCount : Int = 0 {
        didSet{
            if commentCount > 2 {
                countLabel.text = " 共有\(commentCount)条评论"
            }
        }
    }
    weak var delegate : GDCircleDetailCellFooterDelete?
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(countLabel)
        self.contentView.addSubview(seeMoreBtn)
        self.countLabel.backgroundColor = backColor
        self.seeMoreBtn.backgroundColor = backColor
        self.seeMoreBtn.setTitle("           查看更多>>>", for: UIControlState.normal)
         let seeMoreColor : UIColor = UIColor(hexString: "#5A6D96")! // UIColor.blue
        self.seeMoreBtn.setTitleColor(seeMoreColor, for: UIControlState.normal)
        self.countLabel.font =  GDFont.systemFont(ofSize: 14)
        self.seeMoreBtn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        self.seeMoreBtn.addTarget(self, action: #selector(seeMoreCmmments(sender:)), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(line)
        if(UIScreen.main.bounds.size.height == 480){//5,5s,5c不变
//            self.seeMoreBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            self.seeMoreBtn.titleLabel?.font = GDFont.systemFont(ofSize: 12)
        }
        line.backgroundColor = UIColor(red: 230 / 256, green:  230 / 256, blue:  230 / 256, alpha: 1)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.commentCount > 2 {
            let margin : CGFloat = 44
            line.frame = CGRect(x: margin , y: 0, width: SCREENWIDTH - margin * 2 , height: 1 )
            let width = (SCREENWIDTH - margin * 2) / 2
            self.countLabel.frame = CGRect(x: margin, y: 0, width: width, height: 30)
            self.seeMoreBtn.frame = CGRect(x: margin + width , y: 0, width: width, height: 30)
            self.countLabel.isHidden = false
            self.seeMoreBtn.isHidden = false
            self.line.isHidden = false
        }else{
            self.line.isHidden = true
            self.countLabel.isHidden = true
            self.seeMoreBtn.isHidden = true
        }
    }
    func seeMoreCmmments(sender:UIButton)  {
        self.delegate?.seeMoreCmmments(mediaID: self.mediaID ?? "0")
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
