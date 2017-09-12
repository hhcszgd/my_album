//
//  GDUserHistoryVC.swift
//  zjlao
//
//  Created by WY on 24/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit
import MJRefresh
import SDWebImage
class GDUserHistoryVC: GDUnNormalVC , GDTrendsCellDelegate {

  
    var userID = "0"
    var userName = ""
    var avatarStr = ""
    var currentPage : Int = 1
    var datas  : [GDTrendsCellModel] = {
        var tempDatas = [GDTrendsCellModel]()
        return tempDatas
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        if let model  = self.keyModel {
            if let userid = model.keyparamete as? String {
                self.userID = userid
            }
        }
        self.setupTableView()
        self.requestData(loadDataType: LoadDataType.initialize)
        
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
        
        GDNetworkManager.shareManager.getOthersHistory(userID: self.userID, page: "\(self.currentPage)", createAt: nil ,  { (result ) in
            mylog("请求历史消息的状态码\(result.status)")
            mylog(result.data)
            
            var tempDatas  : [GDTrendsCellModel] = [GDTrendsCellModel] ()
            if let infoDict = result.data as? [String : AnyObject]{
                if let userDict = infoDict["user"] as? [String : AnyObject]{
                    if let useravatar = userDict["avatar"] as? String{
                        self.avatarStr = useravatar
                    }
                    if let name = userDict["name"] as? String{
                        self.userName = name
                    }
                }
                if let mediasArr = infoDict["medias"] as? [[String : AnyObject]]{
                    for mediaDict in mediasArr{
                        let cellModel = GDTrendsCellModel.init(dict: nil)
                        if let week = mediaDict["week"] as? String{
                            cellModel.w = week
                        }
                        if let create_at = mediaDict["create_at"] as? String{
                            cellModel.my = "\(create_at)"
                        }
                        if let month = mediaDict["month"] as? String{
                            cellModel.m = month
                        }
                        
                        if let year = mediaDict["year"] as? String{
                            cellModel.y = year
                        }
                        
                        if let day = mediaDict["day"] as? String{
                            cellModel.d = day
                        }
                        
                        if let subMediasArr = mediaDict["media"] as? [[String : AnyObject]]{
                            var subDatas  : [BaseControlModel] = [BaseControlModel] ()
                            for subMediaDict in subMediasArr{
                                let picModel : BaseControlModel = BaseControlModel.init(dict: nil)
                                if let subthumbnail = subMediaDict["thumbnail"] as? String {
                                    picModel.imageUrl = subthumbnail
                                }
                                if let format = subMediaDict["format"] as? String{
                                    picModel.extensionTitle2 = format
                                }
                                if let circle_id = subMediaDict["circle_id"] as? String{
                                    picModel.title = circle_id
                                }else{
                                    picModel.title = Account.shareAccount.member_id
                                }
                                if let id = subMediaDict["id"] as? String{
                                    picModel.subTitle = id
                                }
                                
                                
                                subDatas.append(picModel)
                                
                            }
                            
                            cellModel.items = subDatas
                            
                        }
                        tempDatas.append(cellModel)
                        
                    }
                }
            }
            
            
            
            
            /////
            
            if(tempDatas.count == 0 ){
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.state = MJRefreshState.noMoreData
                return
            }
            switch loadDataType {
            case LoadDataType.initialize , LoadDataType.reload:
                self.datas = tempDatas
                break
            case LoadDataType.loadMore:
                self.datas.append(contentsOf: tempDatas)
                break
            }
            self.tableView.tableHeaderView = self.headerView()
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.state = MJRefreshState.idle
            
            
            /////
            //            self.datas = tempDatas
            //            self.tableView.reloadData()
            
            
            
        }) { (error ) in
            mylog(error)
        }
        
    }
    func setupTableView()  {
        self.view.addSubview(self.tableView)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.delegate  = self
        self.tableView.dataSource = self
        self.tableView.mj_footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
        self.tableView.mj_header = GDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refreshOrInit))
        
        self.tableView.tableHeaderView = self.headerView()
    }
    override func loadMore () {
        self.requestData(loadDataType: LoadDataType.loadMore)
    }
    func refreshOrInit()  {
        self.requestData(loadDataType: LoadDataType.initialize)
    }
    
    
    func headerView() -> GDBaseControl {
        let headerView = GDBaseControl(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 64))
        
        
        let iconView = UIImageView.init(frame: CGRect(x: 0, y: headerView.bounds.size.height - 64, width: 64, height: 64))
        //        iconView.image = UIImage.init(named: "bg_nohead")
        iconView.sd_setImage(with: URL(string: self.avatarStr ), placeholderImage: placePolderImage, options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])
        headerView.addSubview(iconView)
        
        let nameLbl = UILabel.init()
        nameLbl.textColor = UIColor.white
        nameLbl.text = self.userName
        nameLbl.frame =  CGRect(x: iconView.bounds.size.width + 8, y: iconView.frame.midY - nameLbl.font.lineHeight / 2 , width: SCREENWIDTH - iconView.bounds.size.width - 8 , height: nameLbl.font.lineHeight)
        headerView.addSubview(nameLbl)
        headerView.backgroundColor = UIColor.black
        headerView.addTarget(self , action: #selector(headerViewClick(sender:)), for: UIControlEvents.touchUpInside)
        return headerView
    }
    func headerViewClick(sender:GDBaseControl)  {
        mylog("头视图点击")
    }
    // MARK: 注释 : 代理
    func trendsCellItemClick(model : BaseControlModel ,  imageControl : GDPicView){
        mylog(model.title)
        if let circleID = model.title {
            let model = GDBaseModel.init(dict: nil)
            model.actionkey = "GDCircleDetailVC"
            model.keyparamete = circleID as AnyObject?
            GDSkipManager.skip(viewController: self , model: model)
            
        }
    }
    func trendsCellMoreClick(model : GDTrendsCellModel){
        mylog("点击更多")
        model.actionkey = "DayMediaDetailVC"
        GDSkipManager.skip(viewController: self , model: model)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.datas.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "GDTrendsCell")
        if cell == nil  {
            cell = GDTrendsCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "GDTrendsCell")
        }
        if let cellReal  = cell as? GDTrendsCell {
            cellReal.model = self.datas[indexPath.row]
            cellReal.delegate = self
            return cellReal
        }
        return cell!
    }
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let model = self.datas[indexPath.row]
        
        if model.items?.count == 0 || model.items == nil  {
            return 1
        }
        let margin : CGFloat = 2.0
        let topH : CGFloat = 44.0
        let picW : CGFloat = (SCREENWIDTH - 5 * margin ) / 4
//        let picH : CGFloat = picW
        //        var rows = ((model.items?.count)! + 1 ) /  4
        //        let left = ((model.items?.count)! + 1 ) % 4
        var rows = (model.items?.count)!  /  4
        let left = (model.items?.count)! % 4
        var bottomH : CGFloat = 0
        if rows >= 3 {
            rows = 3
        }else{
            if  (left > 0 )  {
                rows = rows + 1
            }
        }
        bottomH = CGFloat(rows) * picW + CGFloat(rows + 1) * margin
        return topH + bottomH
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
