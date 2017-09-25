//
//  GDEditNameVC.swift
//  zjlao
//
//  Created by WY on 2017/9/25.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDEditNameVC: GDNormalVC {
    var customTitle : String = ""
    var originalValue : String = "0"
    
    lazy var male : GDRowView = GDRowView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    lazy var  famale : GDRowView = GDRowView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    lazy var  textFiled = UITextField.init(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44) )
    
    convenience init(title : String , originalValue : String){
        self.init()
        self.customTitle = title
        self.originalValue = originalValue
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        self.setupNaviBar()
        // Do any additional setup after loading the view.
        self.setupContent()
    }
    func setupContent() {
        switch self.customTitle {
        case "修改姓名":
            if self.textFiled.superview == nil {
                self.view.addSubview(textFiled)
                self.textFiled.backgroundColor = UIColor.white
                textFiled.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 30, height: 44))
                textFiled.leftViewMode = UITextFieldViewMode.always
                textFiled.center = CGPoint(x: self.view.bounds.width/2, y: 96)
                textFiled.text = self.originalValue
            }
        case "修改性别":
            if self.male.superview == nil && self.famale.superview == nil {
             self.view.addSubview(male)
                self.view.addSubview(famale)
                male.center = CGPoint(x: self.view.bounds.width/2, y: 100)
                male.titleLabel.text = "男"
                let selectIconW : CGFloat = 30
                
                let maleImgView = UIImageView.init(frame: CGRect(x: male.bounds.width - selectIconW * 2 , y: (male.bounds.height - selectIconW)/2, width: selectIconW, height: selectIconW))
                maleImgView.image = UIImage.init(named:"icon_selectionbox_sel")
                male.diyView = maleImgView
                male.additionalImageView.isHidden = true
                
                famale.titleLabel.text = "女"
                famale.additionalImageView.isHidden = true
                let famaleImgView = UIImageView.init(frame: CGRect(x: male.bounds.width - selectIconW * 2 , y: (male.bounds.height - selectIconW)/2, width: selectIconW, height: selectIconW))
                famaleImgView.image = UIImage.init(named:"icon_selectionbox_sel")
                famale.diyView = famaleImgView
                famale.center = CGPoint(x: self.view.bounds.width/2, y: 146)
                if self.originalValue == "0"{
                    male.diyView.isHidden = false
                    famale.diyView.isHidden = true
                }else{
                    male.diyView.isHidden = true
                    famale.diyView.isHidden = false
                }
                male.addTarget(self , action: #selector(maleClick(maleView:)), for: UIControlEvents.touchUpInside)
                famale.addTarget(self , action: #selector(famaleClick(famaleView:)), for: UIControlEvents.touchUpInside)
                
            }
        default:
            break
        }
    }
    @objc func maleClick(maleView:GDRowView)  {
        male.diyView.isHidden = false
        famale.diyView.isHidden = true
    }
    
    @objc func famaleClick(famaleView:GDRowView)  {

        male.diyView.isHidden = true
        famale.diyView.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNaviBar()  {
        self.naviBar.backBtn.setImage(UIImage(named: "icon_classify_homepage"), for: UIControlState.normal)
        let  attritit = NSMutableAttributedString.init(string: self.customTitle)
        attritit.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange.init(location: 0, length: attritit.string.characters.count))
        self.naviBar.attributeTitle = attritit
        self.naviBar.backgroundColor = UIColor.black
        let btn = UIButton()
        btn.setTitle("保存", for: UIControlState.normal)
        self.naviBar.rightBarButtons = [btn]
        btn.addTarget(self , action: #selector(save), for: UIControlEvents.touchUpInside)
    }
    @objc func save()  {
        switch self.customTitle {
        case "修改姓名":
            if (self.textFiled.text ?? "").isEmpty{
                GDAlertView.alert("请输入用户名", image: nil , time: 2, complateBlock: nil )
                break
            }
            GDNetworkManager.shareManager.editUserInfomation( name: self.textFiled.text!, success: { (model ) in
                mylog("修改用户名成功\(model.description)")
                if model.status == 200 {
                }
                
                NotificationCenter.default.post(name: NSNotification.Name.init("EditProfileSuccess"), object: Account.shareAccount)
                self.popToPreviousVC()
            }, failure: { (error ) in
                mylog("修改用户名失败\(error)")
                GDAlertView.alert("操作失败", image: nil , time: 2 , complateBlock: nil )
            })
            
        case "修改性别":
            var gender = "0"
            
            if male.diyView.isHidden{//男
                gender = "1"
            }
            GDNetworkManager.shareManager.editUserInfomation( gender: gender, success: { (model ) in
                mylog("修改性别成功\(model.description)")
                
                NotificationCenter.default.post(name: NSNotification.Name.init("EditProfileSuccess"), object: Account.shareAccount)
                self.popToPreviousVC()
            }, failure: { (error ) in
                mylog("修改性别失败\(error)")
                                GDAlertView.alert("操作失败", image: nil , time: 2 , complateBlock: nil )
            })
            
        default:
            break
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
