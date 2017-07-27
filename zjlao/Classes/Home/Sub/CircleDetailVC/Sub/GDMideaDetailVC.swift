//
//  GDMideaDetailVC.swift
//  zjlao
//
//  Created by WY on 20/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//


/*
 
 func requestData(loadDataType:LoadDataType)  {
 
 switch loadDataType {
 case LoadDataType.initialize , LoadDataType.reload:
 //            self.offset = 0
 break
 case LoadDataType.loadMore:
 break
 }
 
 
 GDNetworkManager.shareManager.seeMoreComments(circleID: self.circleID, messageID: self.id, mediaID: self.mediaID, offset: nil , create_at: self.create_at , { (result) in
 mylog("查看媒体全部评论 : \(result.status)")
 mylog(result.data)
 
 var tempComments  : [GDFullMediaComment] = [GDFullMediaComment] ()
 var tempGoods  : [GDFullMediaUser] = [GDFullMediaUser] ()
 if let infoDict = result.data as? [String : AnyObject]{
 
 var offSet : Int = 0
 var pageSize : Int = 0
 var mediaCount : Int = 0
 if let name = infoDict["name"] as? String{
 self.nameLabel.text = "  \(name)"
 }
 if let off_set = infoDict["offset"] as? Int{
 offSet = off_set
 }
 if let tempID = infoDict["id"] as? String{
 self.id = tempID
 }
 if let create_at = infoDict["create_at"] as? String{
 self.timeLabel.text = create_at
 }
 if let original = infoDict["original"] as? String{
 self.bigImageView.sd_setImage(with: URL(string: original))
 }
 
 //                self.offset = offSet + pageSize
 
 if let goodArr = infoDict["good"] as? [[String : AnyObject]]{
 for goodDict in goodArr{
 let goodModel : GDFullMediaUser = GDFullMediaUser.init(dict: goodDict)
 tempGoods.append(goodModel)
 }
 }
 self.goods = tempGoods
 
 if let commentArr = infoDict["comment"] as? [[String : AnyObject]]{
 for commentDict in commentArr{
 let commentModel : GDFullMediaComment = GDFullMediaComment.init(dict: commentDict)
 tempComments.append(commentModel)
 }
 }
 }
 self.comments = tempComments
 /////
 //            if(tempComments.count == 0 ){
 //                self.tableView.mj_header.endRefreshing()
 //                self.tableView.mj_footer.state = MJRefreshState.noMoreData
 //                return
 //            }
 //            switch loadDataType {
 //            case LoadDataType.initialize , LoadDataType.reload:
 //                self.comments = tempDatas
 //                break
 //            case LoadDataType.loadMore:
 //                self.comments.append(contentsOf: tempDatas)
 //                break
 //            }
 
 self.tableView.reloadData()
 //            self.tableView.mj_header.endRefreshing()
 //            self.tableView.mj_footer.state = MJRefreshState.idle
 
 }) { (error ) in
 mylog(error)
 }
 
 }
 

 */


import UIKit
import MJRefresh
import AVKit
class GDMideaDetailVC: GDUnNormalVC  , GDMediaSectionHeaderDelete ,GDMediaSectionFooterDelete , UITextViewDelegate , GDMediaDetailCellDelete {
    
    // MARK: 注释 : propertis
    var currentPage : Int = 1
    var offset : Int = 0
    var mediaCount : Int = 0
    let inputContainer = UIView()
    lazy var textView  = UITextView()
    var datas  : [GDCircleDetailCellModel] = {
        var tempDatas = [GDCircleDetailCellModel]()
        return tempDatas
    }()
    var mediaID : String?
    var circleID : String?
    var currentMediaID : String?//评论用
    
    var messageID : String?
    var create_at : String?
    var id : String = "0" //媒体id

    
    // MARK: 注释 : methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.backgroundColor = UIColor.init(colorLiteralRed: 0.99, green: 0.99, blue: 0.99, alpha: 1)
        self.automaticallyAdjustsScrollViewInsets = false
        
        //////////
        if let paraInfo  = self.keyModel?.keyparamete as? [String : String]  {
            if let tempMediaID = paraInfo["mediaID"] {
                self.mediaID = tempMediaID
            }
            if let tempCircleID = paraInfo["circleID"] {
                self.circleID = tempCircleID
            }
            
            
            if let tempMessageID = paraInfo["messageID"] {
                self.messageID = tempMessageID
            }
            if let creatTime = paraInfo["create_at"] {
                self.create_at = creatTime
            }
            if let tempID = paraInfo["id"] {
                self.id = tempID
            }
            
            
        }


