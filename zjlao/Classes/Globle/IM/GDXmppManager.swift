//
//  GDXmppManager.swift
//  zjlao
//
//  Created by WY on 17/1/6.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//
/*
 lazy var applicationDocumentsDirectory: URL = {
 // The directory the application uses to store the Core Data store file. This code uses a directory named "com.16lao.new.mh824appWithSwift" in the application's documents Application Support directory.
 let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
 return urls[urls.count-1]
 }()
 */
import UIKit
import XMPPFramework
class GDXmppManager: NSObject  , XMPPStreamDelegate,XMPPReconnectDelegate , XMPPIncomingFileTransferDelegate , XMPPOutgoingFileTransferDelegate, XMPPAutoPingDelegate , XMPPRosterDelegate {
    
    
    
    
    
    
    
///////////////////////////*******自定义方法区********/////////////////////////////////
//MARK:登录
    func login(jidName : String , password : String)  {
        self.password = password
        let loginJid = XMPPJID.init(user: jidName, domain: "jabber.zjlao.com", resource: "iOS")
        self.xmppStream.myJID = loginJid
        do {
            try  self.xmppStream.connect(withTimeout: -1)
        } catch  {
            mylog("xmppStream链接失败")
        }
        self.activeModule()
    }
//MARK:退出
    func loginout ()  {
        self.xmppStream.disconnectAfterSending()
    }
//MARK: 激活模块儿
    func activeModule  ()  {
        self.xmppRoster.activate(self.xmppStream)
        self.xmppReconnect.activate(self.xmppStream)
        self.xmppAutoPing.activate(self.xmppStream)
        self.xmppvCardAvatarModule.activate(self.xmppStream)
        self.xmppVCardTempModule.activate(self.xmppStream)
        self.xmppMessageArchiving.activate(self.xmppStream)
        self.incomingFileTransfer.activate(self.xmppStream)
        self.outgoingFileTransfer.activate(self.xmppStream)
    }
    
///////////////////////////*******代理方法区********/////////////////////////////////
    //MARK:xmppstreamDelegate
    func xmppStreamWillConnect(_ sender: XMPPStream!){mylog("xmppStream即将执行链接")}
    func xmppStreamDidConnect(_ sender: XMPPStream!){
        mylog("xmppStream链接成功")
        do {
            try sender.authenticate(withPassword: self.password)
        } catch  {
            mylog("认证执行失败")
        }
        
    }
    func xmppStreamConnectDidTimeout(_ sender: XMPPStream!){mylog("xmpp链接超时")}
    func xmppStreamDidAuthenticate(_ sender: XMPPStream!){
        mylog("认证成功")
        //是否清除上一个账户的聊天记录
        let presence = XMPPPresence.init()
        presence?.addChild(DDXMLNode.element(withName: "show", stringValue: "chat") as! DDXMLNode)
        presence?.addChild(DDXMLNode.element(withName: "status", stringValue: "online") as! DDXMLNode)
        presence?.addChild(DDXMLNode.element(withName: "nick", stringValue: "I'm 传奇") as! DDXMLNode)
        presence?.addChild(DDXMLNode.element(withName: "nickName", stringValue: "I'm 传奇") as! DDXMLNode)
        presence?.addChild(DDXMLNode.element(withName: "type", stringValue: "") as! DDXMLNode)
        self.xmppStream.send(presence)
    }
    func xmppStream(_ sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!){mylog("认证失败 错误信息\(error)")}

