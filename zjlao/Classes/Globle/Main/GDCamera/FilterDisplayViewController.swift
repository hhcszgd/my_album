import UIKit
//import GPUImage
import AVFoundation

//let blendImageName = "WID-small.jpg"
let blendImageName = "accountBiiMap.png"

protocol GDFilterCameraDelegate : NSObjectProtocol{
    func capturedImage(image:UIImage)
    func capturedVideo(video:Data)

}

enum GDCameraType {
    case photo
    case video
}

class FilterDisplayViewController: UIViewController, UISplitViewControllerDelegate {
    
    var time : Timer?
    var timeInterval : Int = 12
    
    var  write : GPUImageMovieWriter?
    var videoPath : URL?
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: SCREENWIDTH + 64, width: UIScreen.main.bounds.width, height: SCREENHEIGHT -  SCREENWIDTH - 64 * 2 - 20  ))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.purple
        return imageView
    }()
    var camera : GPUImageVideoCamera = GPUImageVideoCamera()
    var filterOperation: GPUImageFilter = GPUImageSepiaFilter()
    var beautifulFilter = GPUImageBeautifyFilter()
//    var filterSlider: UISlider?
    var filterView : GPUImageView = GPUImageView()
    let captureButton   =  UIButton.init(frame: CGRect(x: SCREENWIDTH/2 - 64/2, y: SCREENHEIGHT - 64, width: 64, height: 64))
    let cancleButton = UIButton.init(frame: CGRect(x: 0, y: SCREENHEIGHT - 64, width: 64, height: 64))
    let confirmButton = UIButton.init(frame: CGRect(x: SCREENWIDTH - 64, y: SCREENHEIGHT - 64, width: 64, height: 64))

    let flashButton = UIButton.init(frame: CGRect(x: 0, y: 20, width: 64, height: 64))
    let switchButton = UIButton.init(frame: CGRect(x: SCREENWIDTH - 64  , y: 20, width: 64, height: 64))
    
    var cameraType : GDCameraType = GDCameraType.photo{//默认
        willSet{
        
        }
        didSet{
        
        }
    }
    
    convenience init(type : GDCameraType ){
        self.init()
        if type == GDCameraType.video {
            cameraType = GDCameraType.video
            camera = GPUImageVideoCamera(sessionPreset: AVCaptureSession.Preset.vga640x480.rawValue, cameraPosition: AVCaptureDevice.Position.back)
            camera.outputImageOrientation = UIInterfaceOrientation.portrait
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCaptureButton()
        if cameraType == GDCameraType.photo {
            confirgureCapturePhoto()
        }else{
            confirgureRecordVideo()
        }
    }
    func confirgureCapturePhoto()  {
        self.configureCapturePhotoView()
        self.camera.outputImageOrientation = UIInterfaceOrientation.portrait
    }
    func configureCapturePhotoView() {
//        self.filterOperation = self.filters[0]
//        self.filterView.frame = CGRect(x: 0, y: 64, width: SCREENWIDTH, height: SCREENWIDTH)
//        self.view.addSubview(self.filterView)
//        camera.addTarget(filterOperation)
//        filterOperation.addTarget(self.filterView)
//        self.view.addSubview(self.imageView)
//        self.camera.startCapture()
        
        
        self.filterView.frame = CGRect(x: 0, y: 64, width: SCREENWIDTH, height: SCREENWIDTH)
        self.view.addSubview(self.filterView)
        camera.addTarget(beautifulFilter)
        beautifulFilter.addTarget(self.filterView)
        self.view.addSubview(self.imageView)
        self.camera.startCapture()
    }

    func setupCaptureButton()  {
        if self.captureButton.superview == nil  {
            
            self.view.addSubview(self.captureButton)
            self.captureButton.addTarget(self , action: #selector(captureButtonClick(sender:)), for: UIControlEvents.touchUpInside)
            if cameraType == GDCameraType.photo {
                self.captureButton.setTitle("拍照", for: UIControlState.normal)
            }else{
                self.captureButton.setTitle("录像", for: UIControlState.normal)
            }
        }
        if self.cancleButton.superview == nil {
            self.view.addSubview(self.cancleButton)
            self.cancleButton.addTarget(self , action: #selector(cancleButtonClick(sender:)), for: UIControlEvents.touchUpInside)
            self.cancleButton.setTitle("取消", for: UIControlState.normal)
        }
        if self.switchButton.superview == nil {
            self.view.addSubview(self.switchButton)
            self.switchButton.addTarget(self , action: #selector(switchCamera(sender:)), for: UIControlEvents.touchUpInside)
            self.flashButton.setTitle("后", for: UIControlState.normal)
            self.flashButton.setTitle("前", for: UIControlState.selected)
        }
        if self.flashButton.superview == nil {
            self.view.addSubview(self.flashButton)
            self.flashButton.setTitle("关", for: UIControlState.normal)
            self.flashButton.setTitle("开", for: UIControlState.selected)
            self.flashButton.addTarget(self , action: #selector(changeFlashMode(sender:)), for: UIControlEvents.touchUpInside)
        }
        if self.confirmButton.superview == nil {
            self.view.addSubview(self.confirmButton)
            self.confirmButton.addTarget(self , action: #selector(confirm(sender:)), for: UIControlEvents.touchUpInside)
        }
        
        self.captureButton.backgroundColor = UIColor.purple
        self.cancleButton.backgroundColor = UIColor.purple
        self.flashButton.backgroundColor = UIColor.purple
        self.confirmButton.backgroundColor = UIColor.purple
        self.switchButton.backgroundColor = UIColor.purple
    }
    
    func changeFilter(filter : GPUImageFilter?)  {
        self.camera.stopCapture()
        
        
        camera.removeTarget(self.filterOperation)
        self.filterOperation.removeTarget(self.filterView)
        
        if let filterReal  = filter {//有就设置
            self.filterOperation = filterReal
        }else{//没有就随机
            let indexOption = self.filters.index(of: self.filterOperation)
            if let index = indexOption {
                if index < self.filters.count - 1 {
                    self.filterOperation = self.filters[index + 1]
                }else{
                    self.filterOperation = self.filters[0]
                }
            }else{
                self.filterOperation = self.filters[0]
            }
            
        }
        
        mylog("滤镜类型:\(self.filterOperation.self)")

        
        camera.addTarget(self.filterOperation)
        self.filterOperation.addTarget(self.filterView)
        
        
        self.camera.startCapture()
    }
    
    @objc func confirm(sender:UIButton)  {
//        mylog("确定")
        self.changeFilter(filter: nil)
    }
    
    @objc func switchCamera(sender:UIButton) {
        mylog("切换相机")
        sender.isSelected = !sender.isSelected
        self.camera.rotateCamera()
        self.camera.horizontallyMirrorFrontFacingCamera = true
        if self.camera.cameraPosition() == AVCaptureDevice.Position.front {
            self.flashButton.isHidden = true
        }else{
            self.flashButton.isHidden = false
        }
//        self.camera.outputImageOrientation = UIInterfaceOrientation.portrait

    }
    @objc func changeFlashMode(sender:UIButton)  {
        if self.camera.cameraPosition() == AVCaptureDevice.Position.front {  return }
        do{
          try  self.camera.inputCamera.lockForConfiguration()
                sender.isSelected = !sender.isSelected
            let value : AVCaptureDevice.TorchMode = sender.isSelected ? AVCaptureDevice.TorchMode.on : AVCaptureDevice.TorchMode.off
                self.camera.inputCamera.torchMode = value
                self.camera.inputCamera.unlockForConfiguration()
       
        }catch{
            GDAlertView.alert("打开闪光灯失败", image: nil, time: 2, complateBlock: {})
            mylog("打开闪光灯失败:\(error)")
        }
        
        mylog("闪光灯设置")
    }
    
    @objc func cancleButtonClick(sender:UIButton)  {
        mylog("取消")
        self.dismiss(animated: true) {
        }
    }
    @objc func captureButtonClick(sender:UIButton) {
        
        if cameraType == GDCameraType.photo {
             performCapturePhoto()

        }else{
            performCaptureVideo()

        }
        
    }
    // MARK: 注释 : 执行拍照
    func performCapturePhoto()  {
        mylog("执行拍照")
        //        self.camera.outputImageOrientation = UIInterfaceOrientation.portrait
        guard let outputPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        let originalPath = outputPath + "/originalImage.png"
        //        print("path: \(originalPath)")
        _ = URL(fileURLWithPath: originalPath)
        
        let filteredPath = outputPath + "/filteredImage.png"
        //        print("path: \(filteredPath)")
        _ = URL(fileURLWithPath: filteredPath)
        self.filterOperation.useNextFrameForImageCapture()
        self.camera.useNextFrameForImageCapture()
        //        self.camera.capturePhotoAsPNGProcessedUp(toFilter: self.filterOperation , with: UIImageOrientation.up) { (data , error ) in
        //            let image = UIImage.init(data: data!)
        //
        //            self.imageView.image = image
        //            mylog(data)
        //        }
        if let cameraStill = camera as? GPUImageStillCamera {
            
            cameraStill.capturePhotoAsPNGProcessedUp(toFilter: self.beautifulFilter , with: UIImageOrientation.up) { (data , error ) in
                let image = UIImage.init(data: data!)
                let editImageData = UIImageJPEGRepresentation(image ?? UIImage(), 0.0)
                UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
                self.imageView.image = self.cropToBounds(image: UIImage(data: editImageData ?? Data())!, width: 1200, height: 1200)
                mylog("原图:\(String(describing: data))   压缩图:\(String(describing: editImageData)) 线程:\(Thread.current)")
            }
        }

    }

    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x:posX, y:posY, width:cgwidth, height:cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        return image
    }
    
    lazy var filters : [GPUImageFilter] = {
        var tempFilters = [GPUImageFilter]()
        
        let sepia = GPUImageSepiaFilter()//怀旧
        tempFilters.append(sepia)
        
        let grayScale  = GPUImageGrayscaleFilter()//灰度
        tempFilters.append(grayScale)
        
        let  glassSphere = GPUImageGlassSphereFilter()//水晶球效果
        tempFilters.append(glassSphere)
        
        let stretchDistortion = GPUImageStretchDistortionFilter()//哈哈镜
        tempFilters.append(stretchDistortion)
        /////////////
        let Brightness = GPUImageBrightnessFilter()//亮度
        tempFilters.append(Brightness)

        
        let Exposure = GPUImageExposureFilter()//曝光
        tempFilters.append(Exposure)

        
        let Contrast = GPUImageContrastFilter()//对比度
        tempFilters.append(Contrast)

        
        let Saturation = GPUImageSaturationFilter()//饱和度
        tempFilters.append(Saturation)

        
        let Gamma = GPUImageGammaFilter()//伽马线
        tempFilters.append(Gamma)

        let ColorInvert = GPUImageColorInvertFilter()//反色
        tempFilters.append(ColorInvert)

        
        let Levels = GPUImageLevelsFilter()//色阶
        tempFilters.append(Levels)

        let HistogramGenerator = GPUImageHistogramGenerator()//色彩直方图
        tempFilters.append(HistogramGenerator)

        
        let RGB = GPUImageRGBFilter()//rgb
        tempFilters.append(RGB)

        
        let ToneCurve = GPUImageToneCurveFilter()//色调曲线
        tempFilters.append(ToneCurve)

        
        let Monochrome = GPUImageMonochromeFilter()//单色
        tempFilters.append(Monochrome)

        
        let Opacity = GPUImageOpacityFilter()//不透明度
        tempFilters.append(Opacity)
        //////
        
        let HighlightShadow = GPUImageHighlightShadowFilter()//提亮阴影
        tempFilters.append(HighlightShadow)
        
        let FalseColor = GPUImageFalseColorFilter()//色彩替换（替换亮部和暗部色彩）
        tempFilters.append(FalseColor)
        
        let Hue = GPUImageHueFilter()//色度
        tempFilters.append(Hue)
        
        let ChromaKey = GPUImageChromaKeyFilter()//色度键
        tempFilters.append(ChromaKey)
        
        let WhiteBalance = GPUImageWhiteBalanceFilter()//白平衡
        tempFilters.append(WhiteBalance)
        
        let AverageColor = GPUImageAverageColor()//像素平均色值
        tempFilters.append(AverageColor)
        
        let SolidColor = GPUImageSolidColorGenerator()//纯色
        tempFilters.append(SolidColor)
        
        let Luminosity = GPUImageLuminosity()//亮度平均
        tempFilters.append(Luminosity)
        
//        let AverageLuminance = GPUImageAverageLuminanceThresholdFilter()//像素色值亮度平均，图像黑白
//        tempFilters.append(AverageLuminance)
        
        let Lookup = GPUImageLookupFilter()//lookup 色彩调整
        tempFilters.append(Lookup)
        
//        let Amatorka = GPUImageAmatorkaFilter()//Amatorka lookup
//        tempFilters.append(Amatorka)

        
        let Crosshair = GPUImageCrosshairGenerator()//十字
        tempFilters.append(Crosshair)
        
        let Line = GPUImageLineGenerator()//线条
        tempFilters.append(Line)
        
        let Transform = GPUImageTransformFilter()//形状变化
        tempFilters.append(Transform)
        
        let Crop = GPUImageCropFilter()//剪裁/////43535676475786809879087
        tempFilters.append(Crop)
        
        let Sharpen = GPUImageSharpenFilter()//锐化
        tempFilters.append(Sharpen)
        
//        let UnsharpMask = GPUImageUnsharpMaskFilter()//反遮罩锐化
//        tempFilters.append(UnsharpMask)
        
//        let FastBlur = GPUImageFastBlurFilter()//模糊
//        tempFilters.append(FastBlur)
        
        let GaussianBlur = GPUImageGaussianBlurFilter()//高斯模糊
        tempFilters.append(GaussianBlur)
        
//        let GaussianSelectiveBlur = GPUImageGaussianSelectiveBlurFilter()//高斯模糊，选择部分清晰
//        tempFilters.append(GaussianSelectiveBlur)
        
        let BoxBlur = GPUImageBoxBlurFilter()//盒状模糊
        tempFilters.append(BoxBlur)
        
//        let TiltShift = GPUImageTiltShiftFilter()//条纹模糊，中间清晰，上下两端模糊
//        tempFilters.append(TiltShift)
        
        
        
        let Median = GPUImageMedianFilter()//中间值，有种稍微模糊边缘的效果
        tempFilters.append(Median)
        
        
        
        let Bilateral = GPUImageBilateralFilter()//双边模糊
        tempFilters.append(Bilateral)
        
        
        
        let Erosion = GPUImageErosionFilter()//侵蚀边缘模糊，变黑白
        tempFilters.append(Erosion)
        
        
        
        let RGBErosion = GPUImageRGBErosionFilter()//RGB侵蚀边缘模糊，有色彩
        tempFilters.append(RGBErosion)
        
        
        
        let Dilation = GPUImageDilationFilter()//扩展边缘模糊，变黑白
        tempFilters.append(Dilation)
        
        
        
        let RGBDilation = GPUImageRGBDilationFilter()//RGB扩展边缘模糊，有色彩
        tempFilters.append(RGBDilation)
        
        
        
//        let Opening = GPUImageOpeningFilter()//黑白色调模糊
//        tempFilters.append(Opening)
        
        
        
//        let RGBOpening = GPUImageRGBOpeningFilter()//彩色模糊
//        tempFilters.append(RGBOpening)
        
        
        
//        let Closing = GPUImageClosingFilter()//黑白色调模糊，暗色会被提亮
//        tempFilters.append(Closing)
        
        
        
//        let RGBClosing = GPUImageRGBClosingFilter()//彩色模糊，暗色会被提亮
//        tempFilters.append(RGBClosing)
        
        
        
        let LanczosResampling = GPUImageLanczosResamplingFilter()//Lanczos重取样，模糊效果
        tempFilters.append(LanczosResampling)
        
        
        
        let NonMaximumSuppression = GPUImageNonMaximumSuppressionFilter()//非最大抑制，只显示亮度最高的像素，其他为黑
        tempFilters.append(NonMaximumSuppression)
        
        
        
        let SobelEdgeDetection = GPUImageSobelEdgeDetectionFilter()//Sobel边缘检测算法(白边，黑内容，有点漫画的反色效果)
        tempFilters.append(SobelEdgeDetection)
        
        
        
//        let CannyEdgeDetection = GPUImageCannyEdgeDetectionFilter()//Canny边缘检测算法（比上更强烈的黑白对比度）
//        tempFilters.append(CannyEdgeDetection)
        
        
        
        let ThresholdEdgeDetection = GPUImageThresholdEdgeDetectionFilter()//阈值边缘检测（效果与上差别不大）
        tempFilters.append(ThresholdEdgeDetection)
        
        
        
        let PrewittEdgeDetection = GPUImagePrewittEdgeDetectionFilter()//普瑞维特(Prewitt)边缘检测(效果与Sobel差不多，貌似更平滑)
        tempFilters.append(PrewittEdgeDetection)
        
        
        
        let XYDerivative = GPUImageXYDerivativeFilter()//XYDerivative边缘检测，画面以蓝色为主，绿色为边缘，带彩色
        tempFilters.append(XYDerivative)
        
        
        
//        let HarrisCornerDetection = GPUImageHarrisCornerDetectionFilter()//Harris角点检测，会有绿色小十字显示在图片角点处
//        tempFilters.append(HarrisCornerDetection)
        
        
        
//        let NobleCornerDetection = GPUImageNobleCornerDetectionFilter()      //Noble角点检测，检测点更多
//        tempFilters.append(NobleCornerDetection)
        
        
        
//        let ShiTomasiFeatureDetection = GPUImageShiTomasiFeatureDetectionFilter()//ShiTomasi角点检测，与上差别不大
//        tempFilters.append(ShiTomasiFeatureDetection)
        
        
        
//        let MotionDetector = GPUImageMotionDetector()//动作检测
//        tempFilters.append(MotionDetector)
        
        
        
//        let HoughTransformLine = GPUImageHoughTransformLineDetector()      //线条检测
//        tempFilters.append(HoughTransformLine)
        
        
        
        let ParallelCoordinateLineTransform = GPUImageParallelCoordinateLineTransformFilter() //平行线检测
        tempFilters.append(ParallelCoordinateLineTransform)
        
        
        
        let LocalBinaryPattern = GPUImageLocalBinaryPatternFilter()       //图像黑白化，并有大量噪点
        tempFilters.append(LocalBinaryPattern)
        
        
        
//        let LowPass = GPUImageLowPassFilter()                 //用于图像加亮
//        tempFilters.append(LowPass)
        
        
        
        
//        let HighPass = GPUImageHighPassFilter()                 //图像低于某值时显示为黑
//        tempFilters.append(HighPass)
        
        ////视觉效果 Visual Effect////
        
        let Sketch = GPUImageSketchFilter()                    //素描
        tempFilters.append(Sketch)
        
        
        
        let ThresholdSketch =  GPUImageThresholdSketchFilter()           //阀值素描，形成有噪点的素描
        tempFilters.append(ThresholdSketch)
        
        
        
        let Toon = GPUImageToonFilter()                      //卡通效果（黑色粗线描边）
        tempFilters.append(Toon)
        
        
        
//        let SmoothToon = GPUImageSmoothToonFilter()                //相比上面的效果更细腻，上面是粗旷的画风
//        tempFilters.append(SmoothToon)
        
        
        
        let Kuwahara = GPUImageKuwaharaFilter()                  //桑原(Kuwahara)滤波,水粉画的模糊效果；处理时间比较长，慎用
        tempFilters.append(Kuwahara)
        
        
        
        let Mosaic = GPUImageMosaicFilter()                    //黑白马赛克
        tempFilters.append(Mosaic)
        
        
        
        
        
        let Pixellate = GPUImagePixellateFilter()                 //像素化
        tempFilters.append(Pixellate)
        
        
        
        let PolarPixellate = GPUImagePolarPixellateFilter()            //同心圆像素化
        tempFilters.append(PolarPixellate)
        
        
        
        let Crosshatch = GPUImageCrosshatchFilter()                //交叉线阴影，形成黑白网状画面
        tempFilters.append(Crosshatch)
        
        
        
        let ColorPacking = GPUImageColorPackingFilter()              //色彩丢失，模糊（类似监控摄像效果）
        tempFilters.append(ColorPacking)
        
        
        
        let Vignette = GPUImageVignetteFilter()                  //晕影，形成黑色圆形边缘，突出中间图像的效果
        tempFilters.append(Vignette)
        
        
        
        let Swirl = GPUImageSwirlFilter()                     //漩涡，中间形成卷曲的画面
        tempFilters.append(Swirl)
        
        
        
        let BulgeDistortion = GPUImageBulgeDistortionFilter()           //凸起失真，鱼眼效果
        tempFilters.append(BulgeDistortion)
        
        
        
        
        
        let PinchDistortion = GPUImagePinchDistortionFilter()           //收缩失真，凹面镜
        tempFilters.append(PinchDistortion)
        
        
        
        let SphereRefraction = GPUImageSphereRefractionFilter()          //球形折射，图形倒立
        tempFilters.append(SphereRefraction)
        
        
        
        let Posterize = GPUImagePosterizeFilter()                 //色调分离，形成噪点效果
        tempFilters.append(Posterize)
        
        
        
        let CGAColorspace = GPUImageCGAColorspaceFilter()             //CGA色彩滤镜，形成黑、浅蓝、紫色块的画面
        tempFilters.append(CGAColorspace)
        
        
        
        let PerlinNoise = GPUImagePerlinNoiseFilter()               //柏林噪点，花边噪点
        tempFilters.append(PerlinNoise)
        
        
        
        let Convolution = GPUImage3x3ConvolutionFilter()            //3x3卷积，高亮大色块变黑，加亮边缘、线条等
        tempFilters.append(Convolution)
        
        
        
        let Emboss = GPUImageEmbossFilter()                    //浮雕效果，带有点3d的感觉
        tempFilters.append(Emboss)
        
        
        
        
        
        let PolkaDot = GPUImagePolkaDotFilter()                  //像素圆点花样
        tempFilters.append(PolkaDot)
        
        /////混合模式 Blend////
        
//        let Halftone = GPUImageHalftoneFilter()                  //点染,图像黑白化，由黑点构成原图的大致图形
//        tempFilters.append(Halftone)
        
        
        
//        let MultiplyBlend = GPUImageMultiplyBlendFilter()           //通常用于创建阴影和深度效果
//        tempFilters.append(MultiplyBlend)
        
        
        
        let NormalBlend = GPUImageNormalBlendFilter()               //正常
        tempFilters.append(NormalBlend)
        
        
        
        let AlphaBlend = GPUImageAlphaBlendFilter()                //透明混合,通常用于在背景上应用前景的透明度
        tempFilters.append(AlphaBlend)
        
        
        
        let DissolveBlend = GPUImageDissolveBlendFilter()             //溶解
        tempFilters.append(DissolveBlend)
        
        
        
        let OverlayBlend = GPUImageOverlayBlendFilter()              //叠加,通常用于创建阴影效果
        tempFilters.append(OverlayBlend)
        
        
        
        
        
        let DarkenBlend = GPUImageDarkenBlendFilter()               //加深混合,通常用于重叠类型
        tempFilters.append(DarkenBlend)
        
        
        
        let LightenBlend =  GPUImageLightenBlendFilter()              //减淡混合,通常用于重叠类型
        tempFilters.append(LightenBlend)
        
        
        
        let SourceOverBlend =  GPUImageSourceOverBlendFilter()           //源混合
        tempFilters.append(SourceOverBlend)
        
        
        
        let ColorBurnBlend = GPUImageColorBurnBlendFilter()            //色彩加深混合
        tempFilters.append(ColorBurnBlend)
        
        
        
        let ColorDodgeBlend =  GPUImageColorDodgeBlendFilter()           //色彩减淡混合
        tempFilters.append(ColorDodgeBlend)
        
        
        
        let ScreenBlend =  GPUImageScreenBlendFilter()               //屏幕包裹,通常用于创建亮点和镜头眩光
        tempFilters.append(ScreenBlend)
        
        
        
        let DifferenceBlend =  GPUImageDifferenceBlendFilter()           //差异混合,通常用于创建更多变动的颜色
        tempFilters.append(DifferenceBlend)
        
        
        
        
        
        let SubtractBlend =  GPUImageSubtractBlendFilter()             //差值混合,通常用于创建两个图像之间的动画变暗模糊效果
        tempFilters.append(SubtractBlend)
        
        
        
        
        
        let HardLightBlend =  GPUImageHardLightBlendFilter()            //强光混合,通常用于创建阴影效果
        tempFilters.append(HardLightBlend)
        
        
        
        
        
        let SoftLightBlend =  GPUImageSoftLightBlendFilter()            //柔光混合
        tempFilters.append(SoftLightBlend)
        
        
        
        
        
        let ChromaKeyBlend =  GPUImageChromaKeyBlendFilter()            //色度键混合
        tempFilters.append(ChromaKeyBlend)
        
        
        
        
        let Mask = GPUImageMaskFilter()                      //遮罩混合
        tempFilters.append(Mask)
        
        
        
        
        
        let Haze =  GPUImageHazeFilter()                      //朦胧加暗
        tempFilters.append(Haze)
        
        
        
        
        
        let LuminanceThreshold =  GPUImageLuminanceThresholdFilter()        //亮度阈
        tempFilters.append(LuminanceThreshold)
        
        
        
        
        
//        let AdaptiveThreshold =  GPUImageAdaptiveThresholdFilter()         //自适应阈值
//        tempFilters.append(AdaptiveThreshold)
        
        
        
        
        
        let AddBlend =  GPUImageAddBlendFilter()                  //通常用于创建两个图像之间的动画变亮模糊效果
        tempFilters.append(AddBlend)
        
        
        
        let DivideBlend =  GPUImageDivideBlendFilter()              //通常用于创建两个图像之间的动画变暗模糊效果
        tempFilters.append(DivideBlend)
        
    
        
        return tempFilters
    }()
    deinit {
        mylog("滤镜控制器销毁")
    }
}


// MARK: 注释 : 设置录像机
import Photos
extension FilterDisplayViewController{
    func performCaptureVideo()  {
        
//        let pp = NSTemporaryDirectory().appending("movie.mp4")
        let pp = NSHomeDirectory().appending("Documents/Movie.m4v")

        //        unlink(&pp.utf8)
        let  willSaveUrl = URL(fileURLWithPath: pp)
        videoPath = willSaveUrl
        write = GPUImageMovieWriter(movieURL: willSaveUrl, size: CGSize.init(width: 480, height: 640))
        write?.encodingLiveVideo = true
        write?.shouldPassthroughAudio = true
        write?.hasAudioTrack = true
//        beautifulFilter.addTarget(write)
//        beautifulFilter.addTarget(filterView)
//        write?.finishRecording(completionHandler: {
//            mylog("录制完毕")
//        })
        write?.completionBlock = {
            mylog("录制完毕")
        }
        if let writeReal = write {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                mylog("开始录制")
//                self.camera.audioEncodingTarget = writeReal
                writeReal.startRecording()
                
                self.addTimer()
            }
        }
    }
    
    
    
    

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
            time = Timer.init(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil , repeats: true)
            RunLoop.main.add(time!, forMode: RunLoopMode.commonModes)
        }
        
    }
    
    @objc func countDown() {
        self.timeInterval -= 1
        if self.timeInterval <= 0  {
            self.timeInterval = 12
            self.deleteTimer()
            self.stopRecordVideo()
        }else{
            mylog("时间流逝\(timeInterval)")
            
        }
    }
    
    
    
    
    
    
    
    
    func stopRecordVideo()  {
        beautifulFilter.removeTarget(write)
        camera.audioEncodingTarget = nil
        write?.finishRecording()
        camera.stopCapture()
        UISaveVideoAtPathToSavedPhotosAlbum(self.videoPath?.absoluteString ?? "",  nil, nil , nil )
        PHPhotoLibrary.shared().performChanges({
            if let path = self.videoPath {
                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: path)
            }
        }) { (bool, error ) in
            mylog("保存失败")
        }
    }
    func confirgureRecordVideo()  {//1
        configureCaptureVideoView()
        
        camera.addAudioInputsAndOutputs()
        camera.addTarget(beautifulFilter)
      
    }
    
    
    func configureCaptureVideoView() {

        
        self.filterView.frame = CGRect(x: 0, y: 64, width: SCREENWIDTH, height: SCREENWIDTH)
        self.view.addSubview(self.filterView)
        self.filterView.fillMode = GPUImageFillModeType.preserveAspectRatioAndFill// kGPUImageFillModePreserveAspectRatioAndFill
        camera.addTarget(beautifulFilter)
        beautifulFilter.addTarget(self.filterView)
//        self.view.addSubview(self.imageView)
        self.camera.startCapture()
    }

}

