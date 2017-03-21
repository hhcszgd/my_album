//
//  GDTestWebVC.swift
//  zjlao
//
//  Created by WY on 17/1/13.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//



import UIKit
import WebKit
class GDTestWebVC: GDNormalVC ,  WKNavigationDelegate,WKUIDelegate {

    let webView : WKWebView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration.init())
   // let html = "<html><head></head><body><p style=\"text-align:center ; font-size:44px ; font-family:'arial'\">萨沙讲史堂第一百五十四期（军事系列第81讲）</p>   <img style=\"center\" , src=\"http://d.ifengimg.com/mw640_q75/p0.ifengimg.com/pmop/2016/1226/F19FC9FA3A476FA3FDEF86D6A4EC301E7BE1B258_size12_w640_h355.jpeg\" />  </body></html>"
    
        let html = "<html><head></head><body><p style=\"text-align:center ; font-size:44px ; font-family:'arial'\">萨沙讲史堂第一百五十四期（军事系列第81讲）</p>   <img style=\"center\" , src=\"http://d.ifengimg.com/mw640_q75/p0.ifengimg.com/pmop/2016/1226/F19FC9FA3A476FA3FDEF86D6A4EC301E7BE1B258_size12_w640_h355.jpeg\" />  </body></html>"
    func test() -> String {
        
        gotResourceInSubBundle("mg", type: "gif", directory: "face_img")
        //let path =  gotResourceInSubBundle("icon_payfail@3x", type: "png", directory: "Image")
        
        let path =  Bundle.main.path(forResource: "loading", ofType: "gif")
         let subBundlePath = Bundle.main.path(forResource: "Resource", ofType: "bundle")
         let subBundle = Bundle(path: subBundlePath!)!
         subBundle.bundlePath

        
        mylog(path)
        //let ss  = String.init(format: "<html><head></head><body><p style=\"text-align:center ; font-size:44px ; font-family:'arial'\">萨沙讲史堂第一百五十四期（军事系列第81讲）</p>   <img href=\"center\" , src=\"file://%@\" />  </body></html>", path!)
             //   let ss  = String.init(format: "<html><head></head><body><p style=\"text-align:center ; font-size:44px ; font-family:'arial'\">萨沙讲史堂第一百五十四期（军事系列第81讲）</p>   <img src=\"file://%@\" />  </body></html>", path!)
        let ss = "<html><body style=\"margin: 0px\"> <p style=\"text-align:center ; font-size:44px ; font-family:'arial'\">萨沙讲史堂第一百五十四期（军事系列第81讲）</p>  <img style=\"-webkit-user-select:none; display:block; margin:auto;\" src=\"loading.gif  \"   width=\"111\" height=\"111\"></body></html>"
        mylog(ss)
        return ss
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        mylog("\(self.keyModel)")
        self.view.addSubview(self.webView)
        self.layoutsubviews()
        test()
        // Do any additional setup after loading the view.
    }
    
    
    func layoutsubviews() {
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.webView.configuration.preferences.javaScriptEnabled = true
//        self.webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
       /* //        self.webView.allowsBackForwardNavigationGestures = true //会出现不愿看到的返回列表
        //- (void)addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name;*/
//        self.webView.configuration.userContentController.add(self , name : "zjlao")//传值的关键 , 释放的时候记得移除
        
        
        
        self.webView.frame = CGRect(x: 0.0, y: NavigationBarHeight, width: GDDevice.width, height: GDDevice.height - NavigationBarHeight)
        //MARK:loadhtmlString 时 baseurl 写成图片所在的路径文件夹。img标签里写图片名字就可以了
        self.webView.loadHTMLString(test(), baseURL: URL.init(fileURLWithPath: Bundle.main.bundlePath) )
//        guard let model = self.keyModel else {
//            mylog("webViewController的关键模型为nil\(self.keyModel)")
//            return
//        }
//        guard let keyParamete = model.keyparamete else {
//            mylog("webViewController的模型关键参数为空\(self.keyModel)")
//            return
//        }
//        guard let urlStr = keyParamete as? String else {
//            mylog("webViewController对应的url字符串不存在\(self.keyModel)")
//            return
//        }
//        if let token = GDNetworkManager.shareManager.token {
//            
//            let urlStrAppendToken  = urlStr.appending("?token=\(token)")
//            mylog(urlStrAppendToken)
//            if  urlStrAppendToken.hasPrefix("https://") || urlStrAppendToken.hasPrefix("http://") {
//                guard let url  = URL.init(string: urlStrAppendToken ) else {
//                    mylog("webViewController的urlStr字符串转换成URL失败")
//                    return
//                }
//                
//                let urlRequest = URLRequest.init(url: url)
//                self.webView.load(urlRequest)
//                
//            }
//        }else{//拼接http://
//            
//        }
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
    
    
    
    
    
    //MARK:WKNavigationDelegate
    
    /*! @abstract Decides whether to allow or cancel a navigation.
     @param webView The web view invoking the delegate method.
     @param navigationAction Descriptive information about the action
     triggering the navigation request.
     @param decisionHandler The decision handler to call to allow or cancel the
     navigation. The argument is one of the constants of the enumerated type WKNavigationActionPolicy.
     @discussion If you do not implement this method, the web view will load the request or, if appropriate, forward it to another application.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void){
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    /*! @abstract Decides whether to allow or cancel a navigation after its
     response is known.
     @param webView The web view invoking the delegate method.
     @param navigationResponse Descriptive information about the navigation
     response.
     @param decisionHandler The decision handler to call to allow or cancel the
     navigation. The argument is one of the constants of the enumerated type WKNavigationResponsePolicy.
     @discussion If you do not implement this method, the web view will allow the response, if the web view can show it.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void){
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    
    
    /*! @abstract Invoked when a main frame navigation starts.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        
    }
    
    
    /*! @abstract Invoked when a server redirect is received for the main
     frame.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!){
        
    }
    
    
    /*! @abstract Invoked when an error occurs while starting to load data for
     the main frame.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @param error The error that occurred.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        
    }
    
    
    /*! @abstract Invoked when content starts arriving for the main frame.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        
    }
    
    
    /*! @abstract Invoked when a main frame navigation completes.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        self.attritNavTitle = NSAttributedString.init(string: webView.title ?? "")
        webView.alpha = 0
        UIView.animate(withDuration: 0.2) { 
            webView.alpha = 1
        }
        mylog(webView.title)
    }
    
    
    /*! @abstract Invoked when an error occurs during a committed main frame
     navigation.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @param error The error that occurred.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        self.attritNavTitle = NSAttributedString.init(string: webView.title ?? "")
        mylog(webView.title)
    }
    
    
    /*! @abstract Invoked when the web view needs to respond to an authentication challenge.
     @param webView The web view that received the authentication challenge.
     @param challenge The authentication challenge.
     @param completionHandler The completion handler you must invoke to respond to the challenge. The
     disposition argument is one of the constants of the enumerated type
     NSURLSessionAuthChallengeDisposition. When disposition is NSURLSessionAuthChallengeUseCredential,
     the credential argument is the credential to use, or nil to indicate continuing without a
     credential.
     @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void){
        completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling , nil )
    }
    
    
    /*! @abstract Invoked when the web view's web content process is terminated.
     @param webView The web view whose underlying web content process was terminated.
     @available(iOS 9.0, *)
     */
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView){
        
    }
    
    //MARK: WKUIDelegate
    
    
    /*! @abstract Creates a new web view.
     @param webView The web view invoking the delegate method.
     @param configuration The configuration to use when creating the new web
     view.
     @param navigationAction The navigation action causing the new web view to
     be created.
     @param windowFeatures Window features requested by the webpage.
     @result A new web view or nil.
     @discussion The web view returned must be created with the specified configuration. WebKit will load the request in the returned web view.
     
     If you do not implement this method, the web view will cancel the navigation.
     @available(iOS 8.0, *)
     */
    //     func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView?{
    //        return nil
    //    }
    
    
    /*! @abstract Notifies your app that the DOM window object's close() method completed successfully.
     @param webView The web view invoking the delegate method.
     @discussion Your app should remove the web view from the view hierarchy and update
     the UI as needed, such as by closing the containing browser tab or window.
     @available(iOS 9.0, *)
     */
    func webViewDidClose(_ webView: WKWebView){
        
    }
    
    
    /*! @abstract Displays a JavaScript alert panel.
     @param webView The web view invoking the delegate method.
     @param message The message to display.
     @param frame Information about the frame whose JavaScript initiated this
     call.
     @param completionHandler The completion handler to call after the alert
     panel has been dismissed.
     @discussion For user security, your app should call attention to the fact
     that a specific website controls the content in this panel. A simple forumla
     for identifying the controlling website is frame.request.URL.host.
     The panel should have a single OK button.
     
     If you do not implement this method, the web view will behave as if the user selected the OK button.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void){
        completionHandler()
    }
    
    
    /*! @abstract Displays a JavaScript confirm panel.
     @param webView The web view invoking the delegate method.
     @param message The message to display.
     @param frame Information about the frame whose JavaScript initiated this call.
     @param completionHandler The completion handler to call after the confirm
     panel has been dismissed. Pass YES if the user chose OK, NO if the user
     chose Cancel.
     @discussion For user security, your app should call attention to the fact
     that a specific website controls the content in this panel. A simple forumla
     for identifying the controlling website is frame.request.URL.host.
     The panel should have two buttons, such as OK and Cancel.
     
     If you do not implement this method, the web view will behave as if the user selected the Cancel button.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void){
        completionHandler(true)
    }
    
    
    /*! @abstract Displays a JavaScript text input panel.
     @param webView The web view invoking the delegate method.
     @param message The message to display.
     @param defaultText The initial text to display in the text entry field.
     @param frame Information about the frame whose JavaScript initiated this call.
     @param completionHandler The completion handler to call after the text
     input panel has been dismissed. Pass the entered text if the user chose
     OK, otherwise nil.
     @discussion For user security, your app should call attention to the fact
     that a specific website controls the content in this panel. A simple forumla
     for identifying the controlling website is frame.request.URL.host.
     The panel should have two buttons, such as OK and Cancel, and a field in
     which to enter text.
     
     If you do not implement this method, the web view will behave as if the user selected the Cancel button.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Swift.Void){
        completionHandler("提交已经输入的文字,如果没有输入的话就传nil")
    }
    
    
    /*! @abstract Allows your app to determine whether or not the given element should show a preview.
     @param webView The web view invoking the delegate method.
     @param elementInfo The elementInfo for the element the user has started touching.
     @discussion To disable previews entirely for the given element, return NO. Returning NO will prevent
     webView:previewingViewControllerForElement:defaultActions: and webView:commitPreviewingViewController:
     from being invoked.
     
     This method will only be invoked for elements that have default preview in WebKit, which is
     limited to links. In the future, it could be invoked for additional elements.
     @available(iOS 10.0, *)
     */
    //    @available(iOS 10.0, *)
    //    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool{
    //        return true
    //    }
    
    
    /*! @abstract Allows your app to provide a custom view controller to show when the given element is peeked.
     @param webView The web view invoking the delegate method.
     @param elementInfo The elementInfo for the element the user is peeking.
     @param defaultActions An array of the actions that WebKit would use as previewActionItems for this element by
     default. These actions would be used if allowsLinkPreview is YES but these delegate methods have not been
     implemented, or if this delegate method returns nil.
     @discussion Returning a view controller will result in that view controller being displayed as a peek preview.
     To use the defaultActions, your app is responsible for returning whichever of those actions it wants in your
     view controller's implementation of -previewActionItems.
     
     Returning nil will result in WebKit's default preview behavior. webView:commitPreviewingViewController: will only be invoked
     if a non-nil view controller was returned.
     @available(iOS 10.0, *)
     */
    //    @available(iOS 10.0, *)
    //    func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController?{
    //        return nil
    //    }
    
    
    /*! @abstract Allows your app to pop to the view controller it created.
     @param webView The web view invoking the delegate method.
     @param previewingViewController The view controller that is being popped.
     @available(iOS 10.0, *)
     */
    func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController){
        
    }

    
    
    
    
    
    
    
    
    
}


