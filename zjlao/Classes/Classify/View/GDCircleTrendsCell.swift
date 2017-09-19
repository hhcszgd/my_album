//
//  GDCircleTrendsCell.swift
//  zjlao
//
//  Created by WY on 17/4/3.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
protocol  GDCircleTrendsCellDelete : NSObjectProtocol {
    func imageControlClick(model : BaseControlModel ,  imageControl : GDPicView)
}
class GDCircleTrendsCell: GDBaseCell {
    weak var delete : GDCircleTrendsCellDelete?
    let namesLbl = UILabel()
//    let numBtn = UIButton()
    let cameraIcon = UIImageView()
    let numLabel = UILabel()
    let timeLbl = UILabel()
    let topContainer = UIView()
    let picsContainer = UIView()

    override var model: GDBaseModel?{
        set{
            super.model = newValue
            for view in self.picsContainer.subviews {
                view.removeFromSuperview()
            }
            if let cellModel  =  newValue as? GDCircleTrendsCellModel {
                self.namesLbl.text = cellModel.names
                self.timeLbl.text =  (cellModel.city ?? "") + " " + (cellModel.time ?? "")
                self.numLabel.text = cellModel.num
                var usersStr = ""
                for (index , memeber)  in cellModel.members.enumerated() {

                    if let nameStr  = memeber.title {
                        usersStr = usersStr.appending(nameStr)
                        if index < cellModel.members.count - 1 {
                            usersStr = usersStr.appending("&")
                        }
                    }
                }
                self.namesLbl.text = usersStr

             let count  = cellModel.pictures.count
            let margin : CGFloat = 2.0
//            let topH : CGFloat = 44.0
            let averWidth = (SCREENWIDTH - margin * 5 ) / 4
                let picH : CGFloat = averWidth

            switch count {
            case 1:
                
                for (index , model) in cellModel.pictures.enumerated() {
                    if index == 0 {
                        let frame = CGRect(x: margin, y: margin, width: SCREENWIDTH - margin * 2, height: picH)
                        let pic = GDPicView.init(frame: frame)
                        pic.addTarget(self, action: #selector(picClick(sender:)), for: UIControlEvents.touchUpInside)
                        pic.controlModel = model
                        self.picsContainer.addSubview(pic)
                    }
                }
                
                break
            case 2:
                for (index , model) in cellModel.pictures.enumerated(){
                    if index == 0{
                        let frame  = CGRect(x: margin, y: margin, width: SCREENWIDTH - margin * 3 - averWidth, height: picH)
                        let pic = GDPicView.init(frame: frame)
                         pic.addTarget(self, action: #selector(picClick(sender:)), for: UIControlEvents.touchUpInside)
                        pic.controlModel = model
                        self.picsContainer.addSubview(pic)
                    }else if (index == 1 ){
                        let frame  = CGRect(x: SCREENWIDTH - margin - averWidth, y: margin, width: averWidth, height: picH)
                        let pic = GDPicView.init(frame: frame)
                         pic.addTarget(self, action: #selector(picClick(sender:)), for: UIControlEvents.touchUpInside)
                        pic.controlModel = model
                        self.picsContainer.addSubview(pic)
                    }
                }
                
                break
            case 3:
                for (index , model) in cellModel.pictures.enumerated() {
                    if index == 0{
                        let frame  = CGRect(x: margin, y: margin, width: SCREENWIDTH - margin * 4 - averWidth * 2, height: picH)
                        let pic = GDPicView.init(frame: frame)
                         pic.addTarget(self, action: #selector(picClick(sender:)), for: UIControlEvents.touchUpInside)
                            pic.controlModel = model
                            self.picsContainer.addSubview(pic)
                    }else if (index == 1 ){
                        let frame  = CGRect(x: SCREENWIDTH - (margin + averWidth) * 2, y: margin, width: averWidth, height: picH)
                        let pic = GDPicView.init(frame: frame)
                             pic.addTarget(self, action: #selector(picClick(sender:)), for: UIControlEvents.touchUpInside)
                        pic.controlModel = model
                        self.picsContainer.addSubview(pic)
                    }else if (index == 2 ){
                        let frame  = CGRect(x: SCREENWIDTH - margin - averWidth, y: margin, width: averWidth, height: picH)
                        let pic = GDPicView.init(frame: frame)
                            pic.addTarget(self, action: #selector(picClick(sender:)), for: UIControlEvents.touchUpInside)
                        pic.controlModel = model
                        self.picsContainer.addSubview(pic)
                    }
                }
                
                break
            case 4:
                
                for (index , model) in cellModel.pictures.enumerated() {

                    if index >= 4 {return }
                    let frame  = CGRect(x: margin + CGFloat(index) * (margin + averWidth), y: margin, width: averWidth, height: picH)
                    let pic = GDPicView.init(frame: frame)
                     pic.addTarget(self, action: #selector(picClick(sender:)), for: UIControlEvents.touchUpInside)
                    pic.controlModel = model
                    self.picsContainer.addSubview(pic)
                }
                
                break
            default:
                
                break
                
            }
                

                    
                
                
                
                
                
                
                
                
                
                
//                for (index , model) in (cellModel.items?.enumerated())! {
//                    if index >= 4 {return }
//                    let pic = GDPicView.init(frame: CGRect.zero)
//                    if let controlModel  = model as? BaseControlModel {
//                        pic.controlModel = controlModel
//                        self.picsContainer.addSubview(pic)
//                    }
//                }
            }
            
        }
        get{return super.model}
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.topContainer.addSubview(cameraIcon)
        cameraIcon.image = UIImage(named: "camera_icon_black")
        cameraIcon.contentMode = UIViewContentMode.scaleAspectFit
        self.topContainer.addSubview(numLabel)
        self.topContainer.addSubview(namesLbl)
        self.topContainer.addSubview(timeLbl)
        namesLbl.font = GDFont.systemFont(ofSize: 14)
        timeLbl.font = GDFont.systemFont(ofSize: 14)
        numLabel.font =   GDFont.systemFont(ofSize: 14)
        numLabel.textAlignment = NSTextAlignment.right
        self.topContainer.backgroundColor = contentBackgroundColor
        self.picsContainer.backgroundColor = contentBackgroundColor
        self.contentView.addSubview(topContainer)
        self.contentView.addSubview(picsContainer)
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 3.0
        let topH : CGFloat = 44.0
//        let picH : CGFloat = 64
//        let rows = 1
        var bottomH : CGFloat = 0
        let averWidth = (SCREENWIDTH - margin * 5 ) / 4
//        let averWidth = (SCREENWIDTH - margin * 3 ) / 4
        let picH : CGFloat = averWidth
        bottomH = picH + 2 * margin
        
        

//        picsContainer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: bottomH)
        picsContainer.frame = CGRect(x: 0, y: topH, width: self.bounds.size.width, height: bottomH)
            switch self.picsContainer.subviews.count {
            case 1:
                
                for (index , view) in self.picsContainer.subviews.enumerated() {
                    if index == 0 {
//                        view.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH , height: picH)
                        view.frame = CGRect(x: margin, y: 0, width: SCREENWIDTH - margin * 2  , height: picH)
                    }
                }
                
                break
            case 2:
                for (index , view) in self.picsContainer.subviews.enumerated() {
                    if index == 0{
//                         view.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH - margin  - averWidth, height: picH)
                        view.frame = CGRect(x: margin, y: 0, width: SCREENWIDTH - margin * 3  - averWidth, height: picH)
                    }else if (index == 1 ){
//                        view.frame = CGRect(x: SCREENWIDTH  - averWidth - margin * 2, y: 0, width: averWidth, height: picH)
                        view.frame = CGRect(x: SCREENWIDTH  - averWidth - margin, y: 0, width: averWidth, height: picH)
                    }
                }
                
                break
            case 3:
                for (index , view) in self.picsContainer.subviews.enumerated() {
                    if index == 0{
//                        view.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH - margin * 2 - averWidth * 2, height: picH)
                        view.frame = CGRect(x: margin, y: 0, width: SCREENWIDTH - margin * 4 - averWidth * 2, height: picH)
                    }else if (index == 1 ){
//                        view.frame = CGRect(x: SCREENWIDTH - margin - averWidth * 2, y: 0, width: averWidth, height: picH)
                        view.frame = CGRect(x: SCREENWIDTH - margin * 2 - averWidth * 2, y: 0, width: averWidth, height: picH)
                    }else if (index == 2 ){
//                        view.frame = CGRect(x: SCREENWIDTH  - averWidth, y: 0, width: averWidth, height: picH)
                        view.frame = CGRect(x: SCREENWIDTH  - averWidth - margin , y: 0, width: averWidth, height: picH)
                    }
                }
                
                break
            case 4:
                
                for (index , view) in self.picsContainer.subviews.enumerated() {
 
                    if index >= 4 {return }
//                     view.frame = CGRect(x:  CGFloat(index) * (margin + averWidth), y: 0, width: averWidth, height: picH)
                     view.frame = CGRect(x:  CGFloat(index) * (margin + averWidth) + margin, y: 0, width: averWidth, height: picH)
                }
                
                break
            default:
                
                break
                
            }
        
        
//        let sb : CGFloat = 10
//        topContainer.frame = CGRect(x: 0, y: bottomH, width: self.bounds.width, height: topH)
        let sb : CGFloat = 8
        topContainer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: topH)
//        numLabel.frame = CGRect(x: 0, y: 0, width: 16, height: topH - sb * 2 )
        numLabel.sizeToFit()
        timeLbl.sizeToFit()
        namesLbl.sizeToFit()
        let rightMargin : CGFloat = 10.0
        numLabel.frame = CGRect(x: rightMargin, y: 0, width: numLabel.bounds.size.width , height: topH - sb * 2 )
        let cameraIconH = topH - 2 * sb
        let cameraIconW = cameraIconH * 0.8
        cameraIcon.frame = CGRect(x: numLabel.frame.maxX + 4, y:(topH - cameraIconH ) * 0.5  , width: cameraIconW , height: cameraIconH )
        timeLbl.frame = CGRect(x: SCREENWIDTH - timeLbl.frame.size.width - rightMargin , y:  sb , width: timeLbl.frame.size.width, height: topH - sb * 2 )
        let namesMaxWidth : CGFloat = timeLbl.frame.minX - cameraIcon.frame.maxX
        
        namesLbl.frame = CGRect(x: cameraIcon.frame.maxX + 2 , y:  sb , width: namesMaxWidth, height: topH - sb * 2)

//            view.frame = CGRect(x: CGFloat(indexInRow) * picW + CGFloat(indexInRow + 1 ) * margin, y: CGFloat(theRow) * picH + CGFloat(theRow + 1) * margin, width: picW, height: picH)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x:posX, y:posY, width:cgwidth, height:cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        return image
    }
    
    
    @objc func picClick(sender : GDPicView)  {
        self.delete?.imageControlClick(model: sender.controlModel ?? BaseControlModel.init(dict: nil), imageControl: sender)
    }

}

