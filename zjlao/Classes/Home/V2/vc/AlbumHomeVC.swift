//
//  AlbumHomeVC.swift
//  zjlao
//
//  Created by WY on 2017/10/23.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SnapKit
class AlbumHomeVC: GDBaseVC , UICollectionViewDelegate , UICollectionViewDataSource{
    var page : Int = 1
    var albumModels = [AlbumModel]()
    let collectionView  = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    let tipsLabel = UILabel.init(frame: CGRect(x: 0, y: 200, width: SCREENWIDTH, height: 44))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "茄子云相册"
        self.view.backgroundColor = UIColor.white
        self.configNavigationBar()
        self.configSubviews()
        self.configCollectionView()
        let date = Date.init()
        let dateFormate = DateFormatter.init()
        dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dateFormate.string(from: date)
        self.getAllAlbums(album_type: 1, create_at: str , page: 1)
        // Do any additional setup after loading the view.
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.always
        } else {
            // Fallback on earlier versions
        }
        
    }
    func configCollectionView() {
        self.view.addSubview(collectionView)
        self.collectionView.snp.makeConstraints { (make ) in
            make.left.right.bottom.top.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(AlbumItem.self, forCellWithReuseIdentifier: "AlbumItem")
        collectionView.backgroundColor = .white
        self.configRefresh()
    }
    func configRefresh() {
        collectionView.mj_header = GDRefreshHeader(refreshingTarget: self , refreshingAction: #selector(refresh))
        collectionView.mj_footer = GDRefreshBackFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
    }
    @objc func refresh(){
        self.albumModels.removeAll()
        self.page = 1
        let date = Date.init()
        let dateFormate = DateFormatter.init()
        dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dateFormate.string(from: date)
        self.getAllAlbums(album_type: 1, create_at: str, page: self.page)
    }
    @objc func loadMore() {
        self.page += 1
        let date = Date.init()
        let dateFormate = DateFormatter.init()
        dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dateFormate.string(from: date)
        self.getAllAlbums(album_type: 1, create_at: str, page: self.page)
    }
    func switchFlowLayout(direction : UICollectionViewScrollDirection) -> UICollectionViewFlowLayout {
        let flowlayout = UICollectionViewFlowLayout()
        if  direction == UICollectionViewScrollDirection.vertical {
            flowlayout.scrollDirection = UICollectionViewScrollDirection.vertical
            flowlayout.minimumLineSpacing = 10
            flowlayout.minimumInteritemSpacing = 10
            flowlayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20)
            flowlayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - flowlayout.minimumInteritemSpacing - flowlayout.sectionInset.left - flowlayout.sectionInset.right)/2, height: 200)
        }else{
            let barH = self.navigationController?.navigationBar.bounds.height ?? 0
            flowlayout.itemSize = CGSize(width: 123, height: (UIScreen.main.bounds.height - flowlayout.minimumInteritemSpacing - flowlayout.sectionInset.top - flowlayout.sectionInset.bottom  - barH)/2)
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumItem", for: indexPath)
        if let realCell = cell as? AlbumItem {
            realCell.model = self.albumModels[indexPath.item]
            return realCell
        }
        return cell
    }
    func configSubviews() {
        self.view.addSubview(self.tipsLabel)
        self.tipsLabel.textAlignment = NSTextAlignment.center
        self.tipsLabel.textColor = UIColor.lightGray
        self.tipsLabel.numberOfLines = 2
        self.tipsLabel.text = "您还没有建立相册\n点击右上角+,新建相册"
        self.tipsLabel.snp.makeConstraints { (make ) in
            make.left.right.equalToSuperview()
            make.height.equalTo(48)
            make.top.equalToSuperview().offset(200)
        }
    }
    func configNavigationBar() {
        //        let left = UIBarButtonItem.init(image: UIImage(named:""), style: UIBarButtonItemStyle.plain, target: self , action: #selector(iconClick))
        //        self.navigationController?.navigationItem.leftBarButtonItem = left
        let icon = UIButton.init(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        icon.addTarget(self , action: #selector(iconClick), for: UIControlEvents.touchUpInside)
        icon.backgroundColor = UIColor.red
        icon.layer.masksToBounds = true
        icon.layer.cornerRadius = 17
        let left = UIBarButtonItem.init(customView: icon)
        self.navigationItem.leftBarButtonItems = [left]
        
        let add  = UIButton.init(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        add.addTarget(self , action: #selector(addClick), for: UIControlEvents.touchUpInside)
        add.backgroundColor = UIColor.green
        let right1 = UIBarButtonItem.init(customView: add )
        
        
        let sift  = UIButton.init(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        sift.addTarget(self , action: #selector(siftClick), for: UIControlEvents.touchUpInside)
        sift.backgroundColor = UIColor.blue
        let right2 = UIBarButtonItem.init(customView: sift)
        self.navigationItem.rightBarButtonItems = [right1 , right2]
    }
    @objc func iconClick() {
        print("\(#file)")
        let vc = GDProfileEditVC()
        self.navigationController?.pushViewController(vc , animated: true )
    }
    @objc func addClick() {
        let addVc = CreatAlbumVC()
        addVc.title = "新建相册"
        self.navigationController?.pushViewController(addVc, animated: true )
        print("\(#file)")
    }
    @objc func siftClick() {
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
    func getAllAlbums(album_type : Int , create_at : String , page : Int ) {
        GDNetworkManager.shareManager.getAlbums(album_type: album_type, create_at: create_at, page: page, success: { (result ) in
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
                self.albumModels.append(contentsOf: tempAlbumModels)
                self.collectionView.reloadData()
            }
            self.collectionView.mj_header.endRefreshing()
            self.collectionView.mj_footer.endRefreshing()
//            print("get albums result status : \(result.status) , data :  \(result.data)")
        }) { (error ) in
            print("get albums error \(error)")
        }
    }
    func testAPI() {
//        GDNetworkManager.shareManager.getUserInfomation(userID: Account.shareAccount.member_id ?? "", success: { (result ) in
//            print("get user info result status:\(result.status ) , data: \(result.data )")
//        }) { (error ) in
//            print("get user info error \(error)")
//        }
        
        GDNetworkManager.shareManager.getAlbums(album_type: 1, create_at: "2017-10-23 21:00:01", page: 1, success: { (result ) in
            print("get albums result status : \(result.status) , data :  \(result.data)")
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
    
    
}
