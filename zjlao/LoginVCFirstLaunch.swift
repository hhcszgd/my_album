//
//  LoginVCFirstLaunch.swift
//  zjlao
//
//  Created by WY on 2017/10/23.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class LoginVCFirstLaunch: UIViewController {
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var mobileBGView: UIView!
    @IBOutlet weak var mobileTextField: UITextField!
    
    @IBOutlet weak var senderCodeButton: UIButton!
    @IBOutlet weak var authCodeTextField: UITextField!
    @IBOutlet weak var authCodeBGView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authCodeBGView.layer.cornerRadius = loginBtn.bounds.height/2
        self.authCodeBGView.backgroundColor = self.authCodeBGView.backgroundColor?.withAlphaComponent(0.5)
        self.mobileBGView.backgroundColor = self.mobileBGView.backgroundColor?.withAlphaComponent(0.5)
        self.mobileBGView.layer.cornerRadius = mobileBGView.bounds.height/2
        senderCodeButton.layer.cornerRadius = senderCodeButton.bounds.height/2
        senderCodeButton.layer.borderWidth = 1
        senderCodeButton.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
    }

    var time : Timer?
    var timeInterval : Int = 60
    
    func deleteTimer()  {
        if time?.isValid ?? false  {
            time?.invalidate()
            time = nil
        }
    }
    
    func addTimer()  {
        if time?.isValid ?? false  {
            time?.invalidate()
            time = nil
        }else{
            self.senderCodeButton.isEnabled = false
            self.senderCodeButton.setTitle("\(self.timeInterval)s后重发", for: UIControlState.disabled)
            time = Timer.init(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil , repeats: true)
            RunLoop.main.add(time!, forMode: RunLoopMode.commonModes)
//            self.senderCodeButton.backgroundColor = UIColor.lightGray
        }
        
    }
    
    @objc func countDown() {
        self.timeInterval -= 1
        if self.timeInterval <= 0  {
            self.senderCodeButton.isEnabled = true
//            self.senderCodeButton.backgroundColor = UIColor.orange
            self.timeInterval = 60
            self.deleteTimer()
        }else{
            self.senderCodeButton.setTitle("\(self.timeInterval)s后重发", for: UIControlState.disabled)
        }
    }
    
    
    @IBAction func sendCodeButtonClick(_ sender: UIButton) {
        //验证手机格式是否正确 todo
        if !self.mobileLawful(mobileStr: self.mobileTextField.text ?? "") {//非法
            if self.mobileTextField.text?.characters.count ?? 0 == 0 {
                GDAlertView.alert("手机号码不能为空", image: nil, time: 2, complateBlock: nil)
            }else{
                GDAlertView.alert("手机号码格式不正确", image: nil, time: 2, complateBlock: nil)
            }
            _ = self.mobileTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
            return
        }
        self.addTimer()
        GDNetworkManager.shareManager.QZGetAuthcode(mobile: self.mobileTextField.text!, { (result) in
            mylog(result.status)
            mylog(result.data)
            if result.status == 200 {//获取成功
                //                GDAlertView.alert("验证码发送成功", image: nil, time: 2, complateBlock: nil)
            }else if (result.status == 308){//验证码获取失败
                //                GDAlertView.alert("验证码获取失败,请重试", image: nil, time: 2, complateBlock: nil)
                
            }else if (result.status == 301){//手机号码格式不正确
                //                GDAlertView.alert("手机号码格式不正确", image: nil, time: 2, complateBlock: nil)
            }else if (result.status == 311){//手机号已被占用, 输入验证码以找回之前账号,验证成功的话,直接跳到首页 , 不用设置用户名和头像
                
                //                GDAlertView.alert("手机号已被占用 , 输入验证码以找回之前账号", image: nil, time: 2, complateBlock: nil)//不提示了
                //doNothing
            }else if (result.status == 300){//手机号码不能为空
                //                GDAlertView.alert("手机号码不能为空", image: nil, time: 2, complateBlock: nil)
                //doNothing
            }else if (result.status == 303){
                //doNothing
            }
        }) { (error ) in
            mylog(error)
        }
    }
    @IBAction func authBtnClick(_ sender: UIButton) {
        //验证手机格式是否正确 todo
        if !self.mobileLawful(mobileStr: self.mobileTextField.text ?? "") {//非法
            if self.mobileTextField.text?.characters.count ?? 0 == 0 {
                GDAlertView.alert("手机号码不能为空", image: nil, time: 2, complateBlock: nil)
            }else{
                GDAlertView.alert("手机号码格式不正确", image: nil, time: 2, complateBlock: nil)
            }
            return
        }
        if !self.authcodeLawful(authCode: self.authCodeTextField.text ?? "") {
            if self.authCodeTextField.text?.characters.count ?? 0 == 0 {
                GDAlertView.alert("验证码不能为空", image: nil, time: 2, complateBlock: nil)
            }else{
                GDAlertView.alert("验证码错误", image: nil, time: 2, complateBlock: nil)
            }
            return
        }
        GDNetworkManager.shareManager.QZAuthentication(mobile: self.mobileTextField.text!, authCode: self.authCodeTextField.text!, { (result) in
            mylog(result.status)
            mylog(result.data)
            
            if result.status == 200 {//验证通过,设置昵称和用户名
                self.afterAuthMobilePerformInit()
                
            }else if (result.status == 303){//验证码验证不通过
                GDAlertView.alert("验证码错误", image: nil, time: 2, complateBlock: nil)
            }else if (result.status == 306){//用户创建失败
                GDAlertView.alert("操作失败 请重试", image: nil, time: 2, complateBlock: nil)
            }else if (result.status == 314){//坐标不能为空
                GDAlertView.alert("gds异常,请检查定位权限", image: nil, time: 2, complateBlock: nil)
            }else if (result.status == 311){//手机号已被占用 调一下初始化接口,判断是否需要设置昵称和用户名 ,否的话直接跳到主页面
                self.afterAuthMobilePerformInit()
            }
            
        }) { (error ) in
            mylog(error)
            GDAlertView.alert("操作异常 请重试", image: nil, time: 2, complateBlock: nil )
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func setKeyvcToMain()  {
        let appDelegateOption = UIApplication.shared.delegate
        if let appDelegate  = appDelegateOption {
            if let realAppdelegate = appDelegate as? AppDelegate {
                if realAppdelegate.window?.rootViewController != GDKeyVC.share {
                    realAppdelegate.window = nil
                    realAppdelegate.window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
                    realAppdelegate.window!.rootViewController = GDKeyVC.share
                    realAppdelegate.window!.makeKeyAndVisible()
                }
                
            }
            
        }
    }
    
    func afterAuthMobilePerformInit()  {
        GDNetworkManager.shareManager.QZFirstInit({ (result ) in
            
            if result.status == 202 {
                
                
                let appDelegateOption = UIApplication.shared.delegate
                if let appDelegate  = appDelegateOption {
                    if let realAppdelegate = appDelegate as? AppDelegate {
                        if realAppdelegate.window?.rootViewController == GDKeyVC.share {
                            //                            self.dismiss(animated: true , completion: {  })
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            self.setKeyvcToMain()
                        }
                    }
                    
                }
            }else if (result.status == 310){
                GDAlertView.alert("操作异常 请重试", image: nil, time: 2, complateBlock: nil )
            }else if (result.status == 203){
//                self.setupIconAndName()
            }else if (result.status == 307){
                GDAlertView.alert("操作异常 请重试", image: nil, time: 2, complateBlock: nil )
            }else{
                GDAlertView.alert("操作异常 请重试", image: nil, time: 2, complateBlock: nil )
            }
        }, failure: { (error ) in
            mylog(error )
            GDAlertView.alert("操作异常 请重试", image: nil, time: 2, complateBlock: nil )
        })
    }
    /** 判断验证码的合法性 */
    
    func authcodeLawful(authCode : String ) -> Bool{
        let  number="^\\d{6}$"
        let numberPre =  NSPredicate(format: "SELF MATCHES %@", number)
        return numberPre.evaluate(with:authCode)
    }
    
    
    /** 判断用户名的合法性 */
    
    func usernameLawful(username:String) -> Bool  {
        let usernameRegex = "^[a-zA-Z][a-zA-Z0-9-_:~]{5,31}$"
        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernamePredicate.evaluate(with: username)
        
    }
    /** 判断手机号的合法性 */
    func mobileLawful(mobileStr:String) -> Bool {
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        let cm = "^13[0-9]{9}$|14[0-9]{9}|15[0-9]{9}$|18[0-9]{9}|17[0-9]{9}$"
        let cu = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let ct = "^1((33|53|8[019])[0-9]|349)\\d{7}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@", mobile)
        let regexCM = NSPredicate(format: "SELF MATCHES %@", cm)
        let regexCU = NSPredicate(format: "SELF MATCHES %@", cu)
        let regexCT = NSPredicate(format: "SELF MATCHES %@", ct)
        
        if regexMobile.evaluate(with: mobileStr) || regexCM.evaluate(with: mobileStr) || regexCU.evaluate(with: mobileStr) || regexCT.evaluate(with: mobileStr) {
            return true
        }else{return false}
        
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
