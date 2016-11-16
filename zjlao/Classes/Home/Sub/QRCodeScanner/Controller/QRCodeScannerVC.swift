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
        self.view.backgroundColor = UIColor.clear
        
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.qrView.session.startRunning()
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


/*
 -(void)creatQRCode
 {
 //  使用coreImage框架中的滤镜来实现生成的二维码
 //  kCICategoryBuiltIn 内置的过滤器的分类
 //    NSArray *filters = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
 //    NSLog(@"%@",filters);
 
 //  1.创建一个用于生成二维码的滤镜
 CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
 
 //  2.设置默认值
 [qrFilter setDefaults];
 
 //  3.设置输入数据
 //    NSLog(@"%@",qrFilter.inputKeys);
 
 [qrFilter setValue:[@"要生成的字符串内容" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
 
 //  4.生成图片
 CIImage *ciImage = qrFilter.outputImage;
 //  默认生成的ciImage的大小是很小
 //    NSLog(@"%@",ciImage);
 
 //  放大ciImage
 CGAffineTransform scale = CGAffineTransformMakeScale(8, 8);
 ciImage = [ciImage imageByApplyingTransform:scale];
 
 //  5.设置二维码的前景色和背景色
 CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
 //  设置默认值
 [colorFilter setDefaults];
 
 //  设置输入的值
 /*
 inputImage,
 inputColor0,
 inputColor1
 
 */
 //    NSLog(@"%@",colorFilter.inputKeys);
 [colorFilter setValue:ciImage forKey:@"inputImage"];
 
 //  设置前景色
 [colorFilter setValue:[CIColor colorWithRed:1 green:0 blue:0] forKey:@"inputColor0"];
 //  设置背景
 [colorFilter setValue:[CIColor colorWithRed:0 green:0 blue:1] forKey:@"inputColor1"];
 //  取出colorFilter中的图片
 ciImage = colorFilter.outputImage;
 
 //  在中心增加一张图片
 UIImage *image = [UIImage imageWithCIImage:ciImage];
 
 //  生成图片
 //  1.开启图片的上下文
 UIGraphicsBeginImageContext(image.size);
 //  2.把二维码的图片划入
 [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
 //  3.在中心画其他图片
 UIImage *weiImage = [UIImage imageNamed:@"bg_franchise"];//要插入的图片
 CGFloat weiW = 40;
 CGFloat weiH = 40;
 CGFloat weiX = (image.size.width - weiW) * 0.5;
 CGFloat weiY = (image.size.height - weiH) * 0.5;
 
 [weiImage drawInRect:CGRectMake(weiX, weiY, weiW, weiH)];
 
 //  取出图片
 //    UIImage *qrImage =  UIGraphicsGetImageFromCurrentImageContext();
 
 //  结束上下文
 UIGraphicsEndImageContext();
 
 //    self.imageView.image = qrImage;
 
 }

 
 */
