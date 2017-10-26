//
//  AlbumDetailVC.swift
//  zjlao
//
//  Created by WY on 2017/10/24.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import Photos
class AlbumDetailVC: GDBaseVC ,UICollectionViewDataSource, UICollectionViewDelegate{
    var albumID : Int  = 0
    
    var albumMedias = [MediaModel]()
    var headerModel = AlbumDetailHeaderModel.init(dict: nil )
    let collectionView  = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    convenience init(albumID:Int){
        self.init()
        self.albumID = albumID
        self.view.backgroundColor = UIColor.red
//                                            NotificationCenter.default.post(name: NSNotification.Name.init("UpLoadMediaSuccess"), object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotificationOfUploadSuccess), name: NSNotification.Name.init("UpLoadMediaSuccess"), object: GDNetworkManager.shareManager)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configCollectionView()
        self.getAlbumDetail()
        self.configNavigationBar()
        // Do any additional setup after loading the view.
    }
    func switchFlowLayout(direction : UICollectionViewScrollDirection) -> UICollectionViewFlowLayout {
        let flowlayout = UICollectionViewFlowLayout()
        if  direction == UICollectionViewScrollDirection.vertical {
            flowlayout.scrollDirection = UICollectionViewScrollDirection.vertical
            flowlayout.minimumLineSpacing = 3
            flowlayout.minimumInteritemSpacing = 3
            flowlayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20)
            let itemW = (UIScreen.main.bounds.width - flowlayout.minimumInteritemSpacing * 2  - flowlayout.sectionInset.left - flowlayout.sectionInset.right)/3
            flowlayout.itemSize = CGSize(width: itemW, height: itemW)
            flowlayout.headerReferenceSize =  CGSize(width: 100, height: 118)
            flowlayout.footerReferenceSize = CGSize(width: 100, height: 0)
            if #available(iOS 9.0, *) {
                flowlayout.sectionHeadersPinToVisibleBounds = true
            } else {
                // Fallback on earlier versions
            }
        }else{
            let barH = self.navigationController?.navigationBar.bounds.height ?? 0
            let itemW = (UIScreen.main.bounds.height - flowlayout.minimumInteritemSpacing * 2  - flowlayout.sectionInset.top - flowlayout.sectionInset.bottom  - barH)/3
            flowlayout.itemSize = CGSize(width: itemW, height: itemW)
            flowlayout.scrollDirection = UICollectionViewScrollDirection.vertical//horizontal
            flowlayout.minimumLineSpacing = 3
            flowlayout.minimumInteritemSpacing = 3
            
            flowlayout.headerReferenceSize =  CGSize(width: 100, height: 118)
            flowlayout.footerReferenceSize = CGSize(width: 100, height:0)
            if #available(iOS 9.0, *) {
                flowlayout.sectionHeadersPinToVisibleBounds = true
            } else {
                // Fallback on earlier versions
            }
            //            flowlayout.sectionInset = UIEdgeInsetsMake(20, 10, 10, 10)
        }
        
        return flowlayout
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if  kind == UICollectionElementKindSectionHeader {
        
        let reuseView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "DDHeader", for: indexPath)
            if let header = reuseView as? AlbumDetailHeader{
                header.model = headerModel
            }
        return reuseView
        }else{
            
            let reuseView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer", for: indexPath)
            return reuseView
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){}
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumMedias.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaItem", for: indexPath)
        if let realCell = cell as? MediaItem {
            realCell.model = self.albumMedias[indexPath.item]
            return realCell
        }
        return cell
    }
    @objc func receiveNotificationOfUploadSuccess() {
        self.getAlbumDetail(type:1)
    }
    func getAlbumDetail(type:Int = 1) {//1,首次加载和刷新  , 2 加载更多
        GDNetworkManager.shareManager.getAlbumDetail(albumID: self.albumID, success: { (model ) in
            print("get album detail result status : \(model.status) , data : \(model.data)")
            if let dict = model.data as? [String : AnyObject]{
                self.headerModel = AlbumDetailHeaderModel.init(dict: dict)
                if let update_at = dict["update_at"] as? String{//非字符串类型
                    print("update_at:\(update_at)")
                }
                if let album_name = dict["album_name"] as? String {
                    print("album_name:\(album_name)")
                }
                if let create_at = dict["create_at"] as? String {
                    print("create_at:\(create_at)")
                }
                
                if let members = dict["members"] as? [[String : AnyObject]]{
                    
                }
                if let medias = dict["media"] as? [[String : AnyObject]]{
                    var tempAlbumMedias = [MediaModel]()
                    for mediaDict in medias {
                        let media = MediaModel.init(dict: mediaDict)
                        tempAlbumMedias.append(media)
                        
                    }
                    if tempAlbumMedias.count == self.albumMedias.count {return}
                    if type == 1 {
                        self.albumMedias = tempAlbumMedias
                    }else{
                        self.albumMedias.append(contentsOf: tempAlbumMedias)
                    }
                }
                UIView.animate(withDuration: 0.1, animations: {
                    self.collectionView.reloadData()
                })
                
            }
            
            
        }) { (error ) in
            print("get album detail fail : \(error)")
        }
    }
    func configCollectionView() {
        self.view.addSubview(collectionView)
        self.collectionView.snp.makeConstraints { (make ) in
            make.left.right.bottom.top.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(MediaItem.self, forCellWithReuseIdentifier: "MediaItem")
//        self.collectionView.register(AlbumDetailHeader.self , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "DDHeader")
        self.collectionView.register(UINib.init(nibName: "AlbumDetailHeader", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "DDHeader")
        
        self.collectionView.register(UICollectionReusableView.self , forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
        collectionView.backgroundColor = .white
        
//        self.configRefresh()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(<#T##touches: Set<UITouch>##Set<UITouch>#>, with: <#T##UIEvent?#>)
        GDNetworkManager.shareManager.insertMediaToAlbum(albumID: "\(self.albumID)", original: "Fnl6zK1pf5wfzJod0Y2B7tKq8lji", type: "1", success: { (model ) in
            print("upload media media to album result status : \(model.status) , data : \(model.data)")
        }) { (error ) in
            print(" upload media media to album fail : \(error)")
        }
    }
    func configNavigationBar() {
        //        let left = UIBarButtonItem.init(image: UIImage(named:""), style: UIBarButtonItemStyle.plain, target: self , action: #selector(iconClick))
        //        self.navigationController?.navigationItem.leftBarButtonItem = left
       
        
        let upload  = UIButton.init(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        upload.addTarget(self , action: #selector(performUpload), for: UIControlEvents.touchUpInside)
        upload.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        upload.setTitle("上传", for: UIControlState.normal)
        let right1 = UIBarButtonItem.init(customView: upload )
        
        
        let share  = UIButton.init(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        
        share.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        share.setTitle("分享", for: UIControlState.normal)
        share.addTarget(self , action: #selector(performShare), for: UIControlEvents.touchUpInside)
        let right2 = UIBarButtonItem.init(customView: share)
        self.navigationItem.rightBarButtonItems = [ right2,right1 ]
    }
   
    @objc func performUpload() {
       self.configPhotoLibrary()
    }
    
  
    
    func configPhotoLibrary() {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            let alertVC  = UIAlertController.init(title: "上传照片需要访问本地相册" , message: nil , preferredStyle: UIAlertControllerStyle.alert)
            
            let alertAction2 = UIAlertAction.init(title: "允许", style: UIAlertActionStyle.default) { (action ) in
                UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
                alertVC.dismiss(animated: true , completion: {
                    //调用本地相册库
                })
            }
            
            let alertAction3 = UIAlertAction.init(title: "拒绝", style: UIAlertActionStyle.cancel) { (action ) in
                alertVC.dismiss(animated: true , completion: {})
            }
            alertVC.addAction(alertAction2)
            alertVC.addAction(alertAction3)
            self.present(alertVC, animated: true) {}

            
        }else{
            let vc = PickImageVC(albumID: "\(self.albumID)")
            self.navigationController?.pushViewController(vc , animated: true )
        }
    }
    @objc func performShare() {
        print("\(#file)")
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        /**/
        
        if ((self.traitCollection.verticalSizeClass   != previousTraitCollection?.verticalSizeClass)
            || (self.traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass)) {
            // your custom implementation here
            if self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.regular{//竖屏
                self.collectionView.setCollectionViewLayout(self.switchFlowLayout(direction: UICollectionViewScrollDirection.vertical), animated: true)
            }else{//横屏
                self.collectionView.setCollectionViewLayout(self.switchFlowLayout(direction: UICollectionViewScrollDirection.horizontal), animated: true)
            }
            self.collectionView.reloadData()
        }
//        self.collectionView.reloadData()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