    func xmppStreamDidDisconnect(_ sender: XMPPStream!, withError error: Error!){mylog("stream流断开 , 错误信息 \(error)")
        //是否进行重连
    }
//    func xmppStream(_ sender: XMPPStream!, willReceive message: XMPPMessage!) -> XMPPMessage!{
//        mylog("即将接收消息 \(message.body())")
//    }
//    
//    func xmppStream(_ sender: XMPPStream!, willReceive presence: XMPPPresence!) -> XMPPPresence!{
//        mylog("即将接收出席信息\(presence)")
//    }
    func xmppStream(_ sender: XMPPStream!, didReceive message: XMPPMessage!){
         mylog("接收消息 \(message.body())")
        let bodyOp = message.body()
        if let body  = bodyOp {
            if !body.isEmpty {
                //设置声音 , 消息图标等
                mylog("接收消息 \(message.body())")
            }else{
                mylog("接收到了空消息 \(message.body())")
            }
        }else{
             mylog("接收到了空消息 \(message.body())")
        }

    }
    
    func xmppStream(_ sender: XMPPStream!, didReceive presence: XMPPPresence!){
         mylog("登录成功后 , 接收到自己的出席信息\(presence)")
    }
    
    func xmppStream(_ sender: XMPPStream!, didSend message: XMPPMessage!){
        mylog("信息发送成功\(message.body())")
    }
    
    func xmppStream(_ sender: XMPPStream!, didSend presence: XMPPPresence!){
        mylog("出席信息发送成功\(presence.description)")
    }
    
    
    func xmppStream(_ sender: XMPPStream!, didFailToSend message: XMPPMessage!, error: Error!){
        mylog("信息发送失败\(message.body() )  , 错误信息 \(error)")
    }
    
    func xmppStream(_ sender: XMPPStream!, didFailToSend presence: XMPPPresence!, error: Error!){
        mylog("出席信息发送失败\(presence.description) , 错误信息 \(error)")
    }
    

    func xmppStreamDidChangeMyJID(_ xmppStream: XMPPStream!){
        mylog("im账户发生改变, 新的账户名是:\(xmppStream.myJID.user)")
    }
    
    
    func xmppStream(_ sender: XMPPStream!, didReceiveError error: DDXMLElement!){//掉线代理
        mylog("🍣接收到了错误信息\(error)")
        let children = error.children?.enumerated()
        if let ch  = children {
            for (index , node ) in ch  {
                if (node.name == "conflict") {
//                    self.isNeedReconnect = NO ;
                    
                    //    [self performLoginOutByRemote];
                    
                    mylog("_%d_掉线了");
                    //            UIAlertController * vc = [UIAlertController alertControllerWithTitle:@"警告" message:@"账户在其他设备登录" preferredStyle:UIAlertControllerStyleAlert];
                    //            GDAlertView
                    self.loginout()
                }
            }
        }

    }
    
    //MARK: 花名册代理方法
    /**
     * Sent when a presence subscription request is received.
     * That is, another user has added you to their roster,
     * and is requesting permission to receive presence broadcasts that you send.
     *
     * The entire presence packet is provided for proper extensibility.
     * You can use [presence from] to get the JID of the user who sent the request.
     *
     * The methods acceptPresenceSubscriptionRequestFrom: and rejectPresenceSubscriptionRequestFrom: can
     * be used to respond to the request.
     **/
    func xmppRoster(_ sender: XMPPRoster!, didReceivePresenceSubscriptionRequest presence: XMPPPresence!){
        mylog("接收到添加好友申请:\(presence.nick())")
       sender.acceptPresenceSubscriptionRequest(from: presence.from(), andAddToRoster: true )//同意好友申请
        
    }
    
    
    /**
     * Sent when a Roster Push is received as specified in Section 2.1.6 of RFC 6121.
     **/
    func xmppRoster(_ sender: XMPPRoster!, didReceiveRosterPush iq: XMPPIQ!){
        mylog(" didReceiveRosterPush : \(iq.description)")
    }
    
    
    /**
     * Sent when the initial roster is received.
     **/
    func xmppRosterDidBeginPopulating(_ sender: XMPPRoster!, withVersion version: String!){
        mylog("Sent when the initial roster is received  : \(sender.description)")
    }
    
    
    /**
     * Sent when the initial roster has been populated into storage.
     **/
    func xmppRosterDidEndPopulating(_ sender: XMPPRoster!){
        mylog("Sent when the initial roster has been populated into storage : \(sender.description)")
    }
    
    
    /**
     * Sent when the roster receives a roster item.
     *
     * Example:
     *
     * <item jid='romeo@example.net' name='Romeo' subscription='both'>
     *   <group>Friends</group>
     * </item>
     **/
    func xmppRoster(_ sender: XMPPRoster!, didReceiveRosterItem item: DDXMLElement!){
        mylog("Sent when the roster receives a roster item : \(item.name)")
    }
    
    
    //MARK:接收文件代理方法
    func xmppIncomingFileTransfer(_ sender: XMPPIncomingFileTransfer!, didFailWithError error: Error!){mylog("文件接收失败")}
    func xmppIncomingFileTransfer(_ sender: XMPPIncomingFileTransfer!, didReceiveSIOffer offer: XMPPIQ!){
        mylog("正在接收文件")
    
    }
    func xmppIncomingFileTransfer(_ sender: XMPPIncomingFileTransfer!, didSucceedWith data: Data!, named name: String!){mylog("文件接收成功")}
    