        //////////
        
        
        self.setupTableView()
        self.requestData(loadDataType: LoadDataType.initialize)
        // Do any additional setup after loading the view.
        self.setupTextView()
    }
    
    func setupTextView()  {
        self.inputContainer.addSubview(self.textView)
        
        self.inputContainer.backgroundColor =  UIColor.init(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        self.view.addSubview(self.inputContainer)
        self.textView.enablesReturnKeyAutomatically = true
        self.inputContainer.frame = CGRect(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENWIDTH * 0.4)
        let cancleBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 64, height: 44))
        let confirmBtn = UIButton.init(frame: CGRect(x:self.inputContainer.bounds.size.width - 64 , y: 0, width: 64, height: 44))
        cancleBtn.setTitle("取消", for: UIControlState.normal)
        cancleBtn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        cancleBtn.addTarget(self , action: #selector(cancleBtnClick), for: UIControlEvents.touchUpInside)
        inputContainer.addSubview(cancleBtn)
        
        confirmBtn.setTitle("确定", for: UIControlState.normal)
        confirmBtn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        confirmBtn.addTarget(self , action: #selector(confirmBtnClick), for: UIControlEvents.touchUpInside)
        inputContainer.addSubview(confirmBtn)
        
        self.textView.frame = CGRect(x: 10, y: 44, width: self.inputContainer.frame.size.width - 20, height: self.inputContainer.frame.size.height - 44 - 10)
        self.textView.returnKeyType = UIReturnKeyType.done
        self.textView.delegate = self
        NotificationCenter.default.addObserver(self , selector: #selector(keyboardWillHide(info:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self , selector: #selector(keyboardWillShow(info:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func cancleBtnClick()  {
        self.textView.resignFirstResponder()
    }
    func confirmBtnClick()  {
        if textView.text.characters.count > 0  {
            if self.currentMediaID != nil  {
                GDNetworkManager.shareManager.commentAndLike(mediaID: self.currentMediaID!, isLike: "0", content: self.textView.text, { (result ) in
                    mylog("评论成功\(result.data)")
                    self.requestData(loadDataType: LoadDataType.initialize)
                }, failure: { (error ) in
                    mylog("发表评论请求失败 : \(error)")
                })
            }
            self.textView.text = nil
            self.currentMediaID = nil
        }
        self.cancleBtnClick( )
        
    }
    func keyboardWillHide(info:NSNotification)  {
        var realTime : TimeInterval = 0.25
        let timeInterval = info.userInfo?[UIKeyboardAnimationDurationUserInfoKey]
        if let timeAny  = timeInterval  {
            if let time  = timeAny as? TimeInterval {
                realTime = time
            }
        }
        UIView.animate(withDuration: realTime) {
            self.inputContainer.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.inputContainer.bounds.size.width / 2 + SCREENHEIGHT)
        }
        
    }
    func keyboardWillShow(info:NSNotification)  {
        var realTime : TimeInterval = 0.25
        let timeInterval = info.userInfo?[UIKeyboardAnimationDurationUserInfoKey]
        let keyboardEndFrame = info.userInfo?[UIKeyboardFrameEndUserInfoKey] ; // as CGRect
        if let timeAny  = timeInterval  {
            if let time  = timeAny as? TimeInterval {
                realTime = time
            }
        }
        
        if let keyboardFrame = keyboardEndFrame {
            if let keyboardFrameRect = keyboardFrame as? CGRect {
                mylog(keyboardFrameRect)
                UIView.animate(withDuration: realTime) {
                    self.inputContainer.center = CGPoint(x: self.view.bounds.size.width / 2, y: keyboardFrameRect.origin.y - self.inputContainer.bounds.size.height / 2)
                }
            }
            
        }
        
    }
    func setupTableView()  {
        //        self.tableView.frame = CGRect(x: 0, y: NavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - NavigationBarHeight)
        self.tableView.backgroundColor = UIColor.white
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.delegate  = self
        self.tableView.dataSource = self
        self.tableView.mj_footer = nil
        self.tableView.mj_header = nil
        
        
        
    }
    override func loadMore () {
        self.requestData(loadDataType: LoadDataType.loadMore)
    }
    override func refresh()  {
        self.requestData(loadDataType: LoadDataType.initialize)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        mylog(self.datas.count)
        return self.datas.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.datas[section].comments?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "GDMediaDetailCell")
        if cell == nil  {
            cell = GDMediaDetailCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "GDMediaDetailCell")
        }
        
        if let cellReal  = cell as? GDMediaDetailCell {
            cellReal.singleComment = self.datas[indexPath.section].comments?[indexPath.row]
            cellReal.cellDelegate  = self
            return cellReal
        }
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var totalHeight : CGFloat = 0
        let margin : CGFloat = 5.0
        totalHeight += margin
        let iconW  : CGFloat = 64
        
        totalHeight += iconW
        totalHeight += margin
        let bigImgW = SCREENWIDTH //- iconW * 2
        totalHeight += bigImgW
        
        let discripH : CGFloat = 30
        let model = self.datas[section]
        if !(model.descrip?.isEmpty ?? true)   && model.descrip?.characters.count ?? 0 > 0{
            totalHeight += discripH
            
            
        }
        let lineBottomOfDescripH = margin
        totalHeight += lineBottomOfDescripH
        
        let zanBtnH : CGFloat = 44
        totalHeight += zanBtnH
        
        
        let lineBottomOfZanbtnH  = margin
        totalHeight += lineBottomOfZanbtnH
        
        var  arrowH : CGFloat = 0
        if model.goods?.count ?? 0 > 0 || model.comments?.count ?? 0 > 0  {
            arrowH  = 8.0
        }
        totalHeight += arrowH
        let zanContainerH : CGFloat = self.getZanHeight(model: model)
        totalHeight += zanContainerH
        return totalHeight//需要计算
    }
    
    
    func getZanHeight(model : GDCircleDetailCellModel) -> CGFloat {
        
        
//        let zanContainerMaxW :CGFloat = SCREENWIDTH - 44 * 2
        let margin : CGFloat = 5
        let zanContainerMaxW :CGFloat = SCREENWIDTH - margin * 2
        var currentW : CGFloat = margin
        var currentH : CGFloat = margin
        
        let zanContainer = UIView()
        for subview in zanContainer.subviews {
            subview.removeFromSuperview()
        }
        zanContainer.addSubview(UIImageView(image: UIImage(named:"like_black")))
        for zanModel in model.goods ?? [] {
            let zan = GDZanUser()
            zan.model = zanModel
            zanContainer.addSubview(zan)
        }
        
        if model.goods?.count ?? 0 > 0  {
            var zanitemH : CGFloat = 0
            for (index ,subView) in zanContainer.subviews.enumerated() {
                if let zanLogo = subView as? UIImageView {
                    zanLogo.frame =  CGRect(x: margin , y: margin  , width: 14, height:14 )
                    currentW += (margin + 14)
                }
                if let zanView = subView as? GDZanUser {
                    zanitemH = zanView.bounds.size.height
                    let tempmodel =  model.goods?[index-1]
                    //                    tempmodel?.switchState = true
                    zanView.model = tempmodel
                    if zanView.bounds.size.width > zanContainerMaxW - currentW - margin {
                        currentH += (zanView.bounds.size.height + margin)
                        currentW = margin
                        if index == (model.goods?.count ?? 0) {
                            tempmodel?.switchState = false
                        }else{
                            tempmodel?.switchState = true
                        }
                        zanView.model = tempmodel
                        zanView.frame = CGRect(x: currentW, y: currentH, width: zanView.bounds.size.width, height: zanView.bounds.size.height)
                    }else{
                        if index == (model.goods?.count ?? 0) {//隐藏最后一个人得逗号
                            tempmodel?.switchState = false
                        }else{
                            tempmodel?.switchState = true
                        }
                        if currentW == margin  {//隐藏行尾人后面的逗号
                            let tempmodel2 =  model.goods?[index-1]
                            tempmodel2?.switchState = false
                            if let priviousZanview = zanContainer.subviews[index - 2] as? GDZanUser{
                                priviousZanview.model = tempmodel2
                            }
                        }
                        
                        zanView.frame = CGRect(x: currentW , y: currentH   , width: zanView.bounds.size.width, height: zanView.bounds.size.height)
                        currentW += (zanView.bounds.size.width + margin)
                        
                        zanView.model = tempmodel
                    }
                }
            }
            currentH += (zanitemH + margin)
            if model.comments?.count ?? 0  > 0  {
                currentH += 1
            }
            return currentH
        }else{
            return 0
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00000001 // delete footer
        let  model = self.datas[section]
        return (model.comment_count?.intValue ?? 0 ) > 2 ? (30 + 10) : 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerOption = tableView.dequeueReusableHeaderFooterView(withIdentifier: "GDMediaSectionHeader")
        if let header = headerOption as? GDMediaSectionHeader{
            
            header.model = self.datas[section]
            header.cellDelegate  = self
            return header
        }else{
            let header = GDMediaSectionHeader.init(reuseIdentifier: "GDMediaSectionHeader")
            
            header.model = self.datas[section]
            header.cellDelegate  = self
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil //deletefooter
        let  model = self.datas[section]
        let footerOption = tableView.dequeueReusableHeaderFooterView(withIdentifier: "GDMediaSectionFooter")
        if let footer = footerOption as? GDMediaSectionFooter {
            footer.commentCount = model.comment_count?.intValue ?? 0
            footer.mediaID = model.id
            footer.delegate = self
            return footer
        }else{
            let footer = GDMediaSectionFooter.init(reuseIdentifier: "GDMediaSectionFooter")
            footer.commentCount = model.comment_count?.intValue ?? 0
            footer.mediaID = model.id
            footer.delegate = self
            return footer
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let cell =  GDCircleDetailCell()
        if   let model = self.datas[indexPath.section].comments?[indexPath.row]{
            let backColorViewW = SCREENWIDTH - 44 * 2
            let horizontalMargin  :CGFloat = 5
            let verticalMargin : CGFloat = 2
            let maxWidth =  backColorViewW - horizontalMargin * 2
            let fullCommtenStr = (model.title ?? "") + ": " + (model.subTitle ?? "")
            let size = fullCommtenStr.sizeWith(font: cell.commetTextLabel.font, maxWidth: maxWidth)
            let totalH = size.height  + verticalMargin * 2
            return totalH
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model  = self.datas[indexPath.section].comments?[indexPath.row]{
            let comment_user_name = model.title ?? ""
            let comment_user_id = model.additionalTitle ?? "0"
            let id = model.extensionTitle1 ?? ""
            let media_id = model.extensionTitle2 ?? ""
            mylog("评论id:\(id) , 媒体id:\(media_id) , 评论人姓名:\(comment_user_name) , 评论人id: \(comment_user_id)")
        }
        self.textView.resignFirstResponder()
    }
    
    
    
    //媒体详情
    func requestData(loadDataType:LoadDataType)  {
        
        switch loadDataType {
        case LoadDataType.initialize , LoadDataType.reload:
            //            self.offset = 0
            break
        case LoadDataType.loadMore:
            break
        }
        
        GDNetworkManager.shareManager.seeMoreComments(circleID: self.circleID, messageID: self.messageID, mediaID: self.mediaID ?? "0", offset: nil , create_at: self.create_at  , { (result) in
            mylog("查看媒体全部评论 : \(result.status)")
//            mylog(result.data)

            var tempDatas  : [GDCircleDetailCellModel] = [GDCircleDetailCellModel] ()
            if let infoDict = result.data as? [String : AnyObject]{
                let picModel : GDCircleDetailCellModel = GDCircleDetailCellModel.init(dict: infoDict)
                tempDatas.append(picModel)
            }
            self.datas = tempDatas
            self.tableView.reloadData()
        }) { (error ) in
            mylog(error)
        }
        
    }
    
    //圈子详情
    /*
    func requestData(loadDataType:LoadDataType)  {
        
        switch loadDataType {
        case LoadDataType.initialize , LoadDataType.reload:
            self.offset = 0
            break
        case LoadDataType.loadMore:
            break
        }
        
        var tempCircleID = ""
        if let circleID  =  self.keyModel?.keyparamete as? String {
            tempCircleID = circleID
        }else{return}
        GDNetworkManager.shareManager.getCircleMediasList(circleID: tempCircleID, offset: self.offset, { (result) in
            mylog("请求纵向圈子详情结果 : \(result.status)")
            mylog(result.data)
            var tempDatas  : [GDCircleDetailCellModel] = [GDCircleDetailCellModel] ()
            if let infoDict = result.data as? [String : AnyObject]{
                
                var offSet : Int = 0
                var pageSize : Int = 0
                var mediaCount : Int = 0
                if let media_Count = infoDict["mediaCount"] as? Int{
                    mediaCount = media_Count
                }
                if let off_set = infoDict["offset"] as? Int{
                    offSet = off_set
                }
                if let page_Size = infoDict["pageSize"] as? Int{
                    pageSize = page_Size
                }
                self.offset = offSet + pageSize
                if let subMediasArr = infoDict["resultMedia"] as? [[String : AnyObject]]{
                    for subMediaDict in subMediasArr{
                        let picModel : GDCircleDetailCellModel = GDCircleDetailCellModel.init(dict: subMediaDict)
                        tempDatas.append(picModel)
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
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.state = MJRefreshState.idle
            
        }) { (error ) in
            mylog(error)
        }
        
    }
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textView.resignFirstResponder()
    }
    
    // MARK: 注释 : customDelegate
    func zanClick(mediaID:String){
        GDNetworkManager.shareManager.commentAndLike(mediaID: mediaID, isLike: "1", content: nil, { (result ) in
            mylog("点赞结果\(result.status)")
            self.requestData(loadDataType: LoadDataType.initialize)
        }, failure: { (error ) in
            mylog("点赞请求失败 : \(error)")
        })
    }
    //    var currentMediaID : String?
    
    func commentClick(mediaID:String){
        self.currentMediaID = mediaID
        //        self.becomeFirstResponder()
        self.textView.becomeFirstResponder()
        //        self.privateTextView.isHidden = false
        
    }
    
    func seeMoreCmmments(mediaID:String){
        let model = GDBaseModel.init(dict: nil )
        model.actionkey = "GDMideaDetailVC"
        let keyParamete : [String : String ] = ["circleID":self.circleID ?? "0" , "mediaID":mediaID]
        model.keyparamete = keyParamete as AnyObject
        GDSkipManager.skip(viewController: self , model: model)
        
        
    }
    
    
    func bigImageClickToImageBrowser( model  : GDCircleDetailCellModel){//
        self.textView.resignFirstResponder()
        if (model.format ?? "") == "jpeg"  || (model.format ?? "" ) == "png" || (model.format ?? "") == "jpg" {
            
            if let index  =  datas.index(of: model) {
                self.gotoImageBrowser(index: index)
            }
        }else if (model.format ?? "") == "MOV"  || (model.format ?? "") == "mp4" || (model.format ?? "") == "avi"{
            // MARK: 注释 : 替换视频链接movieLink
            if let urlStr  = model.video_url {
                if let url = URL.init(string: urlStr) {
                    let avPlayer : AVPlayer = AVPlayer.init(url: url)
                    avPlayer.play()
                    let avPlayerVC : AVPlayerViewController  = AVPlayerViewController.init()
                    avPlayerVC.player = avPlayer
                    self.present(avPlayerVC, animated: true  , completion: {
                        
                    })
                    
                }
            }
            
        }
    }
    
    func gotoImageBrowser(index : Int = 0)  {
        var phtots = [GDIBPhoto]()
        for model  in datas {
            let photo = GDIBPhoto(dict: nil)
            photo.imageURL = model.original
            phtots.append(photo)
        }
        
        GDIBContentView.init(photos: phtots , showingPage : index)
    }
    
    func bigImageClick(mediaID:String){
        self.seeMoreCmmments(mediaID: mediaID)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if text == "\n" {//点return键走这里
            if self.currentMediaID != nil  {
                GDNetworkManager.shareManager.commentAndLike(mediaID: self.currentMediaID!, isLike: "0", content: self.textView.text, { (result ) in
                    mylog("评论成功\(result.data)")
                    self.requestData(loadDataType: LoadDataType.initialize)
                }, failure: { (error ) in
                    mylog("发表评论请求失败 : \(error)")
                })
            }
            
            
            
            self.textView.text = nil
            self.currentMediaID = nil
            self.textView.resignFirstResponder()
            
            return false
        }else{return true}
    }
    
    func deleteClick(mediaID:String){
        self.testShare()
    }
    func testShare() {
        // 要分享的图片
        let image = UIImage.init(named: "logoPressed")!
        // 要分享的文字
        let str = "茄子媒体分享"
        let url : URL = URL(string : "https://123qz.cn/share.html")!
        // 将要分享的元素放到一个数组中
        let postItems = [ image, str , url] as [Any]
        let activityVC = UIActivityViewController.init(activityItems: postItems, applicationActivities: nil)
        
        // 在展现 activityVC 时，必须根据当前的设备类型，使用适当的方法。在iPad上，必须通过popover来展现view controller。在iPhone和iPodtouch上，必须以模态的方式展现。
        //        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        //            UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        //            [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        //        } else {
        self.present(activityVC, animated: true , completion: nil)
        //        }
        
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.textView.resignFirstResponder()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func gotoUserDetail(userID:String)  {
        //            mylog("\(model.title)  \(model.subTitle)  \(model.imageUrl)")
        let skipModel = GDBaseModel.init(dict: nil )
        skipModel.actionkey = "GDUserHistoryVC"
        skipModel.keyparamete =  userID as AnyObject //model.subTitle as AnyObject//用户id
        GDSkipManager.skip(viewController: self , model: skipModel)
    }
}





/*
import UIKit
import MJRefresh
class GDMideaDetailVC: GDUnNormalVC , UITextViewDelegate {
    var mediaID : String = "0"
    var circleID : String?
    var messageID : String?
    var create_at : String?
    var id : String = "0" //媒体id
    let bigImageView = UIImageView()
    let nameLabel = UILabel()
    let zanButton = UIButton()
    let commentButton = UIButton()
    let timeLabel = UILabel()
    let inputContainer = UIView()
    lazy var textView  = UITextView()
    
    let subZanLogo = UIImageView(image: UIImage(named: "like_black"))
    let subCommentLogo = UIImageView(image: UIImage(named: "comment"))
    
    var comments  : [GDFullMediaComment] = [GDFullMediaComment]() {
        willSet{

        }
        
    }
    var goods  : [GDFullMediaUser]  = [GDFullMediaUser](){
        willSet{
            var headerH : CGFloat = 0
            let margin : CGFloat = 10
            for subview in self.tableView.tableHeaderView?.subviews ?? [] {
                subview.removeFromSuperview()
            }
            if newValue.count > 0 {
                let maxCol : Int = 8
                var realRow : Int = 0
                let row = newValue.count / maxCol // 行数
                let col = newValue.count % maxCol // 列数
                if col > 0  {  realRow = row + 1  }
                let iconMargin : CGFloat = 2
                let iconWidth = (SCREENWIDTH - 2 * 40 ) / CGFloat(maxCol)
                headerH = margin * 2 + CGFloat(realRow) * iconWidth + CGFloat(realRow) * iconMargin
                
                for (index ,model) in newValue.enumerated() {
                    let rowth = index / maxCol
                    let colth = index % maxCol
                    let userIcon = GDFullMediaUserView.init(frame: CGRect(x: 44 + CGFloat(colth) * (iconWidth + iconMargin ), y: margin +  CGFloat(rowth) * (iconWidth + iconMargin ), width: iconWidth, height: iconWidth))
                    userIcon.model = model
                    self.tableView.tableHeaderView?.addSubview(userIcon)
                }
                
            }
            self.tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: headerH)
            let subZanLogo = UIImageView(image: UIImage(named: "like_black"))
            self.tableView.tableHeaderView?.addSubview(subZanLogo)
            subZanLogo.frame = CGRect(x: 14, y: 15, width: 20, height: 20)
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let paraInfo  = self.keyModel?.keyparamete as? [String : String]  {
            if let tempMediaID = paraInfo["mediaID"] {
                self.mediaID = tempMediaID
            }
            if let tempCircleID = paraInfo["circleID"] {
                self.circleID = tempCircleID
            }
            if let tempMessageID = paraInfo["messageID"] {
                self.messageID = tempMessageID
            }
            if let creatTime = paraInfo["create_at"] {
                self.create_at = creatTime
            }
            if let tempID = paraInfo["id"] {
                self.id = tempID
            }
        }
//        self.view.backgroundColor = UIColor.white
        self.setupOtherSubviews()
        self.setupTableView()
        self.requestData(loadDataType: LoadDataType.initialize)
        self.setupTextView()
        // Do any additional setup after loading the view.
    }
    func setupTextView()  {
        self.inputContainer.addSubview(self.textView)
        self.inputContainer.backgroundColor = UIColor.init(colorLiteralRed: 0.9, green: 0.8, blue: 0.8, alpha: 1)
        self.view.addSubview(self.inputContainer)
        self.textView.enablesReturnKeyAutomatically = true
        self.inputContainer.frame = CGRect(x: 0, y: -SCREENWIDTH, width: SCREENWIDTH, height: SCREENWIDTH * 0.7)
        self.textView.frame = CGRect(x: 10, y: 10, width: self.inputContainer.frame.size.width - 20, height: self.inputContainer.frame.size.height - 20)
        self.textView.returnKeyType = UIReturnKeyType.done
        self.textView.delegate = self
        NotificationCenter.default.addObserver(self , selector: #selector(keyboardWillHide(info:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self , selector: #selector(keyboardWillShow(info:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    func keyboardWillHide(info:NSNotification)  {
        var realTime : TimeInterval = 0.25
        let timeInterval = info.userInfo?[UIKeyboardAnimationDurationUserInfoKey]
        if let timeAny  = timeInterval  {
            if let time  = timeAny as? TimeInterval {
                realTime = time
            }
        }
        UIView.animate(withDuration: realTime) {
            self.inputContainer.center = CGPoint(x: self.view.bounds.size.width / 2, y: -self.inputContainer.bounds.size.width / 2 - 20)
        }
        
    }
    func keyboardWillShow(info:NSNotification)  {
        var realTime : TimeInterval = 0.25
        let timeInterval = info.userInfo?[UIKeyboardAnimationDurationUserInfoKey]
        let keyboardEndFrame = info.userInfo?[UIKeyboardFrameEndUserInfoKey] ; // as CGRect
        if let timeAny  = timeInterval  {
            if let time  = timeAny as? TimeInterval {
                realTime = time
            }
        }
        
        if let keyboardFrame = keyboardEndFrame {
            if let keyboardFrameRect = keyboardFrame as? CGRect {
                mylog(keyboardFrameRect)
                UIView.animate(withDuration: realTime) {
                    self.inputContainer.center = CGPoint(x: self.view.bounds.size.width / 2, y: keyboardFrameRect.origin.y - self.inputContainer.bounds.size.width / 2)
                }
            }
            
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if text == "\n" {//点return键走这里
                GDNetworkManager.shareManager.commentAndLike(mediaID: id, isLike: "0", content: self.textView.text, { (result ) in
                    mylog("评论成功\(result.status)   \(result.data)")
                    self.requestData(loadDataType: LoadDataType.initialize)
                }, failure: { (error ) in
                    mylog("发表评论请求失败 : \(error)")
                })
            
            
            
            self.textView.text = nil
            self.textView.resignFirstResponder()
            
            return false
        }else{return true}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func setupOtherSubviews()  {
        self.view.addSubview(self.bigImageView)
        mylog( UIImage(named:"qieziImgPlaceholder"))
        bigImageView.image = UIImage(named:"qieziImgPlaceholder")
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.zanButton)
        self.zanButton.setImage(UIImage(named: "like_black"), for: UIControlState.normal)
        self.commentButton.setImage(UIImage(named: "comment"), for: UIControlState.normal)
        self.view.addSubview(self.commentButton)
        self.view.addSubview(self.timeLabel)
        self.bigImageView.frame = CGRect(x: 0, y: 20, width: SCREENWIDTH, height: SCREENWIDTH)
        self.bigImageView.image = UIImage(named: "emptyMultilens" )
        let subH : CGFloat = 44
        self.nameLabel.frame = CGRect(x: 0, y: self.bigImageView.frame.maxY, width: SCREENWIDTH, height: subH)
        self.nameLabel.backgroundColor = UIColor.init(colorLiteralRed: 0.5, green: 0.6, blue: 0.7, alpha: 1)
        let margin : CGFloat = 10
        self.timeLabel.frame = CGRect(x: SCREENWIDTH - 88 - margin , y: self.nameLabel.frame.minY, width: 88, height: subH)
        self.commentButton.frame = CGRect(x: self.timeLabel.frame.minX - subH, y: self.nameLabel.frame.minY, width: subH, height: subH)
        self.zanButton.frame = CGRect(x: self.commentButton.frame.minX - subH, y: self.nameLabel.frame.minY, width: subH, height: subH)
        
        self.zanButton.addTarget(self , action: #selector(zanClick), for: UIControlEvents.touchUpInside)
        self.commentButton.addTarget(self , action: #selector(commentClick), for: UIControlEvents.touchUpInside)

    }
    
    // MARK: 注释 : customDelegate
    func zanClick(){
        GDNetworkManager.shareManager.commentAndLike(mediaID: mediaID, isLike: "1", content: nil, { (result ) in
            mylog("点赞成功 \(result.status)  \(result.data)")
            self.requestData(loadDataType: LoadDataType.initialize)
        }, failure: { (error ) in
            mylog("点赞请求失败 : \(error)")
        })
        mylog("赞")
    }
    //    var currentMediaID : String?
    
    func commentClick(){
        mylog("评")
        //        self.becomeFirstResponder()
        self.textView.becomeFirstResponder()
        //        self.privateTextView.isHidden = false
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textView.resignFirstResponder()
        self.textView.text = nil 
    }
    func setupTableView()  {
        self.tableView.mj_header = nil
        self.tableView.mj_footer = nil
        
        self.tableView.frame = CGRect(x: 0, y: self.nameLabel.frame.maxY, width: SCREENWIDTH, height: SCREENHEIGHT - self.nameLabel.frame.maxY - 44 )
        self.tableView.backgroundColor = UIColor.init(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.delegate  = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = UIView()
        
        self.tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: 10, height: 100)
        //        self.tableView.mj_footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
        //        self.tableView.mj_header = GDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refreshOrInit))
        
    }
    
    
    
    func requestData(loadDataType:LoadDataType)  {
        
        switch loadDataType {
        case LoadDataType.initialize , LoadDataType.reload:
//            self.offset = 0
            break
        case LoadDataType.loadMore:
            break
        }
        

        GDNetworkManager.shareManager.seeMoreComments(circleID: self.circleID, messageID: self.id, mediaID: self.mediaID, offset: nil , create_at: self.create_at , { (result) in
            mylog("查看媒体全部评论 : \(result.status)")
            mylog(result.data)
            
            var tempComments  : [GDFullMediaComment] = [GDFullMediaComment] ()
            var tempGoods  : [GDFullMediaUser] = [GDFullMediaUser] ()
            if let infoDict = result.data as? [String : AnyObject]{
                
                var offSet : Int = 0
                var pageSize : Int = 0
                var mediaCount : Int = 0
                if let name = infoDict["name"] as? String{
                    self.nameLabel.text = "  \(name)"
                }
                if let off_set = infoDict["offset"] as? Int{
                    offSet = off_set
                }
                if let tempID = infoDict["id"] as? String{
                    self.id = tempID
                }
                if let create_at = infoDict["create_at"] as? String{
                    self.timeLabel.text = create_at
                }
                if let original = infoDict["original"] as? String{
                    self.bigImageView.sd_setImage(with: URL(string: original))
                }
                
//                self.offset = offSet + pageSize
                
                if let goodArr = infoDict["good"] as? [[String : AnyObject]]{
                    for goodDict in goodArr{
                        let goodModel : GDFullMediaUser = GDFullMediaUser.init(dict: goodDict)
                        tempGoods.append(goodModel)
                    }
                }
                self.goods = tempGoods

                if let commentArr = infoDict["comment"] as? [[String : AnyObject]]{
                    for commentDict in commentArr{
                        let commentModel : GDFullMediaComment = GDFullMediaComment.init(dict: commentDict)
                        tempComments.append(commentModel)
                    }
                }
            }
            self.comments = tempComments
            /////
//            if(tempComments.count == 0 ){
//                self.tableView.mj_header.endRefreshing()
//                self.tableView.mj_footer.state = MJRefreshState.noMoreData
//                return
//            }
//            switch loadDataType {
//            case LoadDataType.initialize , LoadDataType.reload:
//                self.comments = tempDatas
//                break
//            case LoadDataType.loadMore:
//                self.comments.append(contentsOf: tempDatas)
//                break
//            }
            
            self.tableView.reloadData()
//            self.tableView.mj_header.endRefreshing()
//            self.tableView.mj_footer.state = MJRefreshState.idle
            
        }) { (error ) in
            mylog(error)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.comments.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "GDCommentFullCell")
        if cell == nil  {
            cell = GDCommentFullCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "GDCommentFullCell")
        }
        if let cellReal  = cell as? GDCommentFullCell {
            cellReal.model = self.comments[indexPath.row]
            return cellReal
        }
        return cell!
    }
    
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
            var totalH1  : CGFloat = 0
            var totalH2  : CGFloat = 0
            
            let model = self.comments[indexPath.row]
            let iconW : CGFloat = 64
            let margin : CGFloat = 10
            totalH1 += margin
            totalH1 += iconW
            totalH1 += margin
            let nameH : CGFloat = 20
            
            let font = GDFont.systemFont(ofSize: 17) // 这里跟cell的评论内容label的font一致
            let commentSize = model.content?.sizeWith(font: font, maxSize: CGSize(width: SCREENWIDTH - 40 - 64 - margin - margin * 2, height: 888))
            totalH2 += margin
            totalH2 += nameH
            totalH2 +=  margin / 2
            totalH2 += commentSize?.height ?? 0
            totalH2 += margin
            return totalH1 > totalH2 ? totalH1 : totalH2
    }


    func setupTableHeader(goods : [GDFullMediaUser]?)  {
        
    }
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.change(by: scrollView)
    }
    var previousOffset : CGFloat = 0
    var scrollView : UIScrollView = UIScrollView()
    var originContentInset = UIEdgeInsets.zero
    var shouldChanged = true
    func change(by scrollView : UIScrollView) {
//                mylog(scrollView.contentOffset.y)
        
        if scrollView.contentOffset.y > self.previousOffset && shouldChanged {//向下滚
            
            self.shouldChanged = false
            self.changeTableFrame()
            
        }
        self.previousOffset =  scrollView.contentOffset.y
        
//            if self.scrollView != scrollView {
//                self.scrollView = scrollView
//                self.originContentInset = scrollView.contentInset//有必要记录 , 刷新是会改变的
//            }
//            //        mylog(scrollView.contentOffset)
//            if scrollView.contentOffset.y < -originContentInset.top {//下拉刷新部分
//                //                mylog("下拉刷新部分")
//           
//            }else  if scrollView.contentOffset.y >= -originContentInset.top && scrollView.contentOffset.y <= 0 {//inset.top范围
//                mylog("inset.top范围")
//
//            }else if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y <= scrollView.contentSize.height - scrollView.bounds.size.height){//正常范围
//                if scrollView.contentOffset.y > self.previousOffset  && shouldChanged{
//                        self.changeTableFrame()
//                    self.shouldChanged = false
//                    
//                }
//         
//                
//            }else if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom){//上拉加载部分
//                mylog("上拉加载部分")
//            }

    }
    var corver : UIButton?
    
    
    func changeTableFrame()   {
        corver = UIButton(frame: self.view.bounds)
        corver?.addTarget(self , action: #selector(changeBackTableFrame), for: UIControlEvents.touchUpInside)
        self.view.insertSubview(corver!, belowSubview: self.tableView)
        UIView.animate(withDuration: 0.3) { 
            
            self.tableView.frame = CGRect(x: 0, y: 100, width: SCREENWIDTH, height: SCREENHEIGHT - 100 - 44)
        }
    }
    
    func changeBackTableFrame()   {
        shouldChanged = true
        corver?.removeFromSuperview()
        corver = nil
        UIView.animate(withDuration: 0.3) {
             self.tableView.frame = CGRect(x: 0, y: self.nameLabel.frame.maxY, width: SCREENWIDTH, height: SCREENHEIGHT - self.nameLabel.frame.maxY - 44 )
        }
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
*/
