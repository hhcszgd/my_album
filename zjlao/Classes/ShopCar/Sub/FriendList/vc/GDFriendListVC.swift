//
//  GDFriendListVC.swift
//  zjlao
//
//  Created by WY on 2017/9/24.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import  MJRefresh
class GDFriendListVC: GDNormalVC {
var datas  = [GDFriendModel]()
    var currentPage : Int  = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTable()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
        self.requestData(loadDataType: LoadDataType.initialize)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupTable() {
        if self.tableView.mj_header == nil  {
            
            self.tableView.mj_footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
            self.tableView.mj_header = GDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        }
        
        if self.navigationController?.childViewControllers.first == self  {
            self.naviBar.isHidden = true
        }else{
            self.naviBar.isHidden = false
            self.naviBar.backgroundColor = UIColor.black
            self.naviBar.backBtn.setImage(UIImage(named: "icon_classify_homepage"), for: UIControlState.normal)
            var attritit = NSMutableAttributedString.init(string: "消息")
            attritit.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange.init(location: 0, length: attritit.string.characters.count))
            self.naviBar.attributeTitle = attritit
            self.tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0 )
            
        }
        
        
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    @objc override func refresh ()  {
        self.requestData(loadDataType: LoadDataType.reload)
        
    }
    @objc override func loadMore ()  {
        self.requestData(loadDataType: LoadDataType.loadMore)
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.datas.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "GDFriendCell")
        if cell == nil  {
            let  creatCell = GDFriendCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "GDFriendCell")
            let model = self.datas[indexPath.row]
            creatCell.model = model
            return creatCell
            
        }else{
            if let realCell = cell as? GDFriendCell {
                let model = self.datas[indexPath.row]
                realCell.model = model
                return realCell
            }
        }
        return cell!
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 88.0
    }
    
    
    
    
    
    
    func requestData(loadDataType:LoadDataType)  {
        switch loadDataType {
        case LoadDataType.initialize , LoadDataType.reload:
            self.currentPage = 1
            break
        case LoadDataType.loadMore:
            self.currentPage = self.currentPage + 1
            break
        }
        GDNetworkManager.shareManager.getFriendList(page: self.currentPage, success: { (result ) in
            mylog("好友列表的状态码\(result.status)")
            var models  = [GDFriendModel]()
            
            if let dictArr = result.data as? [[String : AnyObject]]{
                for dict in dictArr {
                    let model  = GDFriendModel.init(dict: dict)
                    models.append(model )
                }
            }
            self.datas = models
            self.tableView.reloadData()
            /*
             {
             create_at = 2017-08-18 10:05:51;
             id = 212;
             name = 李福海;
             token = 3046778b0ba90b2618f9f011835f0cd1;
             avatar = http://f0.ugshop.cn/avatar/212/150302198614162.jpeg;
             }
*/
         mylog(result.data)
        }) { (error ) in
            mylog("好友列表失败\(error )")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        GDKeyVC.share.mainTabbarVC?.tabBar.items?.last?.badgeValue = nil
        //        GDKeyVC.share.settabBarItem(number: nil , index: 4)
        //        self.requestData(loadDataType: LoadDataType.reload)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userModel = self.datas[indexPath.row]
        let userID:String = userModel.id ?? ""
        let skipModel = GDBaseModel.init(dict: nil )
        skipModel.actionkey = "GDUserHistoryVC"
        skipModel.keyparamete =  userID as AnyObject //model.subTitle as AnyObject//用户id
        GDSkipManager.skip(viewController: self , model: skipModel)
        
    }
}
