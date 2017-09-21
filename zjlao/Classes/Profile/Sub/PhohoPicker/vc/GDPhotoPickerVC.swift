//
//  GDPhotoPickerVC.swift
//  zjlao
//
//  Created by WY on 2017/9/19.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import Photos
class GDPhotoPickerVC: GDNormalVC , GDImagePickerviewDelegate {
    let imgPicker =  GDImagePickview.init(frame: CGRect(x: 0, y: 0, width: 350, height: 600))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgPicker.frame =  CGRect(x: 0, y: 64, width:
            self.view.bounds.width, height: self.view.bounds.height - 64)
        self.view.addSubview(imgPicker)
        imgPicker.delegate  = self
        self.setupNaviBar()
    }
    func setupNaviBar()  {
        self.naviBar.backBtn.setImage(UIImage(named: "icon_classify_homepage"), for: UIControlState.normal)
        let  attritit = NSMutableAttributedString.init(string: "选择本地照片")
        attritit.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange.init(location: 0, length: attritit.string.characters.count))
        self.naviBar.attributeTitle = attritit
        self.naviBar.backgroundColor = UIColor.black
        let btn = UIButton()
        btn.setTitle("确定", for: UIControlState.normal)
        self.naviBar.rightBarButtons = [btn]
        btn.addTarget(self , action: #selector(doneClick), for: UIControlEvents.touchUpInside)
    }
    @objc func doneClick()  {
        imgPicker.done()
    }
    func getSelectedPHAssets(assets: [PHAsset]?) {
        mylog(assets?.count)
      
        GDNetworkManager.shareManager.uploadPHAssets(assets: assets)
        self.popToPreviousVC()
    }
    deinit {
        mylog("选取照片结束")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scrollDirection() -> UICollectionViewScrollDirection {
       return  UICollectionViewScrollDirection.vertical
    }
    func columnCount() -> Int {
        return 4
    }
    func rowCount() -> Int {
        return 5
    }
//    func itemMargin() -> CGFloat {
//        return 10
//    }
//    func collectionInset() -> UIEdgeInsets {
//        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
