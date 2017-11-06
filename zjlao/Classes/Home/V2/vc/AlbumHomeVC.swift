//
//  AlbumHomeVC.swift
//  zjlao
//
//  Created by WY on 2017/10/23.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SnapKit
import Photos

import SDWebImage
import MBProgressHUD
class AlbumHomeVC: GDNormalVC,SiftViewDidSelectProtocol /*, UICollectionViewDelegate , UICollectionViewDataSource*/{
    var page : Int = 1
    var albumModels = [AlbumModel]()
    var  progress : MBProgressHUD?
//    let collectionView  = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var siftView = SiftView.init(frame: CGRect.zero) //  UINib.init(nibName: "SiftView", bundle: nil )
    let corver = UIControl.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let tipsLabel = UILabel.init(frame: CGRect(x: 0, y: 200, width: SCREENWIDTH, height: 44))
    var selectItem : ChooseTimeItem?{
        didSet{
            print("print para of select time item ----> \(selectItem?.para)")
        }
    }
    var iconButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.title = "茄子云相册"
        self.view.backgroundColor = UIColor.white
        self.configNavigationBar()
        self.configCollectionView()
        self.configTips()
        let date = Date.init()
        let dateFormate = DateFormatter.init()
        dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dateFormate.string(from: date)
        
        self.progress?.hide(animated: false)
        let progress = MBProgressHUD.showAdded(to: self.view  , animated: true )
        progress.graceTime = 2.0
        self.progress = progress
        
