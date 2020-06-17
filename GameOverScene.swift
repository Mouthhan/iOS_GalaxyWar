//
//  GameOverScene.swift
//  MySpritekit
//
//  Created by mac12 on 2020/4/23.
//  Copyright © 2020 B10615034. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    override func didMove(to view: SKView) {
        createScene()
    }
    func createScene(){
        let bgd = SKSpriteNode(imageNamed: "1.jpg")
        //bgd.size.width = self.size.width
        //bgd.size.height = self.size.height
        bgd.position = CGPoint(x: self.frame.midX, y: self.frame.midY+250)
        bgd.zPosition = -1
        
        let overlabel = SKLabelNode(text: "Game Over")
        overlabel.name = "label"
        overlabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        overlabel.fontName = "Avenir-Oblique"
        overlabel.fontSize = 45
        overlabel.fontColor = UIColor.white
        
        self.addChild(bgd)
        self.addChild(overlabel)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event:UIEvent?){
        let labelNode = self.childNode(withName: "label")
        let span = SKAction.rotate(byAngle: 2500, duration: 0.4)
        let pause = SKAction.wait(forDuration: 0.5)
        let remove = SKAction.removeFromParent()
        let movesequence = SKAction.sequence([span,pause,remove])
        labelNode?.run(movesequence, completion: {
            let mainScene = MainScene(size: self.size)
            let doors = SKTransition.doorsOpenVertical(withDuration: 0.5)
            self.view?.presentScene(mainScene,transition: doors)
        })
    }
}