    //MARK:文件发送代理方法
    func xmppOutgoingFileTransfer(_ sender: XMPPOutgoingFileTransfer!, didFailWithError error: Error!)
    {mylog("文件发送失败")}
    func xmppOutgoingFileTransferDidSucceed(_ sender: XMPPOutgoingFileTransfer!)
    {mylog("文件发送失败")}
    func xmppOutgoingFileTransferIBBClosed(_ sender: XMPPOutgoingFileTransfer!)
    {mylog("文件发送传输被关闭")}
    
    //MARK:心跳检测代理方法
    func xmppAutoPingDidSend(_ sender: XMPPAutoPing!){mylog("心跳ping发送成功")}
    func xmppAutoPingDidReceivePong(_ sender: XMPPAutoPing!){mylog("心跳pong接收成功")}
    func xmppAutoPingDidTimeout(_ sender: XMPPAutoPing!){mylog("心跳检测超时")}
    
    //MARK:重连代理
    func xmppReconnect(_ sender: XMPPReconnect!, didDetectAccidentalDisconnect connectionFlags: SCNetworkConnectionFlags){
        mylog("检测到需要重连")
    }
    
//    func xmppReconnect(_ sender: XMPPReconnect!, shouldAttemptAutoReconnect connectionFlags: SCNetworkConnectionFlags) -> Bool
///////////////////////////*******属性区********/////////////////////////////////
    
//MARK:XMPPStream
    lazy var xmppStream : XMPPStream = {
        let tempXmppStream = XMPPStream.init()
        tempXmppStream?.hostName = "jabber.zjlao.com"
        tempXmppStream?.hostPort = 5222
        tempXmppStream?.addDelegate(self, delegateQueue: DispatchQueue.global())
        tempXmppStream?.enableBackgroundingOnSocket = true
        return tempXmppStream!
    }()
    
    //MARK:重连模块
    lazy var xmppReconnect : XMPPReconnect = {
        let tempXmppReconnect = XMPPReconnect.init(dispatchQueue: DispatchQueue.global())
        tempXmppReconnect?.addDelegate(self, delegateQueue: DispatchQueue.main)
        tempXmppReconnect?.autoReconnect = false
//        tempXmppReconnect?.reconnectTimerInterval = 2
        return tempXmppReconnect!
    }()
    
    //MARK: 心跳检测模块儿
    lazy var xmppAutoPing : XMPPAutoPing = {
        let tempXmppAutoPing = XMPPAutoPing.init(dispatchQueue: DispatchQueue.global())
        tempXmppAutoPing?.addDelegate(self , delegateQueue: DispatchQueue.main)
//        tempXmppAutoPing?.pingInterval = 2 //默认60
        return tempXmppAutoPing!
    }()
    
