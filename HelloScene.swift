//
//  HelloScene.swift
//  MySpritekit
//
//  Created by mac12 on 2020/4/1.
//  Copyright © 2020 B10615034. All rights reserved.
//

import UIKit
import SpriteKit

class HelloScene: SKScene {
    override func didMove(to view: SKView) {
        createScene()
    }
    func createScene(){
        let bgd = SKSpriteNode(imageNamed: "hellobgd.jpg")
        bgd.size.width = self.size.width
        bgd.size.height = self.size.height
        bgd.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bgd.zPosition = -1
        
        let title = SKSpriteNode(imageNamed: "title.png")
        title.name = "title"
        title.size = CGSize(width: 300, height: 60)
        title.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)
        let start = SKSpriteNode(imageNamed: "pressstart.png")
        start.size = CGSize(width: 200, height: 40)
        start.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        let blink = SKAction.sequence([SKAction.fadeOut(withDuration: 0.5),SKAction.fadeIn(withDuration: 0.5)])
        let blinkForever = SKAction.repeatForever(blink)
        start.run(blinkForever)
        self.addChild(bgd)
        self.addChild(title)
        self.addChild(start)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event:UIEvent?){
        let labelNode = self.childNode(withName: "title")
        let moveup = SKAction.moveBy(x: 0, y: 70, duration: 0.75)
        //let span = SKAction.rotate(byAngle: 2500, duration: 0.4)
        let zoomin = SKAction.scale(to: 1.3, duration: 1)
        let pause = SKAction.wait(forDuration: 0.5)
        let zoomout = SKAction.scale(by: 0.5, duration: 0.25)
        let fadeway = SKAction.fadeOut(withDuration: 0.25)
        let remove = SKAction.removeFromParent()
        let movesequence = SKAction.sequence([moveup,zoomin,pause,zoomout,fadeway,remove])
        labelNode?.run(movesequence, completion: {
            let mainScene = MainScene(size: self.size)
            let doors = SKTransition.doorsOpenVertical(withDuration: 0.5)
            self.view?.presentScene(mainScene,transition: doors)
        })
    }
}
