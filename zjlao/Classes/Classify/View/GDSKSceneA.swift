//
//  GDSKSceneA.swift
//  zjlao
//
//  Created by WY on 16/12/20.
//  Copyright © 2016年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit
class GDSKSceneA: SKScene {
    private var contentCreated:Bool  = false
    var shipx = 0
    var  spaceship = SKSpriteNode(color: SKColor.gray, size: CGSize(width : 64, height : 32))
    var timer : Timer?
    

    override func didMove(to view: SKView) {
        
        //判断是否是第一次创建
        if(!self.contentCreated){
            
            //置位 以后就不会在执行这里的代码拉
            self.contentCreated = true
            createSceneContents()
//            //创建一个节点 但是是label的节点！ 字体是Chalkduster
//            let helloNode = SKLabelNode(fontNamed: "Chalkduster")
//            helloNode.text = "Hello Wolrd"
//            helloNode.fontSize = 22
//            helloNode.name = "helloNode"
//            
//            //位置是放在屏幕中间
//            helloNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
//            //            helloNode.position = CGPoitMake(CGRectGetMidX(self.frame),
//            //                                            CGRectGetMidY(self.frame))
//            //            self.backgroundColor = SKColor.blueColor()
//            self.backgroundColor = SKColor.clear
//            self.scaleMode = SKSceneScaleMode.aspectFit
//            //添加进去
//            self.addChild(helloNode)
        }
    }

    func createSceneContents() {

        self.backgroundColor = SKColor.blue
        self.scaleMode = SKSceneScaleMode.aspectFit
        let spaceship : SKSpriteNode = newSpaceship()
        self.spaceship = spaceship
        spaceship.position = CGPoint(x:44,y: 44)
        self.addChild(spaceship)
    }
    
    func newSpaceship()->SKSpriteNode{
        //船体叫做hull
        let hull = SKSpriteNode(color: SKColor.gray, size: CGSize(width : 64, height : 32))
        //创建动作 sequence传入的要是一个数组[],里面有4个动作，简单！
        let hover = SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.moveBy(x: self.frame.size.width - 88, y: 0, duration: 1.0),
            SKAction.wait(forDuration: 1.0),
            SKAction.moveBy(x:-self.frame.size.width + 88, y: 0, duration: 1.0),
            ])
        
        let light1 = newLight()
        light1.color = UIColor.red
        light1.position = CGPoint(x: self.spaceship.frame.origin.x , y:110.0 )//CGPointMake(-28.0,6.0)
        //在x，y方向上移动相对举例，比如原来在(0,100) 执行下面之后是(0,200)

//        hull.addChild(light1)
        self.addChild(light1)
        
        //实例化第二个灯光
        let light2 = newLight()
        light2.position = CGPoint(x: self.spaceship.frame.origin.x  , y: 111.0 )// CGPointMake(28.0,6.0)
//        hull.addChild(light2)
        self.addChild(light2)
        light2.color = UIColor.white
        
        
        
//        hull.run(SKAction.repeatForever(hover)) //手动移动
        return hull
    }
    
    func newLight()->SKSpriteNode{
        //纯手工敲代码，代码都是官方文档OC写的
        //对着文档直接翻译成swift，有不对之处请留言
//        let light = SKSpriteNode(color: SKColor.red ,  size:CGSize(width : 8, height : 8))
        let light = SKSpriteNode(imageNamed: "btn_Top")
        light.color = SKColor.gray
        light.size = CGSize(width: 18, height: 18 )
        //moveTo才是移动到具体某个位置
        let moveUp = SKAction.moveBy(x: 0, y: 550, duration: 3.5)
        
        //放大操作
        //        let zoom = SKAction.scale(to: 2.0, duration: 0.25)
        //延迟
        let pause = SKAction.wait(forDuration: 0.5)
        //说白了就是透明度最终变0，即渐隐
        let fadeAway = SKAction.fadeOut(withDuration: 0.25)
        //再回来
//        let movedown = SKAction.moveBy(x: 0, y: -400, duration: 0.5)
        //从节点树种移除该节点
//         let fadeIn = SKAction.fadeIn(withDuration: 0.25)
        let moveOut = SKAction.removeFromParent()
        let light1Actio = [moveUp , pause  ,fadeAway , moveOut    ]

        let blink = SKAction.sequence(light1Actio)
//            SKAction.fadeOut(withDuration: 0.25),
//            SKAction.fadeIn(withDuration: 0.25),
           // )
//        let blinkForever = SKAction.repeatForever(blink)
        let blinkForever = SKAction.repeat(blink, count: 1)
        
        light.run(blinkForever)
        
        return light
    }
    
    
    
    override func sceneDidLoad(){
        self.timer  = Timer.scheduledTimer(timeInterval: 0.21, target: self, selector: #selector(some), userInfo: nil , repeats: true)
           // RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
    }
    
    override func move(toParent parent: SKNode) {
        self.timer  = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(touchesBegan(_:with:)), userInfo: nil , repeats: true)
        //        RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch : UITouch = touches.first!
//        let pointInNode :CGPoint = touch.location(in: self)
//        let previousPointInNode = touch.previousLocation(in: self)
//        let shipPoint =  self.convert(pointInNode, to: self.spaceship)
        mylog("转换后\("得到")")
        let touch : UITouch = touches.first!
        let pointInNode :CGPoint = touch.location(in: self)
        let previousPointInNode = touch.previousLocation(in: self)
        let shipPoint =  self.convert(pointInNode, to: self.spaceship)
        if shipPoint.x > -32 && shipPoint.x < 32 && shipPoint.y > -16 && shipPoint.y < 16 {
            
        }
        mylog("转换前\(pointInNode)")
        mylog("转换后\(shipPoint)")

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        mylog("触摸中")
        mylog(touches)
        mylog(touches.count)
        let touch : UITouch = touches.first!
        let pointInNode :CGPoint = touch.location(in: self)
        let previousPointInNode = touch.previousLocation(in: self)
       let shipPoint =  self.convert(pointInNode, to: self.spaceship)
        mylog("转换后\(shipPoint)")
        
        if shipPoint.x > -32 - 44 && shipPoint.x < 32 + 44 && shipPoint.y > -16 - 44 && shipPoint.y < 16 + 44 {
            self.spaceship.position = pointInNode

        }
        
        
        
        mylog("这一个点\(pointInNode)")
        mylog("上一个点\(previousPointInNode)")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        mylog("触摸结束")
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        mylog("触摸取消")
    }
    func some ()  {
        let light1 = newLight()
        light1.color = UIColor.red
        light1.position = CGPoint(x: self.spaceship.frame.origin.x + 32 , y:self.spaceship.frame.origin.y + 32 )//CGPointMake(-28.0,6.0)
        self.addChild(light1)
    }
}
