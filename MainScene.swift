//
//  MainScene.swift
//  MySpritekit
//
//  Created by mac12 on 2020/4/1.
//  Copyright © 2020 B10615034. All rights reserved.
//

import UIKit
import SpriteKit

class MainScene: SKScene,SKPhysicsContactDelegate {
    let score = SKLabelNode()
    let weapon_kind = 0//種類
    let weapon_level = 1
    //全域變數 武器種類 等級
    var numScore = 0//分數
    override func didMove(to view: SKView){
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)//加速度設為 0
        self.physicsWorld.contactDelegate = self
        createScene()
        let panrecognizer = UIPanGestureRecognizer(target: self, action: #selector(handpan))
        view.addGestureRecognizer(panrecognizer)
    }
    func createScene() {
        let mainbgd = SKSpriteNode(imageNamed: "mainbgd.png")
        mainbgd.size.width = self.size.width
        mainbgd.size.height = self.size.height
        mainbgd.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        mainbgd.zPosition = -1
        score.text = "Score:0"
        score.name = "score"
        score.color = UIColor.yellow
        score.fontSize = 25
        score.position = CGPoint(x:100, y:70)
        let spaceship = newSpaceship()
        spaceship.position = CGPoint(x: self.frame.midX, y: self.frame.midY-150)
        
        self.addChild(mainbgd)
        self.addChild(spaceship)
        self.addChild(score)
        //
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(newBucket), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(newRock), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(newCoin), userInfo: nil, repeats: true)
    }
    func setScore(){
        score.text = "Score:\(numScore)"
    }
    func newSpaceship() ->SKSpriteNode {
        let ship = SKSpriteNode(imageNamed: "spaceship.png")
        
        ship.size = CGSize(width: 75, height: 75)
        ship.name = "ships"
        let leftlight = newLight()
        leftlight.position = CGPoint(x:-20,y: 6)
        ship.addChild(leftlight)
        let rightlight = newLight()
        rightlight.position = CGPoint(x:20,y: 6)
        ship.addChild(rightlight)
        
        ship.physicsBody = SKPhysicsBody(circleOfRadius: ship.size.width / 2)
        ship.physicsBody?.categoryBitMask = 0x1 << 3
        ship.physicsBody?.contactTestBitMask = 0x1 << 2
        ship.physicsBody?.contactTestBitMask = 0x1 << 4
        ship.physicsBody?.usesPreciseCollisionDetection = true
        ship.physicsBody?.isDynamic = false//引力
        
        return ship
    }
    
    func newLight() ->SKShapeNode {
        let light = SKShapeNode()
        light.path = CGPath(rect: CGRect(x:-2, y:-4,width: 4,height: 8), transform: nil)
        light.strokeColor = SKColor.white
        light.fillColor = SKColor.yellow
        
        let blink = SKAction.sequence([SKAction.fadeOut(withDuration: 0.25),SKAction.fadeIn(withDuration: 0.25)])
        let blinkForever = SKAction.repeatForever(blink)
        light.run(blinkForever)
        return light
    }
    
    @objc func newBucket(pos: CGPoint){
        let bucket = SKShapeNode()
        bucket.name = "buckets"
        let pos = self.childNode(withName: "ships")!.position
        bucket.path = CGPath(rect: CGRect(x:-2, y:-4,width: 6,height: 12), transform: nil)
        bucket.strokeColor = SKColor.white
        bucket.fillColor = SKColor.yellow
        let remove = SKAction.sequence([SKAction.wait(forDuration: 3),SKAction.removeFromParent()])
        bucket.position = pos
        let move = SKAction.moveBy(x: 0, y: 1000, duration: 2)
        bucket.run(SKAction.sequence([move,remove]))
        bucket.physicsBody = SKPhysicsBody(circleOfRadius: 6)
        bucket.physicsBody?.categoryBitMask = 0x1 << 1
        bucket.physicsBody?.contactTestBitMask = 0x1 << 2
        bucket.physicsBody?.collisionBitMask = 0
        bucket.physicsBody?.usesPreciseCollisionDetection = true
        bucket.physicsBody?.isDynamic = true
        self.addChild(bucket)
    }
    
    @objc func newRock() {
        let rock = SKSpriteNode(imageNamed: "rock.png")
        rock.size = CGSize(width: 40, height: 40)
        let remove = SKAction.sequence([SKAction.wait(forDuration: 3),SKAction.removeFromParent()])
        let w = self.size.width
        let h = self.size.height
        let x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w)
        rock.position = CGPoint(x: x, y: h)
        rock.name = "rocks"
        rock.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        rock.physicsBody?.usesPreciseCollisionDetection = true
        rock.physicsBody?.isDynamic = true
        rock.physicsBody?.affectedByGravity = false
        
        rock.physicsBody?.categoryBitMask = 0x1 << 2
        rock.physicsBody?.contactTestBitMask = 0x1 << 1
        rock.physicsBody?.collisionBitMask = 0x1 << 1
        let move = SKAction.moveBy(x: 0, y: -700, duration: 3)
        rock.run(SKAction.sequence([move,remove]))
        //rock.run(remove)
        self.addChild(rock)
    }
    @objc func newCoin() {
        let coin = SKSpriteNode(imageNamed: "coin.png")
        coin.size = CGSize(width: 30, height: 30)
        let remove = SKAction.sequence([SKAction.wait(forDuration: 3),SKAction.removeFromParent()])
        let w = self.size.width
        let h = self.size.height
        let x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w)
        coin.position = CGPoint(x: x, y: h)
        coin.name = "coins"
        let move = SKAction.moveBy(x: 0, y: -500, duration: 5)
        coin.run(SKAction.sequence([move,remove]))
        coin.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        coin.physicsBody?.usesPreciseCollisionDetection = true
        coin.physicsBody?.isDynamic = true
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.categoryBitMask = 0x1 << 4
        coin.physicsBody?.contactTestBitMask = 0x1 << 3
        coin.physicsBody?.collisionBitMask = 0x1 << 3
        coin.run(SKAction.sequence([move,remove]))
        self.addChild(coin)
    }
    @objc func handpan(recognizer: UIPanGestureRecognizer){
        let viewLocation = recognizer.location(in: view)
        let sceneLocation = convertPoint(fromView: viewLocation)
        let moveAction = SKAction.move(to: sceneLocation, duration: 0.05)
        self.childNode(withName: "ships")!.run(moveAction)
    }
    func alert(){
        let alertcontroller = UIAlertController(title: "You lose!", message: "Score:\(numScore)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Again", style: .default, handler: nil)
        alertcontroller.addAction(action)
        view?.window?.rootViewController?.present(alertcontroller, animated: true)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        //first body 是太空船
        if contact.bodyA.node?.name == "ships"{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else if contact.bodyA.node?.name == "buckets"{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else if contact.bodyB.node?.name == "ships"{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }else if contact.bodyB.node?.name == "buckets"{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if (firstBody.node?.name == "ships" && secondBody.node?.name == "rocks"){
            let overScene = GameOverScene(size: self.size)
            let doors = SKTransition.doorsOpenVertical(withDuration: 0.3)
            self.view?.presentScene(overScene,transition: doors)
            alert()
        }
        else if (firstBody.node?.name == "ships" && secondBody.node?.name == "coins"){
            contact.bodyB.node?.removeFromParent()
            numScore += 100
            setScore()
        }else if (firstBody.node?.name == "buckets" && secondBody.node?.name == "rocks")
        {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            numScore += 20
            setScore()
        }
    }
}
