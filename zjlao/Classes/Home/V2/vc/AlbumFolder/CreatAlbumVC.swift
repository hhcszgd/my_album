//
//  CreatAlbumVC.swift
//  zjlao
//
//  Created by WY on 2017/10/23.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SnapKit
class CreatAlbumVC: GDBaseVC {
    let nameTextField = UITextField()
    let checkBox = UIButton()
    let agreement = UIButton()
    let creatBtn = UIButton()
    
    let nameLabel = UILabel()
    let uploadBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configSubviews()
        // Do any additional setup after loading the view.
    }
    func configSubviews(){
        self.view.addSubview(nameTextField)
        self.view.addSubview(checkBox)
        self.view.addSubview(agreement)
        self.view.addSubview(creatBtn)
        self.view.addSubview(nameLabel)
        self.view.addSubview(uploadBtn)
        
        nameTextField.placeholder = "给你的相册取个好听好记可爱的名称吧"
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.textAlignment = NSTextAlignment.center
        
        
        
        self.nameTextField.snp.makeConstraints { (make ) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(100)
        }
        
        
        self.creatBtn.snp.makeConstraints{(make)in
            
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
