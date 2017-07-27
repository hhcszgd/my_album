/*//
//  GDImageCaptureVC.swift
//  zjlao
//
//  Created by WY on 17/3/26.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import AVFoundation
import GPUImage
class GDImageCaptureVC: GDNormalVC {
    var camera: Camera!
    var basicOperation: BasicOperation!
    var renderView: RenderView!
    var isset = false
    var imageOutput : PictureOutput?
    lazy var imageView: UIImageView = {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 200 ))
        imageView.image = UIImage(named: "icon_wechatpay")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let btn1 = UIButton.init(frame: CGRect(x: 0, y: 0, width: 44.0, height: 44.0))
    
    let btn2 = UIButton.init(frame: CGRect(x: SCREENWIDTH-44, y: 0, width: 44.0, height: 44.0))
    let btn3 = UIButton.init(frame: CGRect(x: 0, y: SCREENHEIGHT-44, width: 44.0, height: 44.0))
    let btn4 = UIButton.init(frame: CGRect(x: SCREENWIDTH-44, y: SCREENHEIGHT-44, width: 44.0, height: 44.0))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        self.view.addSubview(btn1)
        self.view.addSubview(btn2)
        
        self.view.addSubview(btn3)
        self.view.addSubview(btn4)
        btn1.backgroundColor = UIColor.purple
        btn2.backgroundColor = UIColor.purple
        btn3.backgroundColor = UIColor.purple
        btn4.backgroundColor = UIColor.purple
        
        btn1.addTarget(self , action: #selector(btn1Click(sender:)), for: UIControlEvents.touchUpInside)
        btn2.addTarget(self , action: #selector(btn2Click(sender:)), for: UIControlEvents.touchUpInside)
        btn3.addTarget(self , action: #selector(btn3Click(sender:)), for: UIControlEvents.touchUpInside)
        btn4.addTarget(self , action: #selector(btn4Click(sender:)), for: UIControlEvents.touchUpInside)
        self.naviBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func btn1Click(sender:UIButton) {
        // 启动实时视频滤镜
//        self.cameraFiltering()
        self.captureImageFromVideo()

    }
    func btn2Click(sender:UIButton) {
        // MARK: - 从实时视频中截图图片
//        self.captureImageFromVideo()
    }
    func btn3Click(sender:UIButton) {
        self.isset = true
    }
    func btn4Click(sender:UIButton) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        self.cameraFiltering()
//        self.captureImageFromVideo()
        //        self.filteringImage()
        //        self.customFilter()
        //        self.operationGroup()
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

extension GDImageCaptureVC/* : CameraDelegate*/{
    
    
    /*
    func didCaptureBuffer(_ sampleBuffer: CMSampleBuffer) {
        //        guard shouldDetectFaces else {
        //            lineGenerator.renderLines([]) // clear
        //            return
        //        }
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            let attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, CMAttachmentMode(kCMAttachmentMode_ShouldPropagate))!
            let img = CIImage(cvPixelBuffer: pixelBuffer, options: attachments as? [String: AnyObject])
            mylog(Thread.current)
            DispatchQueue.main.async {
                mylog(Thread.current)
                if self.isset {
                    let uiimage = UIImage.init(ciImage: img)
                    let ciImg = uiimage.ciImage
                    mylog(ciImg)
                    let upImage = UIImage(ciImage: img, scale: 1, orientation: UIImageOrientation.up)

                    self.isset = false
                }
                
            }
            

        }
    }
    */

    
    
    
    
    
    
    
    
    
    
    // MARK: - 实时视频滤镜，将相机捕获的图像经过处理显示在屏幕上
    func cameraFiltering() {
        
        // Camera的构造函数是可抛出错误的
        do {
            // 创建一个Camera的实例，Camera遵循ImageSource协议，用来从相机捕获数据
            
            /// Camera的指定构造器
            ///
            /// - Parameters:
            ///   - sessionPreset: 捕获视频的分辨率
            ///   - cameraDevice: 相机设备，默认为nil
            ///   - location: 前置相机还是后置相机，默认为.backFacing
            ///   - captureAsYUV: 是否采集为YUV颜色编码，默认为true
            /// - Throws: AVCaptureDeviceInput构造错误
            camera = try Camera(sessionPreset: AVCaptureSessionPreset1280x720,
                                cameraDevice: nil,
                                location: .backFacing,
                                captureAsYUV: true)
//            camera.runBenchmark = true
//            camera.delegate = self
            // Camera的指定构造器是有默认参数的，可以只传入sessionPreset参数
            // camera = try Camera(sessionPreset: AVCaptureSessionPreset1280x720)
            
        } catch {
            

            camera = nil
            print("Couldn't initialize camera with error: \(error)")
            return
        }
        
        // 创建一个Luminance颜色处理滤镜
//        basicOperation = Luminance()
        basicOperation = FalseColor()
        
        // 创建一个RenderView的实例并添加到view上，用来显示最终处理出的内容
        renderView = RenderView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 200))
//        view.addSubview(renderView)
        view.insertSubview(renderView, belowSubview: self.btn1)
        // 绑定处理链
        camera --> basicOperation --> renderView
    
        // 开始捕捉数据
        camera.startCapture()
        
        // 结束捕捉数据
