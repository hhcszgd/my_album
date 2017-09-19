//
//  ProfileVC.swift
//  mh824appWithSwift
//
//  Created by wangyuanfei on 16/8/24.
//  Copyright © 2016年 www.16lao.com. All rights reserved.
//
//TODO: 消息按钮 固定不随tableView滚动
import UIKit
import MJRefresh
class ProfileVC: GDBaseVC , UITableViewDelegate , UITableViewDataSource , GDTrendsMsgCellDelegate{
    
    
    
    var currentPage : Int = 1

    let tipLbl1 = UILabel.init(frame: CGRect.zero)
    let tipLbl2 = UILabel.init(frame: CGRect.zero)
    var datas : [TrendsMsgCellModel] = [TrendsMsgCellModel]()
    lazy var tableView : UITableView = {
        let temp = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)//
        self.view.addSubview(temp)
        temp.dataSource = self
        temp.delegate = self
        temp.frame = CGRect(x: 0, y: 20, width: SCREENWIDTH, height: SCREENHEIGHT - 20 - 49)
        
        
//        let images = [UIImage(named: "bg_collocation")!,UIImage(named: "bg_coupon")!,UIImage(named: "bg_Direct selling")!,UIImage(named: "bg_electric")!,UIImage(named: "bg_female baby")!,UIImage(named: "bg_franchise")!]
        
        
//        let header  =  GDRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
//        header?.lastUpdatedTimeLabel.isHidden = true
//        header?.setImages(self.pullingImages , for: MJRefreshState.idle)
//        header?.setImages(self.refreshImages , for: MJRefreshState.refreshing)
//        temp.mj_header = header
//        let footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
//        footer?.setImages(self.refreshImages , for: MJRefreshState.idle)
//        footer?.setImages(self.refreshImages , for: MJRefreshState.refreshing)
//        temp.mj_footer = footer
        return temp
        
    }()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.automaticallyAdjustsScrollViewInsets = false

        
        self.view.backgroundColor = UIColor.black
               // Do any additional setup after loading the view.
        
        self.requestData(loadDataType: LoadDataType.initialize)
        
    }
    func setupAboutQieziView(hasMessage : Bool)  {
        if   hasMessage{
            self.setupTable()
        }else{
            if tipLbl1.superview == nil && tipLbl2.superview == nil  {
                self.tipLbl1.text = "没有消息"
                self.tipLbl2.text = "你在茄子认识的人寄给你的消息"
                self.tipLbl1.font = GDFont.systemFont(ofSize: 17)
                self.tipLbl2.font = GDFont.systemFont(ofSize: 14)
                self.tipLbl1.textColor = UIColor.lightGray
                self.tipLbl2.textColor = UIColor.lightGray
                self.tipLbl1.sizeToFit()
                self.tipLbl2.sizeToFit()
                self.tipLbl1.frame = CGRect(x: (SCREENWIDTH - self.tipLbl1.bounds.size.width ) / 2, y: (SCREENHEIGHT - self.tipLbl1.bounds.size.height ) / 2, width: self.tipLbl1.bounds.size.width, height: self.tipLbl1.bounds.size.height)
                self.tipLbl2.frame = CGRect(x: (SCREENWIDTH - self.tipLbl2.bounds.size.width ) / 2, y:  self.tipLbl1.frame.origin.y + 28 , width: self.tipLbl2.bounds.size.width, height: self.tipLbl2.bounds.size.height)
                
                self.view.addSubview(self.tipLbl1)
                self.view.addSubview(self.tipLbl2)
            }
        }
    }
    
    
    
    func setupTable() {

//        let images = [UIImage(named: "bg_collocation")!,UIImage(named: "bg_coupon")!,UIImage(named: "bg_Direct selling")!,UIImage(named: "bg_electric")!,UIImage(named: "bg_female baby")!,UIImage(named: "bg_franchise")!]
//        
//        
//        let header  =  GDRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
//        header?.lastUpdatedTimeLabel.isHidden = true
//        header?.setImages(self.pullingImages , for: MJRefreshState.idle)
//        header?.setImages(self.refreshImages , for: MJRefreshState.refreshing)
//        self.tableView.mj_header = header
//        let footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
//        footer?.setImages(self.refreshImages , for: MJRefreshState.idle)
//        footer?.setImages(self.refreshImages , for: MJRefreshState.refreshing)
//        self.tableView.mj_footer = footer
//        
        if self.tableView.mj_header == nil  {
            
            self.tableView.mj_footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
            self.tableView.mj_header = GDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        }
        
        
        
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    @objc func refresh ()  {
        self.requestData(loadDataType: LoadDataType.reload)
        
    }
    @objc func loadMore ()  {
        self.requestData(loadDataType: LoadDataType.loadMore)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
        return self.datas.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileVCCell")
        if cell == nil  {
            let  creatCell = GDTrendsMsgCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "profileVCCell")
            let model = self.datas[indexPath.row]
            creatCell.model = model
            creatCell.msgCelldelegate = self
            return creatCell
            
        }else{
            if let realCell = cell as? GDTrendsMsgCell {
                let model = self.datas[indexPath.row]
                realCell.model = model
                realCell.msgCelldelegate = self
                return realCell
            }
        }
        return cell!
    }
    


    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 64.0 
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

        GDNetworkManager.shareManager.getReceivedTrends(page: self.currentPage , { (result ) in
            mylog("请求历史消息的状态码\(result.status)")
            mylog(result.data)
            if loadDataType ==  LoadDataType.initialize || loadDataType == LoadDataType.reload{
                self.datas.removeAll()
            }
            var tempDatas = [TrendsMsgCellModel]()
            if let dictArr = result.data as? [[String : AnyObject]]{
                
                for itemDict in dictArr{
                    let model = TrendsMsgCellModel.init(dict: itemDict)
                    tempDatas.append(model)
                }
            }
            if tempDatas.count == 0 {
                self.setupAboutQieziView(hasMessage:false)
                self.tableView.isHidden = true
                self.tipLbl2.isHidden = false
                self.tipLbl1.isHidden = false
            }else{
                self.setupAboutQieziView(hasMessage:true)
                self.tableView.isHidden = false
                self.tipLbl2.isHidden = true
                self.tipLbl1.isHidden = true
            }
            self.datas.append(contentsOf: tempDatas)
            
            switch loadDataType {
            case LoadDataType.initialize :
                break
            case  LoadDataType.reload:
                if self.tableView.mj_header != nil {
                
                    self.tableView.mj_header.endRefreshing()
                }
                break
            case LoadDataType.loadMore :
                if tempDatas.count > 0 {
                    self.tableView.mj_footer.state = MJRefreshState.idle
                }else{
                    self.tableView.mj_footer.state = MJRefreshState.noMoreData
                }
                break
            }
            self.tableView.reloadData()
        
        }) { (error ) in
            mylog(error)
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        GDKeyVC.share.mainTabbarVC?.tabBar.items?.last?.badgeValue = nil
        GDKeyVC.share.settabBarItem(number: nil , index: 4)
        self.requestData(loadDataType: LoadDataType.reload)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model  = self.datas[indexPath.row]
        model.actionkey = "GDMideaDetailVC"
        let keyParamete : [String : String ] = [ "mediaID":model.media_id ?? "" , "create_at" : model.media_create_at ?? "" , "id":model.id ?? ""]
        model.keyparamete = keyParamete as AnyObject
        GDSkipManager.skip(viewController: self , model: model)
        
    }
    
    // MARK: 注释 : cellDelegate
    func otherIconClick(view : GDTrendsMsgCell){
        if let userid  = view.model?.comment_user_id {
            self.gotoUserDetail(userID: userid)
        }
    }
    func gotoUserDetail(userID:String)  {
        //            mylog("\(model.title)  \(model.subTitle)  \(model.imageUrl)")
        let skipModel = GDBaseModel.init(dict: nil )
        skipModel.actionkey = "GDUserHistoryVC"
        skipModel.keyparamete =  userID as AnyObject //model.subTitle as AnyObject//用户id
        GDSkipManager.skip(viewController: self , model: skipModel)
    }
}