/*import UIKit
import GPUImage
import AVFoundation

//let blendImageName = "WID-small.jpg"
let blendImageName = "accountBiiMap.png"


class FilterDisplayViewController: UIViewController, UISplitViewControllerDelegate {

    var filterOperation: FilterOperationInterface?
    var filterSlider: UISlider?
     var filterView: RenderView?
    let captureButton   =  UIButton.init(frame: CGRect(x: SCREENWIDTH/2 - 64/2, y: SCREENHEIGHT - 64, width: 64, height: 64))
    let cancleButton = UIButton.init(frame: CGRect(x: SCREENWIDTH/2 - 64/2  + 88, y: SCREENHEIGHT - 64, width: 64, height: 64))
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 300 ))
//        imageView.image = UIImage(named: "icon_wechatpay")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.purple
        return imageView
    }()
    var videoCamera:Camera?
    var blendImage:PictureInput?

    var imageOutput : PictureOutput?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.resetFilter(filter: nil)
        self.switchCamera()
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        do {
            videoCamera = try Camera(sessionPreset:AVCaptureSessionPreset640x480, location:.backFacing)
            videoCamera!.runBenchmark = true
        } catch {
            videoCamera = nil
            print("Couldn't initialize camera with error: \(error)")
        }
        let filterSlider : UISlider = UISlider.init(frame: CGRect(x: 0, y: SCREENHEIGHT-44, width: 100, height: 44))
        let filterView : RenderView = RenderView.init(frame: CGRect(x: 0, y: 100, width: 100, height: 100))
        self.filterView = filterView
        self.filterSlider = filterSlider
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder)
    {
        do {
            videoCamera = try Camera(sessionPreset:AVCaptureSessionPreset640x480, location:.backFacing)
            videoCamera!.runBenchmark = true
            videoCamera?.logFPS = true
        } catch {
            videoCamera = nil
            print("Couldn't initialize camera with error: \(error)")
        }
        let filterSlider : UISlider = UISlider.init()
        let filterView : RenderView = RenderView.init(frame: CGRect(x: 0, y: 100, width: 100, height: 100))
        self.filterView = filterView
        self.filterSlider = filterSlider
        super.init(coder: aDecoder)!
    }
    
    
    func configureView() {
        guard let videoCamera = videoCamera else {
            let errorAlertController = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: "Couldn't initialize camera", preferredStyle: .alert)
            errorAlertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
            self.present(errorAlertController, animated: true, completion: nil)
            return
        }
        if let currentFilterConfiguration = self.filterOperation {
            self.title = currentFilterConfiguration.titleName
            
            // Configure the filter chain, ending with the view
            if let view = self.filterView {
                switch currentFilterConfiguration.filterOperationType {
                case .singleInput:
                    videoCamera.addTarget(currentFilterConfiguration.filter)
                    currentFilterConfiguration.filter.addTarget(view)
                case .blend:
                    videoCamera.addTarget(currentFilterConfiguration.filter)
                    self.blendImage = PictureInput(imageName:blendImageName)
                    self.blendImage?.addTarget(currentFilterConfiguration.filter)
                    self.blendImage?.processImage()
                    currentFilterConfiguration.filter.addTarget(view)
                case let .custom(filterSetupFunction:setupFunction):
                    currentFilterConfiguration.configureCustomFilter(setupFunction(videoCamera, currentFilterConfiguration.filter, view))
                }
                
                videoCamera.startCapture()
                
            }

            // Hide or display the slider, based on whether the filter needs it
            if let slider = self.filterSlider {
                switch currentFilterConfiguration.sliderConfiguration {
                case .disabled:
                    slider.isHidden = true
//                case let .Enabled(minimumValue, initialValue, maximumValue, filterSliderCallback):
                case let .enabled(minimumValue, maximumValue, initialValue):
                    slider.minimumValue = minimumValue
                    slider.maximumValue = maximumValue
                    slider.value = initialValue
                    slider.isHidden = false
                    self.updateSliderValue()
                }
            }
            
        }
    }
    
     func updateSliderValue() {
        if let currentFilterConfiguration = self.filterOperation {
            switch (currentFilterConfiguration.sliderConfiguration) {
                case .enabled(_, _, _): currentFilterConfiguration.updateBasedOnSliderValue(Float(self.filterSlider!.value))
                case .disabled: break
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.filterSlider?.addTarget(self, action: #selector(updateSliderValue), for: UIControlEvents.valueChanged)
        self.view.addSubview(self.filterView!)
        self.view.addSubview(self.filterSlider!)
        self.configureView()
        self.view.insertSubview(self.imageView, belowSubview: self.filterView!)
        self.setupCaptureButton()
    }
    func setupCaptureButton()  {
        if self.captureButton.superview == nil  {
            self.view.addSubview(self.captureButton)
            self.captureButton.addTarget(self , action: #selector(captureButtonClick), for: UIControlEvents.touchUpInside)
            
        }
        if self.cancleButton.superview == nil {
            self.view.addSubview(self.cancleButton)
            self.cancleButton.addTarget(self , action: #selector(cancleButtonClick), for: UIControlEvents.touchUpInside)
        }
        self.captureButton.backgroundColor = UIColor.purple
        self.cancleButton.backgroundColor = UIColor.purple
    }
    func cancleButtonClick()  {
        self.dismiss(animated: false) {
        }
    }
    func captureButtonClick() {
        // 延迟1s执行，防止截到黑屏
        guard let outputPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        
        let originalPath = outputPath + "/originalImage.png"
        print("path: \(originalPath)")
        let originalURL = URL(fileURLWithPath: originalPath)
        
        let filteredPath = outputPath + "/filteredImage.png"
        print("path: \(filteredPath)")
        let filteredlURL = URL(fileURLWithPath: filteredPath)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            
            // 保存相机捕捉到的图片
            self.videoCamera?.saveNextFrameToURL(originalURL, format: .png)
            
            // 保存滤镜后的图片
            self.filterOperation?.filter.saveNextFrameToURL(filteredlURL, format: .png)
            
            // 如果需要处理回调，有下面两种写法
            
            let dataOutput = PictureOutput()
            dataOutput.encodedImageFormat = .png
            dataOutput.encodedImageAvailableCallback = {imageData in
                // 这里的imageData是截取到的数据，Data类型
                print(imageData)
            }
            self.videoCamera! --> dataOutput
            
            let imageOutput = PictureOutput()
            self.imageOutput = imageOutput
            imageOutput.encodedImageFormat = .png
            imageOutput.imageAvailableCallback = {image in
                // 这里的image是截取到的数据，UIImage类型
                DispatchQueue.main.async {
                    let img = UIImage(contentsOfFile: filteredPath)//每次都从这里取 , 再存到别处,以时间戳命名,把名字和坐标存到数据库
                    self.imageView.image = img?.fixOrientation()//done
                    
//                    do{
//                        try FileManager.default.removeItem(atPath: filteredPath)
//                    }catch{
//                        mylog("图片删除失败")
//                    }
                }
                print(image)
            }
            self.videoCamera! --> imageOutput
        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        if let videoCamera = videoCamera {
            
            videoCamera.stopCapture()
            videoCamera.removeAllTargets()
            blendImage?.removeAllTargets()
        }
        
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func resetFilter(filter:FilterOperationInterface?)  {
        videoCamera?.stopCapture()
        videoCamera?.removeAllTargets()
        blendImage?.removeAllTargets()
        videoCamera = nil
        self.filterView = nil
        let filterView : RenderView = RenderView.init(frame: CGRect(x: 0, y: 100, width: 100, height: 100))
        self.filterView = filterView
        self.view.addSubview(filterView)
        self.filterOperation = FilterOperation( // TODO: Make this only partially applied to the view
            filter:{iOSBlur()},
            listName:"iOS 7 blur",
            titleName:"iOS 7 Blur",
            sliderConfiguration:.disabled,
            sliderUpdateCallback: nil,
            filterOperationType:.singleInput
        )
        do {
            videoCamera = try Camera(sessionPreset:AVCaptureSessionPreset640x480, location:.backFacing)
            videoCamera!.runBenchmark = true
        } catch {
            videoCamera = nil
            print("Couldn't initialize camera with error: \(error)")
        }

        
        
        
        
        guard let videoCamera = videoCamera else {
            let errorAlertController = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: "Couldn't initialize camera", preferredStyle: .alert)
            errorAlertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
            self.present(errorAlertController, animated: true, completion: nil)
            return
        }

        if let currentFilterConfiguration = self.filterOperation {
            self.title = currentFilterConfiguration.titleName
            
            // Configure the filter chain, ending with the view
            if let view = self.filterView {
                switch currentFilterConfiguration.filterOperationType {
                case .singleInput:
                    videoCamera.addTarget(currentFilterConfiguration.filter)
                    currentFilterConfiguration.filter.addTarget(view)
                case .blend:
                    videoCamera.addTarget(currentFilterConfiguration.filter)
                    self.blendImage = PictureInput(imageName:blendImageName)
                    self.blendImage?.addTarget(currentFilterConfiguration.filter)
                    self.blendImage?.processImage()
                    currentFilterConfiguration.filter.addTarget(view)
                case let .custom(filterSetupFunction:setupFunction):
                    currentFilterConfiguration.configureCustomFilter(setupFunction(videoCamera, currentFilterConfiguration.filter, view))
                }
                
                videoCamera.startCapture()
                
            }
        }
    }
    func switchCamera() {
        videoCamera?.stopCapture()
        videoCamera?.removeAllTargets()
        blendImage?.removeAllTargets()
        videoCamera = nil
        self.filterView = nil
        let filterView : RenderView = RenderView.init(frame: CGRect(x: 0, y: 100, width: 100, height: 100))
        /**
         case portrait
         case portraitUpsideDown
         case landscapeLeft
         case landscapeRight
         */
        
        filterView.orientation = .portrait
        
        self.filterView = filterView
        self.view.addSubview(filterView)
        self.filterOperation = FilterOperation(
            filter:{WhiteBalance()},
            listName:"White balance",
            titleName:"White Balance",
            sliderConfiguration:.enabled(minimumValue:2500.0, maximumValue:7500.0, initialValue:5000.0),
            sliderUpdateCallback: {(filter, sliderValue) in
                filter.temperature = sliderValue
        },
            filterOperationType:.singleInput
        )
        
        do {
            videoCamera = try Camera(sessionPreset:AVCaptureSessionPreset640x480, location:.frontFacing )
            
            videoCamera!.runBenchmark = true

        } catch {
            videoCamera = nil
            print("Couldn't initialize camera with error: \(error)")
        }
        
        
        
        
        
        guard let videoCamera = videoCamera else {
            let errorAlertController = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: "Couldn't initialize camera", preferredStyle: .alert)
            errorAlertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
            self.present(errorAlertController, animated: true, completion: nil)
            return
        }
        
        if let currentFilterConfiguration = self.filterOperation {
            self.title = currentFilterConfiguration.titleName
            
            // Configure the filter chain, ending with the view
            if let view = self.filterView {
                switch currentFilterConfiguration.filterOperationType {
                case .singleInput:
                    videoCamera.addTarget(currentFilterConfiguration.filter)
                    currentFilterConfiguration.filter.addTarget(view)
                case .blend:
                    videoCamera.addTarget(currentFilterConfiguration.filter)
                    self.blendImage = PictureInput(imageName:blendImageName)
                    self.blendImage?.addTarget(currentFilterConfiguration.filter)
                    self.blendImage?.processImage()
                    currentFilterConfiguration.filter.addTarget(view)
                case let .custom(filterSetupFunction:setupFunction):
                    currentFilterConfiguration.configureCustomFilter(setupFunction(videoCamera, currentFilterConfiguration.filter, view))
                }
                
                videoCamera.startCapture()
                
            }
        }
    }
    deinit {
        mylog("滤镜控制器销毁")
    }
}

*/