//         camera.stopCapture()
    }
    
    // MARK: - 从实时视频中截图图片
    func captureImageFromVideo() {
        
//        // 启动实时视频滤镜
        self.cameraFiltering()
        
        
        // 设置保存路径
        guard let outputPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        
        let originalPath = outputPath + "/originalImage.png"
        print("path: \(originalPath)")
        let originalURL = URL(fileURLWithPath: originalPath)
        
        let filteredPath = outputPath + "/filteredImage.png"
        print("path: \(filteredPath)")
        let filteredlURL = URL(fileURLWithPath: filteredPath)
        
        // 延迟1s执行，防止截到黑屏
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            
            // 保存相机捕捉到的图片
//            self.camera.saveNextFrameToURL(originalURL, format: .png)
            
            // 保存滤镜后的图片
//            self.basicOperation.saveNextFrameToURL(filteredlURL, format: .png)
            // 如果需要处理回调，有下面两种写法
            //第一种
//            let dataOutput = PictureOutput()
//            dataOutput.encodedImageFormat = .png
//            dataOutput.encodedImageAvailableCallback = {imageData in
//                // 这里的imageData是截取到的数据，Data类型
//                mylog(imageData)
//            }
//            self.camera --> dataOutput
            //或者第二种
            let imageOutput = PictureOutput()
//            imageOutput.onlyCaptureNextFrame = false
            self.imageOutput = imageOutput
            imageOutput.encodedImageFormat = .png
            imageOutput.imageAvailableCallback = {image in
                // 这里的image是截取到的数据，UIImage类型
                DispatchQueue.main.async {
                    mylog(image)
                    self.imageView.image = image.filterWithOperation(Luminance())
//                    self.renderView.removeFromSuperview()
                    
                }
                mylog(Thread.current)

            }
            
            self.camera --> imageOutput
            let img = UIImage.init(contentsOfFile: originalPath)
            print(img ?? "取不到图片")//fuc
//            self.imageView.image = img//fuck 但取的是上一次的图片

            
        }
    }
    
    // MARK: - 处理静态图片
    func filteringImage() {
        
        // 创建一个BrightnessAdjustment颜色处理滤镜
        let brightnessAdjustment = BrightnessAdjustment()
        brightnessAdjustment.brightness = 0.2
        
        // 创建一个ExposureAdjustment颜色处理滤镜
        let exposureAdjustment = ExposureAdjustment()
        exposureAdjustment.exposure = 0.5
        
        // 1.使用GPUImage对UIImage的扩展方法进行滤镜处理
        var filteredImage: UIImage
        
        // 1.1单一滤镜
        filteredImage = imageView.image!.filterWithOperation(brightnessAdjustment)
        
        // 1.2多个滤镜叠加
        filteredImage = imageView.image!.filterWithPipeline { (input, output) in
            input --> brightnessAdjustment --> exposureAdjustment --> output
        }
        
        // 不建议的
        imageView.image = filteredImage
        
        // 2.使用管道处理
        
        // 创建图片输入
        let pictureInput = PictureInput(image: imageView.image!)
        // 创建图片输出
        let pictureOutput = PictureOutput()
        // 给闭包赋值
        pictureOutput.imageAvailableCallback = { image in
            // 这里的image是处理完的数据，UIImage类型
        }
        // 绑定处理链
        pictureInput --> brightnessAdjustment --> exposureAdjustment --> pictureOutput
        // 开始处理 synchronously: true 同步执行 false 异步执行，处理完毕后会调用imageAvailableCallback这个闭包
        pictureInput.processImage(synchronously: true)
    }
    
    // MARK: - 编写自定义的图像处理操作
    func customFilter() {
        
        // 获取文件路径
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "Custom", ofType: "fsh")!)
        
        var customFilter: BasicOperation
        
        do {
            // 从文件中创建自定义滤镜
            customFilter = try BasicOperation(fragmentShaderFile: url)
        } catch {
            
            print(error)
            return
        }
        
        // 进行滤镜处理
        imageView.image = imageView.image!.filterWithOperation(customFilter)
    }
    
    // MARK: - 操作组
    func operationGroup() {
        
        // 创建一个BrightnessAdjustment颜色处理滤镜
        let brightnessAdjustment = BrightnessAdjustment()
        brightnessAdjustment.brightness = 0.2
        
        // 创建一个ExposureAdjustment颜色处理滤镜
        let exposureAdjustment = ExposureAdjustment()
        exposureAdjustment.exposure = 0.5
        
        // 创建一个操作组
        let operationGroup = OperationGroup()
        
        // 给闭包赋值，绑定处理链
        operationGroup.configureGroup{input, output in
            input --> brightnessAdjustment --> exposureAdjustment --> output
        }
        
        // 进行滤镜处理
        imageView.image = imageView.image!.filterWithOperation(operationGroup)
    }
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if (self.imageOrientation == .up) {
            return self
        }
        var transform = CGAffineTransform.identity
        switch (self.imageOrientation) {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            break
        default:
            break
        }
        switch (self.imageOrientation) {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        default:
            break
        }
        
        let bitsPerComponent = self.cgImage!.bitsPerComponent
        let bytesPerRow = self.cgImage!.bytesPerRow
        let space = self.cgImage!.colorSpace!
        let bitmapInfo = self.cgImage!.bitmapInfo
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: space, bitmapInfo: bitmapInfo.rawValue)
        
//        let ctx = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height),
//                                       AVAudioBitRateStrategy_Constant, 0,
//                                        CGImageGetColorSpace(self.CGImage),
//                                        CGImageGetBitmapInfo(self.CGImage).rawValue)
        ctx!.concatenate(transform)
        switch (self.imageOrientation) {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
//            CGContextDrawImage(ctx, CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height), self.cgImage!)
//            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage)
            break
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
//            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage)
            break
        }
        // And now we just create a new UIImage from the drawing context
        let cgimg = ctx!.makeImage()
        return UIImage(cgImage: cgimg!)
    }
}

*/