        self.getAllAlbums(album_type: 1, create_at: "0,1" , page: self.page)
        // Do any additional setup after loading the view.
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        self.view.addSubview(self.corver)
        self.corver.addTarget(self , action: #selector(coverClick), for: UIControlEvents.touchUpInside)
        self.corver.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        self.corver.alpha = 0
//        let nib = UINib.init(nibName: "SiftView", bundle: nil )
//        let anyObj = nib.instantiate(withOwner: nil , options: nil ).last
//        if let aa  = anyObj as? SiftView {
//            self.siftView = aa
        self.view.addSubview(self.siftView)
//        self.siftView.frame = CGRect(x: self.view.bounds.width - 10, y: 76, width: 0, height: 0)
        self.siftView.snp.makeConstraints { (make ) in
            make.width.equalTo(0)
            make.height.equalTo(0)
            make.top.equalToSuperview().offset(74)
            make.right.equalToSuperview().offset(-10)
        }
//            self.siftView.addTarget(self , action: #selector(coverClick), for: UIControlEvents.touchUpInside)
//        }
        self.siftView.backgroundColor = UIColor.black
        self.siftView.delegate = self
        self.addIconChangedObserver()
        self.addNaviShadow()
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.default
    }
    func addNaviShadow() {
        let shadowView = UIImageView.init(image: UIImage(named:"naviBarShadow"))
        shadowView.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: 6)
        shadowView.contentMode = UIViewContentMode.scaleAspectFill
        self.naviBar.addSubview(shadowView)
        shadowView.backgroundColor = UIColor.clear
    }
    func addIconChangedObserver() {
        NotificationCenter.default.addObserver(self , selector: #selector(iconChanged(noti:)), name: NSNotification.Name.init("EditProfileSuccess"), object: Account.shareAccount)
        
        NotificationCenter.default.addObserver(self , selector: #selector(albumCountChanged), name: NSNotification.Name.init("AlbumCountChanged"), object:nil )
        
    }
    @objc func albumCountChanged()  {
        self.page = 1
        self.selectItem = nil
        self.getAllAlbums(album_type: 1, create_at: self.selectItem?.para ?? "0,1" , page: self.page , loadType:  1)
    }
    @objc func iconChanged(noti:Notification)  {
        guard let headerUrl = URL(string: Account.shareAccount.head_images ?? "")  else {return}
        self.iconButton.sd_setImage(with: headerUrl, for: UIControlState.normal) { (img , error , cacheType, url ) in
            if error == nil {
                self.iconButton.layer.masksToBounds = true
                self.iconButton.layer.cornerRadius = 22 - 2.5
            }
        }
    }
    func didSelectItem(item : ChooseTimeItem){
        print(item.label.text)
        self.page = 1
        self.selectItem = item
        self.getAllAlbums(album_type: 1, create_at: item.para, page: self.page , loadType: 2)
        self.coverClick()
    }
    @objc func coverClick(){
        UIView.animate(withDuration: 0.2) {
            self.corver.alpha = 0
            self.siftView.snp.remakeConstraints { (make ) in
                make.width.equalTo(0)
                make.height.equalTo(0)
                make.top.equalToSuperview().offset(74)
                make.right.equalTo(self.view.snp.right).offset(-10)
            }
            self.view.layoutIfNeeded()
        }
        
    }
    @objc func siftClick() {
        print("\(#file)")
        UIView.animate(withDuration: 0.2) {

            self.corver.alpha = 1
            self.siftView.snp.remakeConstraints { (make ) in
                make.width.equalTo(170)
                make.height.equalTo(200)
                make.top.equalToSuperview().offset(74)
                make.right.equalTo(self.view.snp.right).offset(-10)
            }
            self.view.layoutIfNeeded()
            
        }
    }
    func configCollectionView() {
        self.view.addSubview(collectionView)
        self.collectionView.snp.makeConstraints { (make ) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(64)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(AlbumItem.self, forCellWithReuseIdentifier: "AlbumItem")
        collectionView.backgroundColor = .white
        collectionView.backgroundView = self.tipsLabel
        self.configRefresh()
    }
    func configRefresh() {
        collectionView.mj_header = GDRefreshHeader(refreshingTarget: self , refreshingAction: #selector(refresh))
        collectionView.mj_footer = GDRefreshBackFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
    }
    @objc override func refresh(){
        self.albumModels.removeAll()
        self.page = 1
//        let date = Date.init()
//        let dateFormate = DateFormatter.init()
//        dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let str = dateFormate.string(from: date)
        self.getAllAlbums(album_type: 1, create_at:self.selectItem?.para ?? "0,1", page: self.page ,  loadType:  1 )
    }
    @objc override func loadMore() {
        self.page += 1
        let date = Date.init()
        let dateFormate = DateFormatter.init()
        dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dateFormate.string(from: date)
        self.getAllAlbums(album_type: 1, create_at: self.selectItem?.para ?? "0,1", page: self.page , loadType: 11)
    }
    func switchFlowLayout(direction : UICollectionViewScrollDirection) -> UICollectionViewFlowLayout {
        let flowlayout = UICollectionViewFlowLayout()
        if  direction == UICollectionViewScrollDirection.vertical {
            flowlayout.scrollDirection = UICollectionViewScrollDirection.vertical
            flowlayout.minimumLineSpacing = 10
            flowlayout.minimumInteritemSpacing = 10
            flowlayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20)
            let itemW =  (UIScreen.main.bounds.width - flowlayout.minimumInteritemSpacing - flowlayout.sectionInset.left - flowlayout.sectionInset.right)/2
            flowlayout.itemSize = CGSize(width:itemW, height: itemW + 18 * 2)
        }else{
            let barH = self.navigationController?.navigationBar.bounds.height ?? 0
            let itemH =  (UIScreen.main.bounds.height - flowlayout.minimumInteritemSpacing - flowlayout.sectionInset.top - flowlayout.sectionInset.bottom  - barH)/2
            flowlayout.itemSize = CGSize(width:itemH - 18 * 2 , height: itemH )
            
            
             flowlayout.scrollDirection = UICollectionViewScrollDirection.horizontal
            flowlayout.minimumLineSpacing = 10
            flowlayout.minimumInteritemSpacing = 10
//            flowlayout.sectionInset = UIEdgeInsetsMake(20, 10, 10, 10)
        }
        
        return flowlayout
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let detailVC = AlbumDetailVC.init(albumID:self.albumModels[indexPath.item].album_id)
        self.navigationController?.pushViewController(detailVC, animated: true )
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumModels.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumItem", for: indexPath)
        if let realCell = cell as? AlbumItem {
            realCell.model = self.albumModels[indexPath.item]
            return realCell
        }
        return cell
    }
    func configTips() {
//        self.view.addSubview(self.tipsLabel)
        self.tipsLabel.textAlignment = NSTextAlignment.center
        self.tipsLabel.textColor = UIColor.lightGray
        self.tipsLabel.numberOfLines = 2
        self.tipsLabel.text = ""
//        self.tipsLabel.isHidden = true
        self.tipsLabel.snp.makeConstraints { (make ) in
            make.left.right.equalToSuperview()
            make.height.equalTo(48)
            make.top.equalToSuperview().offset(200)
        }
    }
    func configNavigationBar() {
        //        let left = UIBarButtonItem.init(image: UIImage(named:""), style: UIBarButtonItemStyle.plain, target: self , action: #selector(iconClick))
        //        self.navigationController?.navigationItem.leftBarButtonItem = left
        let icon = UIButton.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        icon.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        icon.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
//        icon.setImage(UIImage.init(named: "bg_nohead"), for: UIControlState.normal)
        if let url  = URL(string: Account.shareAccount.head_images ?? "") {
            icon.sd_setImage(with: url , for: UIControlState.normal, placeholderImage: UIImage.init(named: "bg_nohead"))
        }else{
            icon.setImage(UIImage.init(named: "bg_nohead"), for: UIControlState.normal)
        }
        icon.adjustsImageWhenHighlighted = false
        self.iconButton = icon
        icon.bounds =  CGRect(x: 0, y: 0, width: 44, height: 44)
        icon.addTarget(self , action: #selector(iconClick), for: UIControlEvents.touchUpInside)
//        icon.backgroundColor = UIColor.red
        icon.imageView?.layer.masksToBounds = true
        icon.imageView?.layer.cornerRadius = 17
        icon.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
//        let left = UIBarButtonItem.init(customView: icon)
//        self.navigationItem.leftBarButtonItems = [left]
        self.naviBar.leftBarButtons = [icon]
        let add  = UIButton.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        add.addTarget(self , action: #selector(addClick), for: UIControlEvents.touchUpInside)
//        add.backgroundColor = UIColor.green
//        add.setTitle("新建", for: UIControlState.normal)
        add.setImage(UIImage(named:"jia"), for: UIControlState.normal)
        add.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        add.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        let right1 = UIBarButtonItem.init(customView: add )
        
        
        let sift  = UIButton.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        sift.addTarget(self , action: #selector(siftClick), for: UIControlEvents.touchUpInside)
//        sift.backgroundColor = UIColor.blue
//        sift.setTitle("筛选", for: UIControlState.normal)
        sift.setImage(UIImage(named:"sift_icon"), for: UIControlState.normal)
        sift.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sift.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
//        let right2 = UIBarButtonItem.init(customView: sift)
//        self.navigationItem.rightBarButtonItems = [right1 , right2]
        self.naviBar.rightBarButtons = [sift,add]
        ///:设置导航栏返回键
        self.navigationController?.navigationBar.topItem?.backBarButtonItem =   UIBarButtonItem.init(title: nil , style: UIBarButtonItemStyle.plain, target: nil , action: nil )//去掉title
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named:"header_leftbtn_nor")//返回按键
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named:"header_leftbtn_nor")
        ///:设置导航栏返回键内容颜色
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        self.navigationController?.navigationBar.isHidden = true
        
    }
    @objc func iconClick() {
        print("\(#file)")
        let vc = GDProfileEditVC()
        self.navigationController?.pushViewController(vc , animated: true )
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true , animated: true )
    }
    @objc func addClick() {
        self.coverClick()
        let addVc = CreatAlbumVC()
        addVc.title = "新建相册"
        self.navigationController?.pushViewController(addVc, animated: true )
        print("\(#file)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func getAllAlbums(album_type : Int , create_at : String , page : Int , loadType : Int = 0 /*0初始化 , 1 刷新 , 2 ,时间区间 , 其他为加载更多*/ ) {

        GDNetworkManager.shareManager.getAlbums(album_type: album_type, create_at: create_at, page: page, success: { (result ) in
            self.progress?.hide(animated:false)
            if let arr = result.data as? [[String: AnyObject]]{
                var tempAlbumModels = [AlbumModel]()
                for dict in arr {
                    if let album = dict["album"] as? [String : AnyObject]{
//                        print("album\(album)")
                        let albumModel = AlbumModel(dict: album)
                        tempAlbumModels.append(albumModel)
//                        print(albumModel.create_at)
                    }
                }
                if loadType == 0 {
                    self.albumModels = tempAlbumModels
                    if tempAlbumModels.count == 0 {
                        self.collectionView.backgroundView?.isHidden = false
                       self.tipsLabel.text = "您还没有建立相册\n点击右上角+,新建相册"
                    }
                }else if loadType == 1 {
                    self.albumModels = tempAlbumModels
                }else if loadType == 2 {
                    self.albumModels = tempAlbumModels
                }else{
                    self.albumModels.append(contentsOf: tempAlbumModels)
                }
                if self.albumModels.count > 0 {self.collectionView.backgroundView?.isHidden = true }
                self.collectionView.reloadData()
            }else{
                if loadType == 0 {
                    self.collectionView.backgroundView?.isHidden = false
                    if self.albumModels.count == 0 {
                        self.collectionView.backgroundView?.isHidden = false
                        self.tipsLabel.text = "您还没有建立相册\n点击右上角+,新建相册"
                    }
                }else if loadType == 1 {
                    if self.selectItem == nil {
                        self.tipsLabel.text = "您还没有建立相册\n点击右上角+,新建相册"
                    }else{
                        self.tipsLabel.text = "当前时间段没有相册"
                    }
                    self.albumModels.removeAll()
                    self.collectionView.reloadData()
                }else if loadType == 2{
                    
                    self.albumModels.removeAll()
                    self.tipsLabel.text = "当前时间段没有相册"
                    self.collectionView.reloadData()
                    self.collectionView.backgroundView?.isHidden = false
                }
                
            }
            self.collectionView.mj_header.endRefreshing()
            self.collectionView.mj_footer.endRefreshing()
//            print("get albums result status : \(result.status) , data :  \(result.data)")
        }) { (error ) in
            print("get albums error \(error)")
        }
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
        self.collectionView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self )
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {}
}
