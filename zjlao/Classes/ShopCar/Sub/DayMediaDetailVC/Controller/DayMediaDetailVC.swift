//
//  DayMediaDetailVC.swift
//  zjlao
//
//  Created by WY on 21/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit
import MJRefresh
import SDWebImage
class DayMediaDetailVC: GDUnNormalVC , GDTrendsCellDelegate{
    var currentPage : Int = 1
    var datas  : [GDTrendsCellModel] =  [GDTrendsCellModel](){
        willSet{
            mylog(newValue)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
        var creat_at : String?
        if let trueModel = self.keyModel as? GDTrendsCellModel {
            creat_at = trueModel.my
        }
        GDNetworkManager.shareManager.getPersonalHistory(page: "\(self.currentPage)" , createAt : creat_at, { (result ) in
            mylog("请求历史消息的状态码\(result.status)")
            mylog(result.data)
            var tempDatas  : [GDTrendsCellModel] = [GDTrendsCellModel] ()
            var subDatas  : [BaseControlModel] = [BaseControlModel] ()

            if let infoDict = result.data as? [String : AnyObject]{
                if (infoDict["user"] as? [[String : AnyObject]]) != nil{
                }
                if let mediasArr = infoDict["medias"] as? [[String : AnyObject]]{
                    for mediaDict in mediasArr{
                        let cellModel = GDTrendsCellModel.init(dict: nil)
                        if let week = mediaDict["week"] as? String{
                            cellModel.w = week
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
//                            var subDatas  : [BaseControlModel] = [BaseControlModel] ()
                            for subMediaDict in subMediasArr{
                                let picModel : BaseControlModel = BaseControlModel.init(dict: nil)
                                if let subthumbnail = subMediaDict["thumbnail"] as? String {
                                    picModel.imageUrl = subthumbnail
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
                            
                            
                            switch loadDataType {
                            case LoadDataType.initialize , LoadDataType.reload:
//                                self.datas = tempDatas
                                cellModel.items = subDatas
                                break
                            case LoadDataType.loadMore:
                                if let itemsArr = self.datas.first?.items as? [BaseControlModel] {
                                    var tempArr = itemsArr
                                    tempArr.append(contentsOf: subDatas)

                                    cellModel.items = tempArr
                                    cellModel.w = self.datas.first?.w
                                    cellModel.y = self.datas.first?.y
                                    cellModel.d = self.datas.first?.d
                                    cellModel.my = self.datas.first?.my
                                    cellModel.m = self.datas.first?.m
                                }
                                break
                            }
//                            cellModel.items = subDatas
                            
                        }
                        tempDatas.append(cellModel)
                        
                    }
                }
            }
            
            
            
            
            /////
            
            if(subDatas.count == 0 ){
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.state = MJRefreshState.noMoreData
                return
            }
            self.datas = tempDatas
            switch loadDataType {
            case LoadDataType.initialize , LoadDataType.reload:
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.state = MJRefreshState.idle
                break
            case LoadDataType.loadMore:
                self.tableView.mj_footer.state = MJRefreshState.idle
                  break
            }
            
            self.tableView.reloadData()

            
        }) { (error ) in
            mylog(error)
        }
        
    }
    func setupTableView()  {
        self.tableView.frame = CGRect.init(x: 0, y: 0, width: GDDevice.width, height: GDDevice.height )
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.navigationController?.automaticallyAdjustsScrollViewInsets = false
            // Fallback on earlier versions
        }
        self.view.addSubview(self.tableView)
        self.tableView.backgroundColor = UIColor(red: 240 / 256, green:  240 / 256, blue:  240 / 256, alpha: 1)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.delegate  = self
        self.tableView.dataSource = self
        self.tableView.mj_footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
        self.tableView.mj_header = GDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refreshOrInit))
        
        self.tableView.tableHeaderView = self.headerView()
    }
    @objc override func loadMore () {
        self.requestData(loadDataType: LoadDataType.loadMore)
    }
    @objc func refreshOrInit()  {
        self.requestData(loadDataType: LoadDataType.initialize)
    }
    
    
    func headerView() -> GDBaseControl {
        let headerView = GDBaseControl(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 88))
        
        
        let iconView = UIImageView.init(frame: CGRect(x: 0, y: headerView.bounds.size.height - 64, width: 64, height: 64))
//        iconView.image = UIImage.init(named: "bg_nohead")
        iconView.sd_setImage(with: URL(string: Account.shareAccount.head_images ?? ""), placeholderImage: placePolderImage, options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])
        headerView.addSubview(iconView)
        
        let nameLbl = UILabel.init()
        nameLbl.text = Account.shareAccount.name
        
        nameLbl.frame =  CGRect(x: iconView.bounds.size.width + 8, y: iconView.frame.midY - nameLbl.font.lineHeight / 2 , width: SCREENWIDTH - iconView.bounds.size.width - 8 , height: nameLbl.font.lineHeight)
        headerView.addSubview(nameLbl)
        headerView.backgroundColor = UIColor.black//orange
        headerView.addTarget(self , action: #selector(headerViewClick(sender:)), for: UIControlEvents.touchUpInside)
        return headerView
    }
    @objc func headerViewClick(sender:GDBaseControl)  {
        mylog("头视图点击")
    }
    // MARK: 注释 : 代理
    func trendsCellItemClick(model : BaseControlModel ,  imageControl : GDPicView){
        mylog(model.title)
//        if let circleID = model.title {
//            let model = GDBaseModel.init(dict: nil)
//            model.actionkey = "GDCircleDetailVC"
//            model.keyparamete = circleID as AnyObject?
//            GDSkipManager.skip(viewController: self , model: model)
//
//        }
        if let circleID = model.title {
            let dataModel = GDBaseModel.init(dict: nil )
            let selectedCircleID = circleID
            //            self.selectedTitle = dataModel.circle_name ?? ""
            //            if dataModel.permission == 1 {
            dataModel.actionkey = "GDCircleDetailVC2"
            let para = ["id" : selectedCircleID ] as [String : String]
            dataModel.keyparamete = para as AnyObject
            GDSkipManager.skip(viewController: self , model: dataModel)
            //            }else{//输入密码再进
            //                self.setupPwdInput()
            //            }
        }
    }
    func trendsCellMoreClick(model : GDTrendsCellModel){//没用 , 但又不删
        mylog("点击更多")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.datas.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "DayDetailCell")
        if cell == nil  {
            cell = DayDetailCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DayDetailCell")
        }
        if let cellReal  = cell as? DayDetailCell {
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
        var rows = (model.items?.count)!  /  4
        let left = (model.items?.count)!  % 4
        var bottomH : CGFloat = 0
        if  (left > 0 )  {
            rows = rows + 1
        }
        bottomH = CGFloat(rows) * picW + CGFloat(rows + 1) * margin
        return topH + bottomH
    }

}
