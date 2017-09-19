//
//  GDPicView.swift
//  zjlao
//
//  Created by WY on 17/4/3.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SDWebImage
class GDPicView: GDBaseControl {

    let videoIcon = UIImageView(image: UIImage(named : "VideoCameraPreview"))
    var isVideo  = false
    var longPress : UILongPressGestureRecognizer?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var alertvc : UIAlertController?
     override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        self.addSubview(videoIcon)
        self.videoIcon.contentMode = UIViewContentMode.scaleAspectFit
        self.imageView.contentMode = UIViewContentMode.scaleAspectFill
        self.setupLongPress()

//        self.imageView.contentMode = [UIViewContentMode.center , UIViewContentMode.scaleToFill]
    }
    func setupLongPress()  {
       let longpress = UILongPressGestureRecognizer.init(target: self , action: #selector(alertMessage))
        self.longPress = longpress
        self.addGestureRecognizer(longpress)
    }
    @objc func alertMessage()  {
//        print(self.alertvc ?? <#default value#>)
        if  self.alertvc == nil  {
            let alertvc = UIAlertController.init(title: "举报该内容", message: nil , preferredStyle: UIAlertControllerStyle.alert)
            let action0 = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.default) { (action ) in
                alertvc.dismiss(animated: true , completion:{
                    
                })
                self.alertvc = nil
            }
            let action = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (action ) in
                
                alertvc.dismiss(animated: false  , completion:{

                })
                self.alertvc = nil
                
                self.perforReport(mediaID:self.controlModel?.subTitle ?? "", reporterID: "")
            }
            alertvc.addAction( action0 )
            alertvc.addAction(action)
            self.alertvc = alertvc
            GDKeyVC.share.present(alertvc, animated: true , completion: nil )
            mylog("长按else")
        }
        

    }
    
    /**举报*/
    
    func perforReport(mediaID : String , reporterID : String){
        
        GDNetworkManager.shareManager.report(mediaID: mediaID, { (model ) in
            mylog(model.status)
            var tips = ""
            switch model.status {
            case 200 :
                tips = "举报成功,等待审核"
            case 350 :
                tips = "请勿重复举报"
            default :
                tips = "未知错误"
            }
            GDAlertView.alert(tips, image: nil , time: 2, complateBlock: nil)
        }) { (error ) in
            GDAlertView.alert( "未知错误", image: nil , time: 2, complateBlock: nil)
        }
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var controlModel: BaseControlModel?{
        set{
            super.controlModel = newValue
            mylog(newValue?.subTitle)
            if let formate = newValue?.extensionTitle2 {
                if formate == "jpeg" || formate == "png" || formate == "jpg" {
                    self.isVideo  = false
                }else if formate == "MOV" || formate == "mp4" || formate == "avi" {
                    self.isVideo  = true
                }else{
                    self.isVideo  = false
                }
            }
            if let urlStr  = newValue?.imageUrl {
                if let url = URL.init(string: urlStr) {
//                    self.imageView.sd_setImage(with: url)
                    
                    self.imageView.sd_setImageWithPreviousCachedImage(with:  url, placeholderImage: placePolderImage, options: SDWebImageOptions.cacheMemoryOnly, progress: { (received, total ) in
                        
                    }) { (img , err , type , url ) in
                        if err == nil {
                            
                            self.imageView.image =  self.cropToBounds(image: img!, width: self.bounds.width, height: self.bounds.size.height)
                        }
                    }
                    
//                    self.imageView.sd_setImage(with: url , completed: { (img , err , type , url ) in
//                        if err == nil {
//
//                           self.imageView.image =  self.cropToBounds(image: img!, width: self.bounds.width, height: self.bounds.size.height)
//                        }
//                    })

                }
            }
        }
        get{
            return super.controlModel
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
        if self.isVideo {
            self.videoIcon.isHidden = false
            self.videoIcon.frame = CGRect(x: 3, y: self.bounds.size.height - 18 , width: 20, height: 20)
        }else{
            self.videoIcon.isHidden = true
        }
    }
    
    func cropToBounds(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
//        let contextSize: CGSize = contextImage.size
        

        
        // See what size is longer and create the center off of that
        /*
         var posX: CGFloat = 0.0
         var posY: CGFloat = 0.0
         var cgwidth: CGFloat = CGFloat(width)
         var cgheight: CGFloat = CGFloat(height)
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

        */
        let imgW = image.size.width
        let imgH = imgW * height / width
//        mylog(height)
//        mylog(self.bounds)
//        mylog(self.bounds.size.height)
//        mylog(self.frame.size.height)
//        mylog(imgW * height)
        let imgX : CGFloat = 0
        let imgY : CGFloat = (image.size.height - imgH ) / 2
        let rect: CGRect = CGRect(x:imgX, y:imgY, width:imgW, height:imgH)
//        mylog("图片宽\(image.size.width)高\(image.size.height)")
//        mylog("宽 : \(imgW)  高 \(imgH)  x值 \(imgX)  y值 \(imgY)" )

        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let tempImage: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        return tempImage
    }

}