    //MARK: 花名册模块
    lazy var xmppRoster : XMPPRoster = {
        let tempXmppRoster = XMPPRoster.init(rosterStorage: XMPPRosterCoreDataStorage.sharedInstance(), dispatchQueue: DispatchQueue.main)
        tempXmppRoster?.addDelegate(self , delegateQueue: DispatchQueue.main )
        tempXmppRoster?.autoFetchRoster = true //自动查找通讯录
        tempXmppRoster?.autoClearAllUsersAndResources = false //下线是否删除好友
        tempXmppRoster?.autoAcceptKnownPresenceSubscriptionRequests = true //xmpp中有一个自动实现的方法,

        return tempXmppRoster!
    }()
    
    //MARK:文件传出
    lazy var outgoingFileTransfer : XMPPOutgoingFileTransfer = {
        let tempOutgoingFileTransfer : XMPPOutgoingFileTransfer = XMPPOutgoingFileTransfer.init()
        tempOutgoingFileTransfer.addDelegate(self , delegateQueue: DispatchQueue.main)
        return tempOutgoingFileTransfer
    }()
    
    //MARK:文件传入
    lazy var incomingFileTransfer : XMPPIncomingFileTransfer = {
        let tempIncomingFileTransfer = XMPPIncomingFileTransfer.init()
        tempIncomingFileTransfer?.addDelegate(self , delegateQueue: DispatchQueue.main)
        tempIncomingFileTransfer?.autoAcceptFileTransfers = true
        return tempIncomingFileTransfer!
    }()
    
    //MARK: 消息管理模块
    lazy var xmppMessageArchiving : XMPPMessageArchiving  = {
        let tempXmppMessageArchiving = XMPPMessageArchiving.init(messageArchivingStorage: XMPPMessageArchivingCoreDataStorage.sharedInstance(), dispatchQueue: DispatchQueue.main)
        return tempXmppMessageArchiving!
    }()

    
    //MARK:个人资料模块儿
    lazy var xmppVCardTempModule : XMPPvCardTempModule = {
        let tempXmppVCardTempModule = XMPPvCardTempModule.init(vCardStorage: XMPPvCardCoreDataStorage.sharedInstance(), dispatchQueue: DispatchQueue.main)
//        XMPPvCardTempModuleDelegate
        return tempXmppVCardTempModule!
    }()
    
    //MARK:头像模块儿
    lazy var xmppvCardAvatarModule : XMPPvCardAvatarModule = {
        let xmppvCardAvatarModule = XMPPvCardAvatarModule.init(vCardTempModule: self.xmppVCardTempModule, dispatchQueue: DispatchQueue.main)
        //        XMPPvCardTempModuleDelegate
        return xmppvCardAvatarModule!
    }()
    
    //MARK:单例
    static  let share : GDXmppManager  = {
        let tempShare  = GDXmppManager.init()
        return tempShare
    }()
    //MARK:密码
    var password  = ""
    /** 联系人查询控制器 */
    lazy var contactFetchedresultsController : NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in 
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init()//查询请求
        let entitys = NSEntityDescription.entity(forEntityName: "XMPPMessageArchiving_Contact_CoreDataObject", in: XMPPMessageArchivingCoreDataStorage.sharedInstance().mainThreadManagedObjectContext)
        fetchrequest.entity = entitys
        let sort  =  NSSortDescriptor(key: "mostRecentMessageTimestamp", ascending: true )
        let temp = NSFetchedResultsController.init(fetchRequest: fetchrequest, managedObjectContext: XMPPMessageArchivingCoreDataStorage.sharedInstance().mainThreadManagedObjectContext, sectionNameKeyPath: nil , cacheName: "Recently")
//        temp.delegate = self //
        return temp
    }()
//    @property (nonatomic , strong)NSFetchedResultsController * contactFetchedresultsController;
    /** 单个联系人的消息查询控制器 */
//    @property (nonatomic , strong)NSFetchedResultsController * messageFetchedresultsController;

    
}

















