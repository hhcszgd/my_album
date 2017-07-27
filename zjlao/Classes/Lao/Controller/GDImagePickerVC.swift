//
//  GDImagePickerVC.swift
//  zjlao
//
//  Created by WY on 17/3/30.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import MobileCoreServices

class GDImagePickerVC: GDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCarame()
        self.setupSubviews()
        // Do any additional setup after loading the view.
    }

    func setupSubviews() {
        let cancle  = UIButton(frame: CGRect(x: 0, y: SCREENHEIGHT - 44, width: 44, height: 44))
        let done =  UIButton(frame: CGRect(x: SCREENWIDTH - 44 , y: SCREENHEIGHT - 44 , width: 44, height: 44))
//        self.naviBar.leftBarButtons = [cancle]
//        self.naviBar.rightBarButtons = [done]
        self.view.addSubview(cancle)
        self.view.addSubview(done)
        cancle.backgroundColor = UIColor.blue
        done.backgroundColor = UIColor.blue
        cancle.addTarget(self , action: #selector(cancleClick), for: UIControlEvents.touchUpInside)
        done.addTarget(self , action: #selector(doneClick), for: UIControlEvents.touchUpInside)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupCarame ()  {
        //return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (!UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear ) || !UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front )){
            GDAlertView.alert("摄像头不可用", image: nil , time: 2, complateBlock: nil)
        }
        let picker = UIImagePickerController.init()
        picker.sourceType = UIImagePickerControllerSourceType.camera//这一句一定在下一句之前
        //        picker.mediaTypes = [kUTTypeVideo ,kUTTypeAVIMovie , kUTTypeImage]
        picker.mediaTypes = [kUTTypeMovie as String , kUTTypeVideo as String , kUTTypeImage as String  , kUTTypeJPEG as String , kUTTypePNG as String]
        picker.allowsEditing = true ;
        picker.showsCameraControls = true
        picker.cameraOverlayView = UISwitch()
        //  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.photo
        self.navigationController?.present(picker, animated: true) {
            
        }
    }
    
    func cancleClick() {
        mylog("sadfasd")
        self.dismiss(animated: true , completion: nil )
    }
    func doneClick() {
        mylog("done")
        self.dismiss(animated: true , completion: nil )

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
