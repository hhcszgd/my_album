//
//  PickImageVC.swift
//  zjlao
//
//  Created by WY on 2017/10/23.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import Photos

class PickImageVC: GDBaseVC , GDImagePickerviewDelegate{
    var albumID = ""
    convenience init(albumID:String){
        self.init()
        self.albumID = albumID
    }
    let imgPicker =  GDImagePickview.init(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        imgPicker.delegate  = self
        imgPicker.frame =  CGRect(x: 0, y: 0, width:
            self.view.bounds.width, height: self.view.bounds.height )
        self.view.addSubview(imgPicker)
        self.imgPicker.layoutIfNeeded()
        self.setupNaviBar()
    }
    func setupNaviBar()  {
        self.title = "选择照片"
        
        let done   = UIButton.init(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        done.addTarget(self , action: #selector(doneClick), for: UIControlEvents.touchUpInside)
//        done.backgroundColor = UIColor.blue
        done.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        done.setTitle("完成", for: UIControlState.normal)
        done.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        let right = UIBarButtonItem.init(customView: done)
        self.navigationItem.rightBarButtonItems = [right]
//        self.naviBar.backBtn.setImage(UIImage(named: "icon_classify_homepage"), for: UIControlState.normal)
//        let  attritit = NSMutableAttributedString.init(string: "选择本地照片")
//        attritit.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange.init(location: 0, length: attritit.string.characters.count))
//        self.naviBar.attributeTitle = attritit
//        self.naviBar.backgroundColor = UIColor.black
//        let btn = UIButton()
//        btn.setTitle("确定", for: UIControlState.normal)
//        self.naviBar.rightBarButtons = [btn]
//        btn.addTarget(self , action: #selector(doneClick), for: UIControlEvents.touchUpInside)
    }
    @objc func doneClick()  {
        
        if imgPicker.allIndexPathsOfSelectedItems.count ?? 0 == 0 {
            GDAlertView.alert("请选择照片", image: nil , time: 1 , complateBlock: nil )
            return
        }
        if let currentIndex = self.navigationController?.viewControllers.index(of: self){
            if let priviousVC = self.navigationController?.viewControllers[currentIndex - 1] as? AlbumDetailVC {//ifPriviousVCIsAlbumDetailVC , doneForPop , else  pushAlbumDetailVC
                imgPicker.done()
                return
            }
        }
        imgPicker.done()
        let vc = AlbumDetailVC.init(albumID: Int(self.albumID) ?? 0)
        self.navigationController?.pushViewController(vc , animated: true )
    }
    func getSelectedPHAssets(assets: [PHAsset]?) {
        mylog(assets?.count)
        //传albumID
        GDNetworkManager.shareManager.uploadPHAssets(albumID : self.albumID ,assets: assets)
        for (index , item)  in (assets ?? []).enumerated() {
            print("sssssssssss:\(item.mediaType.rawValue)")
        }
        if let currentIndex = self.navigationController?.viewControllers.index(of: self){
            if let priviousVC = self.navigationController?.viewControllers[currentIndex - 1] as? AlbumDetailVC {
                self.navigationController?.popViewController(animated: true)
                
            }
        }
        
    }
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            if let index = self.navigationController?.viewControllers.index(of: self){//good! It's words
                self.navigationController?.viewControllers.remove(at: index)

            }

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
//    func rowCount() -> Int {
//        return 5
//    }

}
