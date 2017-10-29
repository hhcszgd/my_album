//
//  CreatAlbumVC.swift
//  zjlao
//
//  Created by WY on 2017/10/23.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//
import WebKit
import Photos
import UIKit
import SnapKit
class CreatAlbumVC: GDBaseVC {
    let nameTextField = UITextField()
    let checkBox = UIButton()
    let agreement = UIButton()
    let creatBtn = UIButton()
    var album_id : String = ""
    
    let nameLabel = UILabel()
    let uploadBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configSubviews()
        
        // Do any additional setup after loading the view.
    }
    func creatAlbum() {
        if !self.checkBox.isSelected {
            GDAlertView.alert("请勾选并同意用户使用协议", image: nil , time: 2, complateBlock: nil )
            return
        }
        if (nameTextField.text ?? "" ).isEmpty {
            GDAlertView.alert("相册名称不能为空", image: nil , time: 2 , complateBlock: nil   )
            return
        }
        GDNetworkManager.shareManager.creatAlbum(albumName: nameTextField.text!, success: { (result ) in
            print("get albums result status : \(result.status) , data :  \(result.data)")
            if result.status == 200 {
                self.nameLabel.text = "\(self.nameTextField.text ?? "")\n创建成功"
                if let dict = result.data as? [String : String]{
                    self.album_id = dict["album_id"] ?? ""
                }
                if let dict = result.data as? [String : Int]{
                    self.album_id = "\(dict["album_id"] ?? 0)"
                }
                self.switchShowStatus(status: false)
            }
        }) { (error ) in
            print("get albums error \(error)")
        }
    }
    func configSubviews(){
        self.view.addSubview(nameTextField)
        self.view.addSubview(checkBox)
        self.view.addSubview(agreement)
        self.view.addSubview(creatBtn)
        self.view.addSubview(nameLabel)
        self.view.addSubview(uploadBtn)
        
        self.checkBox.addTarget(self, action: #selector(checkBoxClick(sender:)), for:UIControlEvents.touchUpInside)
        self.agreement.addTarget(self, action: #selector(agreementClick(sender:)), for: UIControlEvents.touchUpInside)
        
        self.creatBtn.addTarget(self, action: #selector(creatBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        
        self.uploadBtn.addTarget(self, action: #selector(uploadBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        
        
        nameTextField.placeholder = "给你的相册取个好听好记可爱的名称吧"
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.textAlignment = NSTextAlignment.center
        
        creatBtn.layer.borderColor = UIColor.lightGray.cgColor
        creatBtn.layer.borderWidth = 1.0
        creatBtn.setTitle("创  建", for: UIControlState.normal)
        creatBtn.setTitleColor(UIColor.gray, for: UIControlState.normal)
        checkBox.setImage(UIImage(named:"collect_item_not_selected"), for: UIControlState.normal)
        checkBox.setImage(UIImage(named:"collect_item_selected"), for: UIControlState.selected)
        agreement.setTitle("同意<<用户使用协议>>", for: UIControlState.normal)
        agreement.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        agreement.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        agreement.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        
        self.nameTextField.snp.makeConstraints { (make ) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(100)
        }
        
        
        self.creatBtn.snp.makeConstraints{(make)in
            make.centerX.equalToSuperview()
            make.width.equalTo(188)
            make.height.equalTo(44)
            make.top.equalToSuperview().offset(300)
        }
        
        self.checkBox.snp.makeConstraints { (make ) in
            make.centerX.equalTo(creatBtn).offset(-72)
            make.bottom.equalTo(creatBtn.snp.top).offset(-10)
            make.width.height.equalTo(30)
        }
        
        self.agreement.snp.makeConstraints { (make ) in
            make.left.equalTo(checkBox.snp.right).offset(10)
            make.width.equalTo(180)
            make.height.equalTo(30)
            make.centerY.equalTo(checkBox)
        }
        nameLabel.textAlignment = NSTextAlignment.center
        nameLabel.numberOfLines = 2
        nameLabel.text = "\"什么什么什么\"\n创建成功"
        nameLabel.textColor = UIColor.gray
        self.nameLabel.snp.makeConstraints { (make ) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(111)
            make.height.equalTo(64)
        }
        
        self.uploadBtn.backgroundColor =  UIColor.green
        self.uploadBtn.layer.cornerRadius = 5
        self.uploadBtn.layer.masksToBounds = true
        self.uploadBtn.setTitle("上传照片", for: UIControlState.normal)
        self.uploadBtn.snp.makeConstraints{(make)in
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(44)
            make.top.equalToSuperview().offset(300)
        }
        self.checkBox.isSelected = true
        self.switchShowStatus(status: self.checkBox.isSelected)
    }
    func switchShowStatus(status:Bool) {
        self.uploadBtn.isHidden = status
        self.nameLabel.isHidden = status
        self.nameTextField.isHidden = !status
        self.checkBox.isHidden = !status
        self.agreement.isHidden = !status
        self.creatBtn.isHidden = !status
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func checkBoxClick(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        print("checkBoxClick")
    }
    
    @objc func agreementClick(sender:UIButton) {
        print("agreementClick")
        let vc = WebVC.init(urlStr: "http://albumapi.123qz.cn/qzalbum_policy.html")
        self.navigationController?.pushViewController(vc , animated: true )
    }
    @objc func creatBtnClick(sender:UIButton) {
        print("creatBtnClick")
        if self.nameTextField.isFirstResponder {
            self.nameTextField.resignFirstResponder()
        }
        self.creatAlbum()
        
        
        //创建成功调用        self.switchShowStatus(status: false)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PHPhotoLibrary.requestAuthorization({ (status) in})
    }
    @objc func uploadBtnClick(sender:UIButton) {
        print("uploadBtnClick")
        
       self.configPhotoLibrary()
        
        
        
        
    }
    func configPhotoLibrary() {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            
            let alertVC  = UIAlertController.init(title: "上传照片需要访问本地相册" , message: nil , preferredStyle: UIAlertControllerStyle.alert)
            
            let alertAction2 = UIAlertAction.init(title: "允许", style: UIAlertActionStyle.default) { (action ) in
                UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
                alertVC.dismiss(animated: true , completion: {
                    //调用本地相册库
                })
            }
            
            let alertAction3 = UIAlertAction.init(title: "拒绝", style: UIAlertActionStyle.cancel) { (action ) in
                alertVC.dismiss(animated: true , completion: {})
            }
            alertVC.addAction(alertAction2)
            alertVC.addAction(alertAction3)
            self.present(alertVC, animated: true) {}
            
            
            
//            UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
        }else{
            let vc = PickImageVC(albumID: self.album_id)
            self.navigationController?.pushViewController(vc , animated: true )
        }
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if let index = self.navigationController?.viewControllers.index(of: self){//good! It's words
//            self.navigationController?.viewControllers.remove(at: index)
//            
//        }
//        
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    class WebVC: UIViewController {
        var urlStr : String!
        
        convenience init(urlStr:String){
            self.init()
            self.urlStr = urlStr
        }
        let webView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        override func viewDidLoad() {
            super.viewDidLoad()
//            self.title = "用户使用协议"
            self.view.addSubview(webView)
            if let url  = URL.init(string: self.urlStr) {
                let request : URLRequest = URLRequest.init(url: url )
                self.webView.load(request )
            }
        }
        
    }
}

