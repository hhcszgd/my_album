//
//  GDNormalVC.swift
//  zjlao
//
//  Created by WY on 16/11/21.
//  Copyright © 2016年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import MJRefresh
enum VCType {
    case withBackButton
    case withoutBackButton
}

class GDNormalVC: BaseVC , CustomNaviBarDelegate , UITableViewDelegate,UITableViewDataSource ,UICollectionViewDelegate , UICollectionViewDataSource{
    lazy var collectoinView: UICollectionView = {
        let collect = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: UICollectionViewFlowLayout.init())
        self.view.addSubview(collect)
        collect.dataSource = self
        collect.delegate = self
        collect.register(UICollectionViewCell.self , forCellWithReuseIdentifier: "item")
        collect.frame = self.view.bounds
        collect.mj_header = GDRefreshHeader(refreshingTarget: self , refreshingAction:  #selector(refresh))
        collect.mj_footer = GDRefreshBackFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        return collect
    }()
    lazy var tableView : UITableView = {
        let temp = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)//
        temp.dataSource = self
        temp.delegate = self
        temp.frame = self.view.bounds
        temp.mj_header = GDRefreshHeader(refreshingTarget: self , refreshingAction:  #selector(refresh))
        temp.mj_footer = GDRefreshBackFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        self.view.addSubview(temp)
        return temp
    
    }()
    //MARK:refresh

    

    func refresh ()  {
//        self.tableView.mj_header.endRefreshing()
//        self.tableView.mj_footer.state = MJRefreshState.idle
    }
    func loadMore ()  {
//        self.tableView.mj_footer.endRefreshingWithNoMoreData()
    }

    //MARK:collectViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath)
        item.backgroundColor = UIColor.randomColor()
        return item
    }
    //MARK:tabViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil  {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "\(indexPath.section)组\(indexPath.row)行"
        return cell ?? UITableViewCell()
    }

    private var errorView : GDErrorView?
    
    var currentType : VCType = VCType.withBackButton
    
    var attritNavTitle : NSAttributedString  {
        set{   naviBar.title = newValue  }
        get{ return naviBar.title }
    }
    
    
    var naviBar : CustomNaviBar!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        if (((self.navigationController?.childViewControllers.count) ?? 1) > 1) {
            self.currentType=VCType.withBackButton;
        }else{
            self.currentType=VCType.withoutBackButton;
        }
        
        switch currentType {
        case .withBackButton:
            //
            naviBar = CustomNaviBar(type: NaviBarStyle.withBackBtn)
            naviBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: NavigationBarHeight )
            naviBar.delegate = self
            break
        case .withoutBackButton:
            //
            
            naviBar = CustomNaviBar(type: NaviBarStyle.withoutBackBtn)
            naviBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: NavigationBarHeight )
            break
        }
        naviBar.backgroundColor = UIColor.randomColor()
        //        self.view.addSubview(naviBar)//推迟添加 , 否则会提前调用viewdidload()
        
        
        
        self.view.addSubview(naviBar)
        naviBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: NavigationBarHeight )
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.bringSubview(toFront: self.naviBar)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func popToPreviousVC() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:页面加载错误是调这个方法
    func showErrorView ()  {
        self.errorView = GDErrorView()
        self.errorView?.addTarget(self, action: #selector(errorViewClick), for: UIControlEvents.touchUpInside)
        self.view.insertSubview(errorView!, belowSubview: self.naviBar)
        self.errorView?.frame = self.view.bounds
        
        
    }
    //MARK://子类重写它 , 在方法中调hiddenErrorView()
    func errorViewClick ()  {
        
    }
    func hiddenErrorView()  {
        self.errorView?.removeFromSuperview()
        self.errorView = nil
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
      //MARK:代理方法 , 子类若想用这个方法 , 必须在这个父类中首先实现一下 , 再在子类中重写才会生效
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

}
