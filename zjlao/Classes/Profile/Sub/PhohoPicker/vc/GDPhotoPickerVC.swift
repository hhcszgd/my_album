//
//  GDPhotoPickerVC.swift
//  zjlao
//
//  Created by WY on 2017/9/19.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDPhotoPickerVC: GDNormalVC , GDImagePickerviewDelegate {
    let imgPicker =  GDImagePickview.init(frame: CGRect(x: 0, y: 0, width: 350, height: 600))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgPicker.frame =  CGRect(x: 0, y: 0, width:
            self.view.bounds.width, height: self.view.bounds.height)
        self.view.addSubview(imgPicker)
        imgPicker.delegate  = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scrollDirection() -> UICollectionViewScrollDirection {
       return  UICollectionViewScrollDirection.horizontal
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
