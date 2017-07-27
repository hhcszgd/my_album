//
//  GDUnNormalVC.swift
//  zjlao
//
//  Created by WY on 25/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit
import MJRefresh

class GDUnNormalVC: GDBaseVC , UITableViewDelegate,UITableViewDataSource ,UICollectionViewDelegate , UICollectionViewDataSource{
    
    private var  scrollViewType = ""
    lazy var collectionView: UICollectionView = {
        self.scrollViewType = "collect"
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize.init(width: SCREENWIDTH, height: SCREENHEIGHT)
        
        let collect = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        self.view.addSubview(collect)
        collect.dataSource = self
        collect.delegate = self
        collect.register(UICollectionViewCell.self , forCellWithReuseIdentifier: "item")
        collect.frame = self.view.bounds
        //        collect.mj_header = GDRefreshHeader(refreshingTarget: self , refreshingAction:  #selector(refresh))
        //        collect.mj_footer = GDRefreshBackFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        let images = [UIImage(named: "bg_collocation")!,UIImage(named: "bg_coupon")!,UIImage(named: "bg_Direct selling")!,UIImage(named: "bg_electric")!,UIImage(named: "bg_female baby")!,UIImage(named: "bg_franchise")!]
        let header  =  GDRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.setImages(self.refreshImages , for: MJRefreshState.idle)
        header?.setImages(self.refreshImages , for: MJRefreshState.refreshing)
        collect.mj_header = header
        let footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
        footer?.setImages(self.refreshImages , for: MJRefreshState.idle)
        footer?.setImages(self.refreshImages , for: MJRefreshState.refreshing)
        collect.mj_footer = footer
        return collect
    }()
    lazy var tableView : UITableView = {
        self.scrollViewType = "table"
        let temp = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)//
        self.view.addSubview(temp)
        temp.dataSource = self
        temp.delegate = self
        temp.frame = CGRect(x: 0, y: 20, width: SCREENWIDTH, height: self.view.bounds.size.height - 44 - 20)
        
        //        temp.mj_header = GDRefreshHeader(refreshingTarget: self , refreshingAction:  #selector(refresh))
        //        temp.mj_footer = GDRefreshBackFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        let images = [UIImage(named: "bg_collocation")!,UIImage(named: "bg_coupon")!,UIImage(named: "bg_Direct selling")!,UIImage(named: "bg_electric")!,UIImage(named: "bg_female baby")!,UIImage(named: "bg_franchise")!]
        
        
        let header  =  GDRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.setImages(self.pullingImages , for: MJRefreshState.idle)
        header?.setImages(self.refreshImages , for: MJRefreshState.refreshing)
        temp.mj_header = header
        let footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
        footer?.setImages(self.refreshImages , for: MJRefreshState.idle)
        footer?.setImages(self.refreshImages , for: MJRefreshState.refreshing)
        temp.mj_footer = footer
        return temp
        
    }()
    //MARK:refresh  这个控件的高度是根据图片的像素数类定的 , 像素限制在40个点(注意2X和3X)
    
    var pullingImages : [UIImage] = {
        var images = [UIImage(named: "pulling1")! , UIImage(named: "pulling2")! ,UIImage(named: "pulling3")! ,UIImage(named: "pulling4")! ,UIImage(named: "pulling5")! ,UIImage(named: "pulling6")! ,UIImage(named: "pulling7")! ]
        return images
        
    }()
    var   refreshImages:  [UIImage] = {
        //        var images = [UIImage]()
        //        for i in 1...34 {
        //            let formateStr = NSString(format: "%02d", i)
        //            let img = UIImage(named: "loading100\(formateStr)");
        //
        //            if img != nil  {
        //                images.append(img!)
        //            }
        //        }
        
        //        mylog(images.count)
        let images = [UIImage(named: "gdloading1")! , UIImage(named: "gdloading2")! ]
        return images
    }()
    
    func refresh ()  {
        if self.scrollViewType == "collect" {
            self.collectionView.mj_header.endRefreshing()
            self.collectionView.mj_header.state = MJRefreshState.idle
            self.collectionView.mj_footer.state = MJRefreshState.idle
        }else if self.scrollViewType == "table"{
            //self.tableView.mj_header.endRefreshing()
            // self.tableView.mj_header.state = MJRefreshState.idle
            //self.tableView.mj_footer.state = MJRefreshState.idle
        }
        
    }
    func loadMore ()  {
        if self.scrollViewType == "collect" {
            self.collectionView.mj_footer.endRefreshingWithNoMoreData()
        }else if self.scrollViewType == "table"{
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
        }
        
    }
    
    //MARK:collectViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath)
        item.backgroundColor = UIColor.randomColor()
        return item
    }
    //MARK:tabViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil  {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "\(indexPath.section)组\(indexPath.row)行"
        return cell ?? UITableViewCell()
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]?{
        return nil
    }
    
    
    
    
    
    
    
    
    
    lazy var naviBar: UIView = {
        let bar  = UIView(frame: CGRect(x: 0, y: SCREENHEIGHT - 44 , width: SCREENWIDTH, height: 44))
        bar.backgroundColor = UIColor.white
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        backBtn.setImage(UIImage(named: "backArrow1"), for: UIControlState.normal)
        bar.addSubview(backBtn)
        backBtn.addTarget(self , action: #selector(popToPreviousVC), for: UIControlEvents.touchUpInside)
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.automaticallyAdjustsScrollViewInsets = false 
        if naviBar.superview == nil  {
            self.view.addSubview(naviBar)
        }

        // Do any additional setup after loading the view.
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.bringSubview(toFront: self.naviBar)
        
        
    }
    func popToPreviousVC() {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
