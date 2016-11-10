//
//  QRCodeScannerVC.swift
//  zjlao
//
//  Created by WY on 16/11/9.
//  Copyright © 2016年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class QRCodeScannerVC: VCWithNaviBar , QRViewDelegate {
    let qrView  = QRView()
    override func viewDidLoad() {
        super.viewDidLoad()
     self.setup()
        // Do any additional setup after loading the view.
    }
    func setup()  {
        let frame = CGRect(x: 0, y: 64, width: screenW, height: screenH - 64)
        self.view.addSubview(self.qrView)
        self.qrView.delegate = self
        self.qrView.frame  =  frame
    
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
    func qrView(view: QRView, didCompletedWithQRValue: String) {
        mylog(didCompletedWithQRValue)
        view.removeFromSuperview()
    }
}
