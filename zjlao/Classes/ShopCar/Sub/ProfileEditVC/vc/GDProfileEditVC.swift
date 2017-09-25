//
//  GDProfileEditVC.swift
//  zjlao
//
//  Created by WY on 2017/9/24.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDProfileEditVC: GDNormalVC {
    let icon = GDRowView()
    let name = GDRowView()
    let mobile = GDRowView()
    let gender = GDRowView()
    let area = GDRowView()
    let descrip = GDRowView()
    let setting = GDRowView()
    var userInfo =  [String : AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        self.view.addSubview(icon)
        self.view.addSubview(mobile)
        self.view.addSubview(name)
        self.view.addSubview(gender)
        self.view.addSubview(area )
        self.view.addSubview(descrip)
        self.view.addSubview(setting)
        self.setupNaviBar()
        var startY : CGFloat = 80
        self.configRowInfo(rowView: icon , title: "头像", y: startY , h : 64 )
        startY += (icon.bounds.height + 15)
        self.setRowContent(rowView: icon, subTitle: Account.shareAccount.head_images)
        self.configRowInfo(rowView: mobile , title: "手机号码", y: startY  )
        startY += (mobile.bounds.height + 2)
        self.configRowInfo(rowView: name , title: "姓名", y: startY )
        startY += (name.bounds.height + 2)
        self.configRowInfo(rowView: gender, title: "性别", y: startY)
        startY += (gender.bounds.height + 2)
        self.configRowInfo(rowView: area, title: "地区", y: startY)
        startY += (area.bounds.height + 2)
        self.configRowInfo(rowView: descrip, title: "个性签名", y: startY)
        startY += (descrip.bounds.height + 12)
        self.configRowInfo(rowView: setting, title: "设置", y: startY)
        self.requestNetwork()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestNetwork()
    }
    func setupNaviBar()  {
        self.naviBar.backBtn.setImage(UIImage(named: "icon_classify_homepage"), for: UIControlState.normal)
        let  attritit = NSMutableAttributedString.init(string: "个人信息")
        attritit.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange.init(location: 0, length: attritit.string.characters.count))
        self.naviBar.attributeTitle = attritit
        self.naviBar.backgroundColor = UIColor.black
    }
    func configRowInfo(rowView : GDRowView,title:String,y:CGFloat,h:CGFloat = 44)  {
        rowView.titleLabel.text = title
        rowView.frame = CGRect(x: 0, y: y , width: self.view.bounds.width , height: h)
        rowView.addTarget(self , action: #selector(rowAction(sender:)), for: UIControlEvents.touchUpInside)
    }
    func setRowContent(rowView : GDRowView ,subTitle: String?) {
        if (subTitle ?? "").hasPrefix("http") {
            if let url = URL(string : subTitle ?? ""){
                rowView.subImageView.sd_setImage(with: url)
            }
        }else{
            rowView.subTitleLabel.text = subTitle
        }
        rowView.layoutIfNeeded()
    }
    @objc func rowAction(sender : GDRowView) {
        if let title = sender.titleLabel.text{
            let model = GDBaseModel.init(dict: nil )
            switch title {
            case "头像":
                mylog(title)
                model.actionkey = "GDIconEditVC"
                model.keyparamete = self.userInfo["avatar"]
            case "手机号码":
                mylog(title)
                
                
            case "姓名":
                mylog(title)
                let vc  = GDEditNameVC.init(title: "修改姓名", originalValue: (self.userInfo["name"] as? String ) ?? "")
                self.navigationController?.pushViewController(vc , animated: true )
                
                
            case "性别":
                mylog(title)
                let vc  = GDEditNameVC.init(title: "修改性别", originalValue:"\( (self.userInfo["sex"] as? Int ) ?? 0 )")
                self.navigationController?.pushViewController(vc , animated: true )
                
                
            case "地区":
                mylog(title)
                
                
            case "个性签名":
                mylog(title)
                
                
            case "设置":
                mylog(title)
                
                
            default :
                break
            }
            GDSkipManager.skip(viewController: self , model: model )
        }
    }

    func requestNetwork() {
        GDNetworkManager.shareManager.getUserInfomation(userID: Account.shareAccount.member_id ?? "", success: { (model ) in
            if let userInfo = model.data as? [String : AnyObject]{
                self.userInfo = userInfo
                mylog(userInfo)
                /*
                 desctiption = ;
                 city = ;
                 province = ;
 */
                self.setRowContent(rowView: self.icon, subTitle: userInfo["avatar"] as? String)
                
                self.setRowContent(rowView: self.name, subTitle: userInfo["name"] as? String)
                self.setRowContent(rowView: self.mobile, subTitle: userInfo["mobile"] as? String)
                if let gender = userInfo["sex"] as? NSNumber{
                    self.setRowContent(rowView: self.gender, subTitle: gender == 0 ? "男" : "女")
                }
                self.setRowContent(rowView: self.area, subTitle: userInfo["city"] as? String)
                self.setRowContent(rowView: self.descrip, subTitle: userInfo["desctiption"] as? String)
            }
        }) { (error ) in
            mylog("获取用户信息失败\(error)")
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
