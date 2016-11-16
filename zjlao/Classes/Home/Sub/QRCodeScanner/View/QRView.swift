//
//  QRView.swift
//  zjlao
//
//  Created by WY on 16/11/9.
//  Copyright © 2016年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import AVFoundation
class QRView: UIView ,AVCaptureMetadataOutputObjectsDelegate{
    var delegate : QRViewDelegate?
    let bgView  = UIImageView()//背景框
    let lineView = UIImageView()//上下扫描的线
    let session = AVCaptureSession()
    var sublayer    : AVCaptureVideoPreviewLayer!

    /**
     *  设置CZQRView的layer是AVCaptureVideoPreviewLayer
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.configQR()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup ()  {
        self.addSubview( bgView)
        self.addSubview(lineView)
        self.bgView.image = UIImage.init(named: "pick_bg")
        self.lineView.image = UIImage.init(named: "line")
        
    }
    func configQR()  {
        //  创建输入对象
        //  默认是后置摄像头
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
//        let error = NSError()
//        let input  = AVCaptureDeviceInput.init(device: device)
        do {
            let input = try  AVCaptureDeviceInput.init(device: device)
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
//            input = inp
        } catch {
            mylog(error)
        }
        
        
        
        //  创建输出设备
        
        let output = AVCaptureMetadataOutput.init()
        
        //链接设备
//        if self.session.canAddInput(input) {
//            self.session.addInput(input)
//        }
        
        //  设置输出对象的元数据类型
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        if self.session.canAddOutput(output) {
            self.session.addOutput(output)
        }
        output.metadataObjectTypes = output.availableMetadataObjectTypes;
        self.sublayer = AVCaptureVideoPreviewLayer(session: session)
        sublayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        
        self.layer.addSublayer(sublayer!);
//        let layer : AVCaptureVideoPreviewLayer = self.layer as! AVCaptureVideoPreviewLayer
//        
//        layer.session = session
        //开始运行session
//        self.session.startRunning()
    }
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        sublayer?.frame = self.layer.bounds
        
    }
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        let obj : AVMetadataMachineReadableCodeObject = metadataObjects.first! as! AVMetadataMachineReadableCodeObject
        if obj.stringValue.characters.count > 0 {
            if (self.delegate?.responds(to: #selector(QRViewDelegate.qrView(view:didCompletedWithQRValue:)) ))!{
                self.delegate?.qrView(view: self, didCompletedWithQRValue: obj.stringValue)
            
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let  size = self.bounds.size;
        
        let  bgW : CGFloat = 200
        let bgH  : CGFloat = 200
        let  bgX  : CGFloat = (size.width - bgW) * 0.5;
        let  bgY  : CGFloat = (size.height - bgH) * 0.5;
        //  背景的位置
        self.bgView.frame = CGRect.init(x: bgX, y: bgY, width: bgW, height: bgH)
        //  线的frame
        self.lineView.frame = CGRect.init(x: bgX, y: bgY, width: bgW, height: 2)
        
        //  使用核心动画
        self.lineView.layer.removeAnimation(forKey: "positionAnimation")
        let  positionAnimation : CABasicAnimation =  CABasicAnimation.init(keyPath: "position.y")
//        let  positionAnimation : CABasicAnimation = CABasicAnimation.animationWithKeyPath:"position.y"];
        
        positionAnimation.fromValue = (bgY);
        
        positionAnimation.toValue = (self.bgView.frame.maxY)
        
        positionAnimation.duration = 2
        
        positionAnimation.repeatCount = Float(NSIntegerMax)
        self.lineView.layer.add(positionAnimation, forKey: "positionAnimation")
//        [self.lineView.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
    }
    func startsesstion()  {
//        self.session.startRunning()
    }
}
    /**
     /**
     *  当输出对象解析到相应地内容的时候,就会调用该方法
     */
     - (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
     {
     AVMetadataMachineReadableCodeObject *obj = [metadataObjects firstObject];
     
     if (obj.stringValue.length != 0) {
     if ([self.delegate respondsToSelector:@selector(qrView:didCompletedWithQRValue:)]) {
     [self.delegate qrView:self didCompletedWithQRValue:obj.stringValue];
     }
     [self.session stopRunning];
     }
     }
     
     
     
     - (void)layoutSubviews
     {
     [super layoutSubviews];
     
     CGSize size = self.bounds.size;
     
     CGFloat bgW = 200;
     CGFloat bgH = 200;
     CGFloat bgX = (size.width - bgW) * 0.5;
     CGFloat bgY = (size.height - bgH) * 0.5;
     //  背景的位置
     self.bgView.frame = CGRectMake(bgX, bgY, bgW, bgH);
     //  线的frame
     self.lineView.frame = CGRectMake(bgX, bgY, bgW, 2);
     
     //  使用核心动画
     [self.lineView.layer removeAnimationForKey:@"positionAnimation"];
     
     CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
     
     positionAnimation.fromValue = @(bgY);
     
     positionAnimation.toValue = @(CGRectGetMaxY(self.bgView.frame));
     
     positionAnimation.duration = 2;
     
     positionAnimation.repeatCount = NSIntegerMax;
     
     [self.lineView.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
     }

     
     */
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


