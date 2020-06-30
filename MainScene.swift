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
    let life = SKLabelNode()
    var boss_life = 150
    var weapon_kind = 0//種類
    var enemy_life = 10
    var weapon_level = 1
    var mylife = 5
    var timer: Timer?
    var e1_timer: Timer?
    var e2_timer: Timer?
    var e1_atk_timer: Timer?
    var e2_atk_timer: Timer?
    var boss_atk1_timer: Timer?
    var boss_atk2_timer: Timer?
    //全域變數 武器種類 等級
    var numScore = 0//分數
    override func didMove(to view: SKView){
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)//加速度設為 0
        self.physicsWorld.contactDelegate = self
        createScene()
        let panrecognizer = UIPanGestureRecognizer(target: self, action: #selector(handpan))
        view.addGestureRecognizer(panrecognizer)
    }
    //restart
    override func touchesBegan(_ touches: Set<UITouch>, with event:UIEvent?){
        for touch: AnyObject in touches {
            let t:UITouch = touch as! UITouch
            if (t.tapCount == 2){
                if (self.isPaused == true){
                    let mainScene = MainScene(size: self.size)
                    let doors = SKTransition.doorsOpenVertical(withDuration: 0.5)
                    self.view?.presentScene(mainScene,transition: doors)
                }
            }
        }
    }
    let mainbgd = SKSpriteNode(imageNamed: "mainbgd.png")
    let mainbgd2 = SKSpriteNode(imageNamed: "mainbgd.png")
    func createScene() {
        let lifecount = SKSpriteNode(imageNamed: "myship.png")
        lifecount.size = CGSize(width: 40, height: 40)
        lifecount.position = CGPoint(x: 290, y: 45)
        lifecount.zPosition = 10
        life.text = " x 5"
        life.fontSize = 30
        life.fontColor = UIColor.black
        life.position = CGPoint(x: 330, y: 30)
        life.zPosition = 10
        mylife = 5
        mainbgd.anchorPoint = CGPoint.zero
        mainbgd.position = CGPoint.zero
        mainbgd.zPosition = -2
        mainbgd2.anchorPoint = CGPoint.zero
        mainbgd2.position = CGPoint(x: 0, y: mainbgd2.size.height - 1)
        mainbgd2.zPosition = -2
        score.text = "Score:0"
        score.name = "score"
        score.fontColor = UIColor.black
        score.fontSize = 25
        score.position = CGPoint(x:80, y:50)
        score.zPosition = 10
        let spaceship = newSpaceship()
        spaceship.position = CGPoint(x: self.frame.midX, y: self.frame.midY-300)
        let moveup = SKAction.moveBy(x: 0, y: 100, duration: 0.5)
        spaceship.run(moveup)
        self.addChild(mainbgd)
        self.addChild(mainbgd2)
        self.addChild(spaceship)
        self.addChild(score)
        self.addChild(lifecount)
        self.addChild(life)

        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(newBullet), userInfo: nil, repeats: true)
        self.e1_atk_timer?.invalidate()
        self.e1_atk_timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(newEnemyBullet), userInfo: nil, repeats: true)
        self.e2_atk_timer?.invalidate()
        self.e2_atk_timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(newEnemy2Bullet), userInfo: nil, repeats: true)
        self.e1_timer?.invalidate()
        self.e1_timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(newEnemy1), userInfo: nil, repeats: true)
        self.e2_timer?.invalidate()
        self.e2_timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(newEnemy2), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(newAmmo), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 25, target: self, selector: #selector(newTypeChange), userInfo: nil, repeats: true)
        //Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(EnemyUp), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: 80, target: self, selector: #selector(warning), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: 85, target: self, selector: #selector(newBoss), userInfo: nil, repeats: false)
    }
    //scrolling
    override func update(_ currentTime: TimeInterval) {
        mainbgd.position = CGPoint(x: mainbgd.position.x, y: mainbgd.position.y - 3)
        mainbgd2.position = CGPoint(x: mainbgd2.position.x, y: mainbgd2.position.y - 3)
        if (mainbgd.position.y < -mainbgd.size.height){
            mainbgd.position = CGPoint(x: mainbgd.position.x, y: mainbgd2.position.y + mainbgd2.size.height)
        }
        if (mainbgd2.position.y < -mainbgd2.size.height){
            mainbgd2.position = CGPoint(x: mainbgd2.position.x, y: mainbgd.position.y + mainbgd.size.height)
        }
    }
    func setScore(){
        score.text = "Score:\(numScore)"
    }
    func setLife(){
        life.text = " x \(mylife)"
    }
    func newSpaceship() ->SKSpriteNode {
        let ship = SKSpriteNode(imageNamed: "myship.png")
        weapon_level = 1
        weapon_kind = 0//bullet
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(newBullet), userInfo: nil, repeats: true)
        ship.size = CGSize(width: 100, height: 100)
        ship.name = "ships"
        ship.zPosition = 3
        let leftlight = newLight()
        leftlight.position = CGPoint(x:-27,y: 10)
        ship.addChild(leftlight)
        let rightlight = newLight()
        rightlight.position = CGPoint(x:25,y: 10)
        ship.addChild(rightlight)
        
        ship.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        ship.physicsBody?.categoryBitMask = 0x1 << 3
        ship.physicsBody?.contactTestBitMask = 0x1 << 2 // enemy
        ship.physicsBody?.contactTestBitMask = 0x1 << 4 // coin
        ship.physicsBody?.contactTestBitMask = 0x1 << 5 // enemy1 bullet
        ship.physicsBody?.usesPreciseCollisionDetection = true
        ship.physicsBody?.isDynamic = false
        
        return ship
    }
    
    func newLight() ->SKShapeNode {
        let light = SKShapeNode()
        light.path = CGPath(rect: CGRect(x:-2, y:-4,width: 8,height: 16), transform: nil)
        light.strokeColor = SKColor.black
        light.fillColor = SKColor.white
        
        let blink = SKAction.sequence([SKAction.fadeOut(withDuration: 0.25),SKAction.fadeIn(withDuration: 0.25)])
        let blinkForever = SKAction.repeatForever(blink)
        light.run(blinkForever)
        return light
    }
    @objc func newEnemyBullet(){
        self.enumerateChildNodes(withName: "enemy"){
            node, _ in
            let bullet = SKShapeNode(ellipseOf: CGSize(width: 10, height: 10))
            bullet.name = "e_bullets"
            let pos = node.position
            //bullet.path = CGPath(rect: CGRect(x:-2, y:-4,width: 4,height: 8), transform: nil)
            bullet.strokeColor = SKColor.black
            bullet.fillColor = SKColor.red
            bullet.position = pos
            let goal_pos = self.childNode(withName: "ships")!.position
            let X_del = goal_pos.x - pos.x
            let Y_del = goal_pos.y - pos.y
            var vector = CGVector()
            vector.dx = 1.5 * X_del
            vector.dy = 1.5 * Y_del
            let move = SKAction.sequence([SKAction.move(by: vector, duration: 2),SKAction.removeFromParent()])
            bullet.run(SKAction.sequence([move]))
            bullet.physicsBody = SKPhysicsBody(circleOfRadius: 6)
            bullet.physicsBody?.categoryBitMask = 0x1 << 5 //enemy1 bullet
            bullet.physicsBody?.contactTestBitMask = 0x1 << 3
            bullet.physicsBody?.contactTestBitMask = 0x1 << 6
            bullet.physicsBody?.collisionBitMask = 0x1 << 3
            bullet.physicsBody?.usesPreciseCollisionDetection = true
            bullet.physicsBody?.isDynamic = true
            self.addChild(bullet)
        }
    }
    @objc func newEnemy2Bullet(){
        self.enumerateChildNodes(withName: "enemy2"){
            node, _ in
            let bullet = SKShapeNode(ellipseOf: CGSize(width: 10, height: 10))
            bullet.name = "e_bullets"
            let pos = node.position
            //bullet.path = CGPath(rect: CGRect(x:-2, y:-4,width: 4,height: 8), transform: nil)
            bullet.strokeColor = SKColor.black
            bullet.fillColor = SKColor.red
            bullet.position = pos
            bullet.physicsBody = SKPhysicsBody(circleOfRadius: 6)
            bullet.physicsBody?.categoryBitMask = 0x1 << 5 //enemy1 bullet
            bullet.physicsBody?.contactTestBitMask = 0x1 << 3
            bullet.physicsBody?.contactTestBitMask = 0x1 << 6
            bullet.physicsBody?.collisionBitMask = 0x1 << 3
            bullet.physicsBody?.usesPreciseCollisionDetection = true
            bullet.physicsBody?.isDynamic = true
            
            let bullet2 = SKShapeNode(ellipseOf: CGSize(width: 10, height: 10))
            bullet2.name = "e_bullets"
            //bullet.path = CGPath(rect: CGRect(x:-2, y:-4,width: 4,height: 8), transform: nil)
            bullet2.strokeColor = SKColor.black
            bullet2.fillColor = SKColor.red
            bullet2.position = pos
            bullet2.physicsBody = SKPhysicsBody(circleOfRadius: 6)
            bullet2.physicsBody?.categoryBitMask = 0x1 << 5 //enemy1 bullet
            bullet2.physicsBody?.contactTestBitMask = 0x1 << 3
            bullet2.physicsBody?.contactTestBitMask = 0x1 << 6
            bullet2.physicsBody?.collisionBitMask = 0x1 << 3
            bullet2.physicsBody?.usesPreciseCollisionDetection = true
            bullet2.physicsBody?.isDynamic = true
            
            let bullet3 = SKShapeNode(ellipseOf: CGSize(width: 10, height: 10))
            bullet3.name = "e_bullets"
            //bullet.path = CGPath(rect: CGRect(x:-2, y:-4,width: 4,height: 8), transform: nil)
            bullet3.strokeColor = SKColor.black
            bullet3.fillColor = SKColor.red
            bullet3.position = pos
            bullet3.physicsBody = SKPhysicsBody(circleOfRadius: 6)
            bullet3.physicsBody?.categoryBitMask = 0x1 << 5 //enemy1 bullet
            bullet3.physicsBody?.contactTestBitMask = 0x1 << 3
            bullet3.physicsBody?.contactTestBitMask = 0x1 << 6
            bullet3.physicsBody?.collisionBitMask = 0x1 << 3
            bullet3.physicsBody?.usesPreciseCollisionDetection = true
            bullet3.physicsBody?.isDynamic = true
            
            let bullet4 = SKShapeNode(ellipseOf: CGSize(width: 10, height: 10))
            bullet4.name = "e_bullets"
            //bullet.path = CGPath(rect: CGRect(x:-2, y:-4,width: 4,height: 8), transform: nil)
            bullet4.strokeColor = SKColor.black
            bullet4.fillColor = SKColor.red
            bullet4.position = pos
            bullet4.physicsBody = SKPhysicsBody(circleOfRadius: 6)
            bullet4.physicsBody?.categoryBitMask = 0x1 << 5 //enemy1 bullet
            bullet4.physicsBody?.contactTestBitMask = 0x1 << 3
            bullet4.physicsBody?.contactTestBitMask = 0x1 << 6
            bullet4.physicsBody?.collisionBitMask = 0x1 << 3
            bullet4.physicsBody?.usesPreciseCollisionDetection = true
            bullet4.physicsBody?.isDynamic = true
            
            let bullet5 = SKShapeNode(ellipseOf: CGSize(width: 10, height: 10))
            bullet5.name = "e_bullets"
            //bullet.path = CGPath(rect: CGRect(x:-2, y:-4,width: 4,height: 8), transform: nil)
            bullet5.strokeColor = SKColor.black
            bullet5.fillColor = SKColor.red
            bullet5.position = pos
            bullet5.physicsBody = SKPhysicsBody(circleOfRadius: 6)
            bullet5.physicsBody?.categoryBitMask = 0x1 << 5 //enemy1 bullet
            bullet5.physicsBody?.contactTestBitMask = 0x1 << 3
            bullet5.physicsBody?.contactTestBitMask = 0x1 << 6
            bullet5.physicsBody?.collisionBitMask = 0x1 << 3
            bullet5.physicsBody?.usesPreciseCollisionDetection = true
            bullet5.physicsBody?.isDynamic = true
            
            let X1_del = -885.0
            let Y1_del = -500.0
            let X2_del = -500.0
            let Y2_del = -885.0
            let X3_del = 0.0
            let Y3_del = -1000.0
            let X4_del = 500.0
            let Y4_del = -885.0
            let X5_del = 885.0
            let Y5_del = -500.0
            var vector = CGVector()
            vector.dx = CGFloat(1.5 * X1_del)
            vector.dy = CGFloat(1.5 * Y1_del)
            var vector2 = CGVector()
            vector2.dx = CGFloat(1.5 * X2_del)
            vector2.dy = CGFloat(1.5 * Y2_del)
            var vector3 = CGVector()
            vector3.dx = CGFloat(1.5 * X3_del)
            vector3.dy = CGFloat(1.5 * Y3_del)
            var vector4 = CGVector()
            vector4.dx = CGFloat(1.5 * X4_del)
            vector4.dy = CGFloat(1.5 * Y4_del)
            var vector5 = CGVector()
            vector5.dx = CGFloat(1.5 * X5_del)
            vector5.dy = CGFloat(1.5 * Y5_del)
            let move = SKAction.sequence([SKAction.move(by: vector, duration: 2),SKAction.removeFromParent()])
            bullet.run(SKAction.sequence([move]))
            let move2 = SKAction.sequence([SKAction.move(by: vector2, duration: 2),SKAction.removeFromParent()])
            bullet2.run(SKAction.sequence([move2]))
            let move3 = SKAction.sequence([SKAction.move(by: vector3, duration: 2),SKAction.removeFromParent()])
            bullet3.run(SKAction.sequence([move3]))
            let move4 = SKAction.sequence([SKAction.move(by: vector4, duration: 2),SKAction.removeFromParent()])
            bullet4.run(SKAction.sequence([move4]))
            let move5 = SKAction.sequence([SKAction.move(by: vector5, duration: 2),SKAction.removeFromParent()])
            bullet5.run(SKAction.sequence([move5]))
            
            self.addChild(bullet)
            self.addChild(bullet2)
            self.addChild(bullet3)
            self.addChild(bullet4)
            self.addChild(bullet5)
        }
    }
    @objc func newBossBullet(){
        self.enumerateChildNodes(withName: "boss"){
            node, _ in
            let bullet = SKShapeNode(ellipseOf: CGSize(width: 10, height: 10))
            bullet.name = "e_bullets"
            let pos = CGPoint(x: node.position.x - 150, y: node.position.y)
            //bullet.path = CGPath(rect: CGRect(x:-2, y:-4,width: 4,height: 8), transform: nil)
            bullet.strokeColor = SKColor.black
            bullet.fillColor = SKColor.green
            bullet.position = pos
            let goal_pos = self.childNode(withName: "ships")!.position
            let X1_del = goal_pos.x - pos.x
            let Y1_del = goal_pos.y - pos.y
            var vector = CGVector()
            vector.dx = 1.5 * X1_del
            vector.dy = 1.5 * Y1_del
            let move = SKAction.sequence([SKAction.move(by: vector, duration: 2),SKAction.removeFromParent()])
            bullet.run(SKAction.sequence([move]))
            bullet.physicsBody = SKPhysicsBody(circleOfRadius: 6)
            bullet.physicsBody?.categoryBitMask = 0x1 << 5 //enemy1 bullet
            bullet.physicsBody?.contactTestBitMask = 0x1 << 3
            bullet.physicsBody?.contactTestBitMask = 0x1 << 6
            bullet.physicsBody?.collisionBitMask = 0x1 << 3
            bullet.physicsBody?.usesPreciseCollisionDetection = true
            bullet.physicsBody?.isDynamic = true
            
            let bullet2 = SKShapeNode(ellipseOf: CGSize(width: 10, height: 10))
            bullet2.name = "e_bullets"
            let pos2 = CGPoint(x: node.position.x + 150, y: node.position.y)
            bullet2.strokeColor = SKColor.black
            bullet2.fillColor = SKColor.green
            bullet2.position = pos2
            let X2_del = goal_pos.x - pos2.x
            let Y2_del = goal_pos.y - pos2.y
            var vector2 = CGVector()
            vector2.dx = 1.5 * X2_del
            vector2.dy = 1.5 * Y2_del
            let move2 = SKAction.sequence([SKAction.move(by: vector2, duration: 2),SKAction.removeFromParent()])
            bullet2.run(SKAction.sequence([move2]))
            bullet2.physicsBody = SKPhysicsBody(circleOfRadius: 6)
            bullet2.physicsBody?.categoryBitMask = 0x1 << 5 //enemy1 bullet
            bullet2.physicsBody?.contactTestBitMask = 0x1 << 3
            bullet2.physicsBody?.contactTestBitMask = 0x1 << 6
            bullet2.physicsBody?.collisionBitMask = 0x1 << 3
            bullet2.physicsBody?.usesPreciseCollisionDetection = true
            bullet2.physicsBody?.isDynamic = true
            self.addChild(bullet)
            self.addChild(bullet2)
        }
    }
    @objc func newBossBullet2(){
        self.enumerateChildNodes(withName: "boss"){
            node, _ in
            let bullet = SKShapeNode(ellipseOf: CGSize(width: 10, height: 10))
            bullet.name = "e_bullets"
            let pos = node.position
            //bullet.path = CGPath(rect: CGRect(x:-2, y:-4,width: 4,height: 8), transform: nil)
            bullet.strokeColor = SKColor.black
            bullet.fillColor = SKColor.green
            bullet.position = pos
            bullet.physicsBody = SKPhysicsBody(circleOfRadius: 6)
            bullet.physicsBody?.categoryBitMask = 0x1 << 5 //enemy1 bullet
            bullet.physicsBody?.contactTestBitMask = 0x1 << 3
            bullet.physicsBody?.contactTestBitMask = 0x1 << 6
            bullet.physicsBody?.collisionBitMask = 0x1 << 3
            bullet.physicsBody?.usesPreciseCollisionDetection = true
            bullet.physicsBody?.isDynamic = true
            
            let bullet2 = SKShapeNode(ellipseOf: CGSize(width: 10, height: 10))
            bullet2.name = "e_bullets"
            //bullet.path = CGPath(rect: CGRect(x:-2, y:-4,width: 4,height: 8), transform: nil)
            bullet2.strokeColor = SKColor.black
            bullet2.fillColor = SKColor.green
            bullet2.position = pos
            bullet2.physicsBody = SKPhysicsBody(circleOfRadius: 6)
            bullet2.physicsBody?.categoryBitMask = 0x1 << 5 //enemy1 bullet
            bullet2.physicsBody?.contactTestBitMask = 0x1 << 3
            bullet2.physicsBody?.contactTestBitMask = 0x1 << 6
            bullet2.physicsBody?.collisionBitMask = 0x1 << 3
            bullet2.physicsBody?.usesPreciseCollisionDetection = true
            bullet2.physicsBody?.isDynamic = true
            
            let bullet3 = SKShapeNode(ellipseOf: CGSize(width: 10, height: 10))
            bullet3.name = "e_bullets"
            //bullet.path = CGPath(rect: CGRect(x:-2, y:-4,width: 4,height: 8), transform: nil)
            bullet3.strokeColor = SKColor.black
            bullet3.fillColor = SKColor.green
            bullet3.position = pos
            bullet3.physicsBody = SKPhysicsBody(circleOfRadius: 6)
            bullet3.physicsBody?.categoryBitMask = 0x1 << 5 //enemy1 bullet
            bullet3.physicsBody?.contactTestBitMask = 0x1 << 3
            bullet3.physicsBody?.contactTestBitMask = 0x1 << 6
            bullet3.physicsBody?.collisionBitMask = 0x1 << 3
            bullet3.physicsBody?.usesPreciseCollisionDetection = true
            bullet3.physicsBody?.isDynamic = true
            
            let bullet4 = SKShapeNode(ellipseOf: CGSize(width: 10, height: 10))
            bullet4.name = "e_bullets"
            //bullet.path = CGPath(rect: CGRect(x:-2, y:-4,width: 4,height: 8), transform: nil)
            bullet4.strokeColor = SKColor.black
            bullet4.fillColor = SKColor.green
            bullet4.position = pos
            bullet4.physicsBody = SKPhysicsBody(circleOfRadius: 6)
            bullet4.physicsBody?.categoryBitMask = 0x1 << 5 //enemy1 bullet
            bullet4.physicsBody?.contactTestBitMask = 0x1 << 3
            bullet4.physicsBody?.contactTestBitMask = 0x1 << 6
            bullet4.physicsBody?.collisionBitMask = 0x1 << 3
            bullet4.physicsBody?.usesPreciseCollisionDetection = true
            bullet4.physicsBody?.isDynamic = true
            
            let bullet5 = SKShapeNode(ellipseOf: CGSize(width: 10, height: 10))
            bullet5.name = "e_bullets"
            //bullet.path = CGPath(rect: CGRect(x:-2, y:-4,width: 4,height: 8), transform: nil)
            bullet5.strokeColor = SKColor.black
            bullet5.fillColor = SKColor.green
            bullet5.position = pos
            bullet5.physicsBody = SKPhysicsBody(circleOfRadius: 6)
            bullet5.physicsBody?.categoryBitMask = 0x1 << 5 //enemy1 bullet
            bullet5.physicsBody?.contactTestBitMask = 0x1 << 3
            bullet5.physicsBody?.contactTestBitMask = 0x1 << 6
            bullet5.physicsBody?.collisionBitMask = 0x1 << 3
            bullet5.physicsBody?.usesPreciseCollisionDetection = true
            bullet5.physicsBody?.isDynamic = true
            
            let X1_del = -885.0
            let Y1_del = -500.0
            let X2_del = -500.0
            let Y2_del = -885.0
            let X3_del = 0.0
            let Y3_del = -1000.0
            let X4_del = 500.0
            let Y4_del = -885.0
            let X5_del = 885.0
            let Y5_del = -500.0
            var vector = CGVector()
            vector.dx = CGFloat(1.5 * X1_del)
            vector.dy = CGFloat(1.5 * Y1_del)
            var vector2 = CGVector()
            vector2.dx = CGFloat(1.5 * X2_del)
            vector2.dy = CGFloat(1.5 * Y2_del)
            var vector3 = CGVector()
            vector3.dx = CGFloat(1.5 * X3_del)
            vector3.dy = CGFloat(1.5 * Y3_del)
            var vector4 = CGVector()
            vector4.dx = CGFloat(1.5 * X4_del)
            vector4.dy = CGFloat(1.5 * Y4_del)
            var vector5 = CGVector()
            vector5.dx = CGFloat(1.5 * X5_del)
            vector5.dy = CGFloat(1.5 * Y5_del)
            let move = SKAction.sequence([SKAction.move(by: vector, duration: 2),SKAction.removeFromParent()])
            bullet.run(SKAction.sequence([move]))
            let move2 = SKAction.sequence([SKAction.move(by: vector2, duration: 2),SKAction.removeFromParent()])
            bullet2.run(SKAction.sequence([move2]))
            let move3 = SKAction.sequence([SKAction.move(by: vector3, duration: 2),SKAction.removeFromParent()])
            bullet3.run(SKAction.sequence([move3]))
            let move4 = SKAction.sequence([SKAction.move(by: vector4, duration: 2),SKAction.removeFromParent()])
            bullet4.run(SKAction.sequence([move4]))
            let move5 = SKAction.sequence([SKAction.move(by: vector5, duration: 2),SKAction.removeFromParent()])
            bullet5.run(SKAction.sequence([move5]))
            
            self.addChild(bullet)
            self.addChild(bullet2)
            self.addChild(bullet3)
            self.addChild(bullet4)
            self.addChild(bullet5)
        }
    }
    func newDefend() ->SKSpriteNode {
        let protect = SKSpriteNode(imageNamed: "bubble.png")
        protect.name = "defends"
        protect.zPosition = 2
        protect.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        protect.physicsBody = SKPhysicsBody(circleOfRadius: 75, center: protect.anchorPoint)
        //protect.physicsBody = SKPhysicsBody(circleOfRadius: 75)
        protect.physicsBody?.isDynamic = false
        protect.physicsBody?.categoryBitMask = 0x1 << 6 //defend mask
        //protect.physicsBody?.contactTestBitMask = 0x1 << 2 // enemy1
        protect.physicsBody?.contactTestBitMask = 0x1 << 5 // enemy1 bullet
        protect.physicsBody?.usesPreciseCollisionDetection = true
        return protect
    }
    @objc func newBullet(){
        let bullet = SKShapeNode()
        bullet.name = "bullets"
        let pos = self.childNode(withName: "ships")!.position
        bullet.path = CGPath(rect: CGRect(x:-2, y:-4,width: 10,height: 15), transform: nil)
        bullet.strokeColor = SKColor.black
        bullet.fillColor = SKColor.yellow
        let remove = SKAction.sequence([SKAction.wait(forDuration: 3),SKAction.removeFromParent()])
        bullet.position = CGPoint(x: pos.x - 3, y: pos.y)
        let move = SKAction.moveBy(x: 0, y: 1000, duration: 2)
        bullet.run(SKAction.sequence([move,remove]))
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 6)
        bullet.physicsBody?.categoryBitMask = 0x1 << 1
        bullet.physicsBody?.contactTestBitMask = 0x1 << 2 | 7
        //bullet.physicsBody?.contactTestBitMask = 0x1 << 7
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.isDynamic = true
        self.addChild(bullet)
    }
    @objc func newRazer(){
        let bullet = SKShapeNode()
        bullet.name = "razer1"
        let pos = self.childNode(withName: "ships")!.position
        bullet.path = CGPath(rect: CGRect(x:-2, y:-4,width: 10,height: 150), transform: nil)
        bullet.strokeColor = SKColor.black
        bullet.fillColor = SKColor.yellow
        let remove = SKAction.sequence([SKAction.wait(forDuration: 3),SKAction.removeFromParent()])
        bullet.position = CGPoint(x: pos.x - 3, y: pos.y - 30)
        let move = SKAction.moveBy(x: 0, y: 1200, duration: 2)
        bullet.run(SKAction.sequence([move,remove]))
        bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 150))
        bullet.physicsBody?.categoryBitMask = 0x1 << 1
        bullet.physicsBody?.contactTestBitMask = 0x1 << 2 | 7
        //bullet.physicsBody?.contactTestBitMask = 0x1 << 7
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.isDynamic = true
        self.addChild(bullet)
    }
    @objc func newRazer2(){
        let bullet = SKShapeNode()
        bullet.name = "razer2"
        let pos = self.childNode(withName: "ships")!.position
        bullet.path = CGPath(rect: CGRect(x:-2, y:-4,width: 20,height: 150), transform: nil)
        bullet.strokeColor = SKColor.black
        bullet.fillColor = SKColor.yellow
        let remove = SKAction.sequence([SKAction.wait(forDuration: 3),SKAction.removeFromParent()])
        bullet.position = CGPoint(x: pos.x - 7, y: pos.y - 30)
        let move = SKAction.moveBy(x: 0, y: 1200, duration: 2)
        bullet.run(SKAction.sequence([move,remove]))
        bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 150))
        bullet.physicsBody?.categoryBitMask = 0x1 << 1
        bullet.physicsBody?.contactTestBitMask = 0x1 << 2 | 7
        //bullet.physicsBody?.contactTestBitMask = 0x1 << 7
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.isDynamic = true
        self.addChild(bullet)
    }
    @objc func newRazer3(){
        let bullet = SKShapeNode()
        bullet.name = "razer3"
        let pos = self.childNode(withName: "ships")!.position
        bullet.path = CGPath(rect: CGRect(x:-2, y:-4,width: 40,height: 150), transform: nil)
        bullet.strokeColor = SKColor.black
        bullet.fillColor = SKColor.yellow
        let remove = SKAction.sequence([SKAction.wait(forDuration: 3),SKAction.removeFromParent()])
        bullet.position = CGPoint(x: pos.x - 15, y: pos.y - 30)
        let move = SKAction.moveBy(x: 0, y: 1200, duration: 2)
        bullet.run(SKAction.sequence([move,remove]))
        //SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 15))
        //SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 15),center: CGPoint(x: pos.x + 20, y: pos.y + 75))
        bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 150))
        bullet.physicsBody?.categoryBitMask = 0x1 << 1
        bullet.physicsBody?.contactTestBitMask = 0x1 << 2 | 7
        //bullet.physicsBody?.contactTestBitMask = 0x1 << 7
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.isDynamic = true
        self.addChild(bullet)
    }
    @objc func newBullet2(){
        let bullet = SKShapeNode()
        bullet.name = "bullets"
        var pos = self.childNode(withName: "ships")!.position
        pos.x -= 10.0
        bullet.path = CGPath(rect: CGRect(x:-2, y:-4,width: 10,height: 15), transform: nil)
        bullet.strokeColor = SKColor.black
        bullet.fillColor = SKColor.yellow
        let remove = SKAction.sequence([SKAction.wait(forDuration: 3),SKAction.removeFromParent()])
        bullet.position = pos
        let move = SKAction.moveBy(x: 0, y: 1000, duration: 2)
        bullet.run(SKAction.sequence([move,remove]))
        bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 15),center: CGPoint(x: pos.x + 20, y: pos.y + 75))
        bullet.physicsBody?.categoryBitMask = 0x1 << 1
        bullet.physicsBody?.contactTestBitMask = 0x1 << 2 | 7
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.isDynamic = true
        
        let bullet2 = SKShapeNode()
        bullet2.name = "bullets"
        var pos2 = self.childNode(withName: "ships")!.position
        pos2.x += 10.0
        bullet2.path = CGPath(rect: CGRect(x:-2, y:-4,width: 10,height: 15), transform: nil)
        bullet2.strokeColor = SKColor.black
        bullet2.fillColor = SKColor.yellow
        bullet2.position = pos2
        bullet2.run(SKAction.sequence([move,remove]))
        bullet2.physicsBody = SKPhysicsBody(circleOfRadius: 6)
        bullet2.physicsBody?.categoryBitMask = 0x1 << 1
        bullet2.physicsBody?.contactTestBitMask = 0x1 << 2 | 7
        bullet2.physicsBody?.collisionBitMask = 0
        bullet2.physicsBody?.usesPreciseCollisionDetection = true
        bullet2.physicsBody?.isDynamic = true
        self.addChild(bullet)
        self.addChild(bullet2)
    }
    @objc func newBullet3(){
        let bullet = SKShapeNode()
        bullet.name = "bullets"
        let pos = self.childNode(withName: "ships")!.position
        bullet.path = CGPath(rect: CGRect(x:-2, y:-4,width: 10,height: 15), transform: nil)
        bullet.strokeColor = SKColor.black
        bullet.fillColor = SKColor.yellow
        bullet.position = pos
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 6)
        bullet.physicsBody?.categoryBitMask = 0x1 << 1
        bullet.physicsBody?.contactTestBitMask = 0x1 << 2 | 7
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.isDynamic = true
        
        let bullet2 = SKShapeNode()
        bullet2.name = "bullets"
        bullet2.path = CGPath(rect: CGRect(x:-2, y:-4,width: 10,height: 15), transform: nil)
        bullet2.strokeColor = SKColor.black
        bullet2.fillColor = SKColor.yellow
        bullet2.position = pos
        bullet2.physicsBody = SKPhysicsBody(circleOfRadius: 6)
        bullet2.physicsBody?.categoryBitMask = 0x1 << 1
        bullet2.physicsBody?.contactTestBitMask = 0x1 << 2 | 7
        bullet2.physicsBody?.collisionBitMask = 0
        bullet2.physicsBody?.usesPreciseCollisionDetection = true
        bullet2.physicsBody?.isDynamic = true
        
        let bullet3 = SKShapeNode()
        bullet3.name = "bullets"
        bullet3.path = CGPath(rect: CGRect(x:-2, y:-4,width: 10,height: 15), transform: nil)
        bullet3.strokeColor = SKColor.black
        bullet3.fillColor = SKColor.yellow
        bullet3.position = pos
        bullet3.physicsBody = SKPhysicsBody(circleOfRadius: 6)
        bullet3.physicsBody?.categoryBitMask = 0x1 << 1
        bullet3.physicsBody?.contactTestBitMask = 0x1 << 2 | 7
        bullet3.physicsBody?.collisionBitMask = 0
        bullet3.physicsBody?.usesPreciseCollisionDetection = true
        bullet3.physicsBody?.isDynamic = true
        
        let bullet4 = SKShapeNode()
        bullet4.name = "bullets"
        bullet4.path = CGPath(rect: CGRect(x:-2, y:-4,width: 10,height: 15), transform: nil)
        bullet4.strokeColor = SKColor.black
        bullet4.fillColor = SKColor.yellow
        bullet4.position = pos
        bullet4.physicsBody = SKPhysicsBody(circleOfRadius: 6)
        bullet4.physicsBody?.categoryBitMask = 0x1 << 1
        bullet4.physicsBody?.contactTestBitMask = 0x1 << 2 | 7
        bullet4.physicsBody?.collisionBitMask = 0
        bullet4.physicsBody?.usesPreciseCollisionDetection = true
        bullet4.physicsBody?.isDynamic = true
        
        let X1_del = -150.0
        let Y1_del = 900.0
        let X2_del = -500.0
        let Y2_del = 885.0
        let X3_del = 150.0
        let Y3_del = 900.0
        let X4_del = 500.0
        let Y4_del = 885.0
        var vector = CGVector()
        vector.dx = CGFloat(1.5 * X1_del)
        vector.dy = CGFloat(1.5 * Y1_del)
        var vector2 = CGVector()
        vector2.dx = CGFloat(1.5 * X2_del)
        vector2.dy = CGFloat(1.5 * Y2_del)
        var vector3 = CGVector()
        vector3.dx = CGFloat(1.5 * X3_del)
        vector3.dy = CGFloat(1.5 * Y3_del)
        var vector4 = CGVector()
        vector4.dx = CGFloat(1.5 * X4_del)
        vector4.dy = CGFloat(1.5 * Y4_del)
        
        let move = SKAction.sequence([SKAction.move(by: vector, duration: 2),SKAction.removeFromParent()])
        bullet.run(SKAction.sequence([move]))
        let move2 = SKAction.sequence([SKAction.move(by: vector2, duration: 2),SKAction.removeFromParent()])
        bullet2.run(SKAction.sequence([move2]))
        let move3 = SKAction.sequence([SKAction.move(by: vector3, duration: 2),SKAction.removeFromParent()])
        bullet3.run(SKAction.sequence([move3]))
        let move4 = SKAction.sequence([SKAction.move(by: vector4, duration: 2),SKAction.removeFromParent()])
        bullet4.run(SKAction.sequence([move4]))
        self.addChild(bullet)
        self.addChild(bullet2)
        self.addChild(bullet3)
        self.addChild(bullet4)
    }
    @objc func newBoss(){
        //e1_timer?.invalidate()
        e2_timer?.invalidate()
        let boss = SKSpriteNode(imageNamed: "boss.png")
        boss.size = CGSize(width: 400, height: 400)
        let w = self.size.width / 2
        let h = self.size.height + 100
        boss.position = CGPoint(x: w, y: h)
        boss.run(SKAction.moveBy(x: 0, y: -250, duration: 3))
        boss.name = "boss"
        boss.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        boss.physicsBody?.usesPreciseCollisionDetection = true
        boss.physicsBody?.isDynamic = false
        boss.physicsBody?.affectedByGravity = false
        
        boss.physicsBody?.categoryBitMask = 0x1 << 2//enemy
        boss.physicsBody?.contactTestBitMask = 0x1 << 1 | 3 | 6
        //e1.physicsBody?.contactTestBitMask = 0x1 << 3
        //e1.physicsBody?.contactTestBitMask = 0x1 << 6
        boss.physicsBody?.collisionBitMask = 0x1 << 1
        let movedown = SKAction.moveBy(x: 0, y: -200, duration: 2)
        let wait = SKAction.wait(forDuration: 5)
        let moveup = SKAction.moveBy(x: 0, y: 200, duration: 2)
        boss.run(SKAction.sequence([wait,movedown,wait,moveup,wait,movedown,wait,moveup,wait,movedown,wait,moveup,wait,movedown,wait,moveup,wait,movedown,wait,moveup,wait,movedown,wait,moveup,wait]))
        self.boss_atk1_timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(newBossBullet), userInfo: nil, repeats: true)
        self.boss_atk2_timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(newBossBullet2), userInfo: nil, repeats: true)
        self.addChild(boss)
    }
    @objc func newEnemy1() {
        let e1 = SKSpriteNode(imageNamed: "enemy1.png")
        
        e1.size = CGSize(width: 80, height: 80)
        let wait = SKAction.wait(forDuration: 5)
        let remove = SKAction.removeFromParent()
        let w = self.size.width
        let h = self.size.height
        let x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w)
        e1.position = CGPoint(x: x, y: h)
        e1.name = "enemy"
        e1.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        e1.physicsBody?.usesPreciseCollisionDetection = true
        e1.physicsBody?.isDynamic = false
        e1.physicsBody?.affectedByGravity = false
        
        e1.physicsBody?.categoryBitMask = 0x1 << 2//2是最弱的敵機
        e1.physicsBody?.contactTestBitMask = 0x1 << 1 | 3 | 6
        //e1.physicsBody?.contactTestBitMask = 0x1 << 3
        //e1.physicsBody?.contactTestBitMask = 0x1 << 6
        e1.physicsBody?.collisionBitMask = 0x1 << 1
        let movedown = SKAction.moveBy(x: 0, y: -50, duration: 0.25)
        let moveup = SKAction.moveBy(x: 0, y: 100, duration: 0.5)
        e1.run(SKAction.sequence([movedown,wait,moveup,remove]))
        self.addChild(e1)
    }
    @objc func newEnemy2() {
        let e1 = SKSpriteNode(imageNamed: "enemy2.png")
        
        e1.size = CGSize(width: 240, height: 240)
        let remove = SKAction.removeFromParent()
        let w = self.size.width
        let h = self.size.height
        let x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w)
        e1.position = CGPoint(x: x, y: h)
        e1.name = "enemy2"
        e1.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        e1.physicsBody?.usesPreciseCollisionDetection = true
        e1.physicsBody?.isDynamic = false
        
        e1.physicsBody?.categoryBitMask = 0x1 << 7//7是大隻的敵機
        e1.physicsBody?.contactTestBitMask = 0x1 << 1 | 3
        //e1.physicsBody?.contactTestBitMask = 0x1 << 3
        //e1.physicsBody?.contactTestBitMask = 0x1 << 6
        e1.physicsBody?.collisionBitMask = 0x1 << 1
        let movedown = SKAction.moveBy(x: 0, y: -1300, duration: 20)
        e1.run(SKAction.sequence([movedown,remove]))
        self.addChild(e1)
    }
    @objc func newAmmo() {
        let coin = SKSpriteNode(imageNamed: "bullet.png")
        coin.size = CGSize(width: 40, height: 40)
        let remove = SKAction.sequence([SKAction.wait(forDuration: 3),SKAction.removeFromParent()])
        let w = self.size.width
        let h = self.size.height
        let x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w)
        coin.position = CGPoint(x: x, y: h)
        coin.name = "ammos"
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
    @objc func newTypeChange() {
        let coin = SKSpriteNode(imageNamed: "razer.png")
        coin.size = CGSize(width: 40, height: 40)
        let remove = SKAction.sequence([SKAction.wait(forDuration: 3),SKAction.removeFromParent()])
        let w = self.size.width
        let h = self.size.height
        let x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w)
        coin.position = CGPoint(x: x, y: h)
        coin.name = "ammos2"
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
    @objc func EnemyUp() {
        self.e1_atk_timer?.invalidate()
        self.e1_atk_timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(newEnemyBullet), userInfo: nil, repeats: true)
        self.e2_atk_timer?.invalidate()
        self.e2_atk_timer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(newEnemy2Bullet), userInfo: nil, repeats: true)
        self.e1_timer?.invalidate()
        self.e1_timer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(newEnemy1), userInfo: nil, repeats: true)
    }
    @objc func handpan(recognizer: UIPanGestureRecognizer){
        let viewLocation = recognizer.location(in: view)
        let sceneLocation = convertPoint(fromView: viewLocation)
        let moveAction = SKAction.move(to: sceneLocation, duration: 0.05)
        self.childNode(withName: "ships")!.run(moveAction)
    }
    func alert(){
        let alertcontroller = UIAlertController(title: "You lose !!", message: "Score:\(numScore)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertcontroller.addAction(action)
        view?.window?.rootViewController?.present(alertcontroller, animated: true)
    }
    func alert_win(){
        let alertcontroller = UIAlertController(title: "You Win !!", message: "Score:\(numScore)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertcontroller.addAction(action)
        view?.window?.rootViewController?.present(alertcontroller, animated: true)
    }
    @objc func warning(){
        let warning = SKSpriteNode(imageNamed: "warning.png")
        warning.name = "warning"
        warning.size = CGSize(width: 400, height: 80)
        warning.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        warning.zPosition = 20
        let blink = SKAction.sequence([SKAction.fadeOut(withDuration: 0.5),SKAction.fadeIn(withDuration: 0.5)])
        //let blinkForever = SKAction.repeatForever(blink)
        let remove = SKAction.removeFromParent()
        warning.run(SKAction.sequence([blink,blink,blink,remove]))
        self.addChild(warning)
    }
    func win(){
        e1_timer?.invalidate()
        self.enumerateChildNodes(withName: "enemy"){
        node, _ in
            node.removeFromParent()
        }
        self.enumerateChildNodes(withName: "enemy2"){
        node, _ in
            node.removeFromParent()
        }
        self.run(SKAction.wait(forDuration: 3))
        self.alpha =  0.85
        self.isPaused = true
        let win = SKSpriteNode(imageNamed: "win.png")
        win.name = "win"
        win.size = CGSize(width: 400, height: 80)
        win.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        win.zPosition = 20
        self.addChild(win)
        alert_win()
        press_restart()
    }
    func dead(){
        let overlabel = SKSpriteNode(imageNamed: "gameover.png")
        overlabel.name = "gameover"
        overlabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)
        overlabel.size = CGSize(width: 300, height: 75)
        overlabel.zPosition = 10
        self.addChild(overlabel)
    }
    func press_restart(){
        let re_label = SKSpriteNode(imageNamed: "restart.png")
        re_label.name = "restart"
        re_label.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        re_label.size = CGSize(width: 350, height: 35)
        re_label.zPosition = 10
        //let wait = SKAction.wait(forDuration: 0.01)
        
        self.addChild(re_label)
    }
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        //first body 是太空船
        if contact.bodyA.node?.name == "ships"{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else if contact.bodyA.node?.name == "bullets"{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else if contact.bodyB.node?.name == "ships"{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }else if contact.bodyB.node?.name == "bullets"{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }else if contact.bodyA.node?.name == "e_bullets"{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }else if contact.bodyB.node?.name == "e_bullets"{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else if contact.bodyB.node?.name == "defends"{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }else if contact.bodyA.node?.name == "defends"{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else if contact.bodyA.node?.name == "razer1"{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else if contact.bodyB.node?.name == "razer1"{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }else if contact.bodyA.node?.name == "razer2"{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else if contact.bodyB.node?.name == "razer2"{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }else if contact.bodyA.node?.name == "razer3"{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else if contact.bodyB.node?.name == "razer3"{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if (firstBody.node?.name == "ships" && secondBody.node?.name == "enemy"){
            
            contact.bodyB.node?.removeFromParent()
            mylife = mylife - 1
            setLife()
            if(mylife == 0)
            {
                self.alpha =  0.85
                self.isPaused = true
                alert()
                dead()
                press_restart()
            }
            else{
                contact.bodyA.node?.removeFromParent()
                let wait = SKAction.wait(forDuration: 1)
                let wait_3sec = SKAction.wait(forDuration: 3)
                self.run(wait)
                //重生
                let spaceship = newSpaceship()
                let protect = newDefend()
                let defend = SKAction.sequence([wait_3sec,SKAction.removeFromParent()])
                protect.run(defend)
                spaceship.addChild(protect)
                spaceship.position = CGPoint(x: self.frame.midX, y: self.frame.midY-300)
                let moveup = SKAction.moveBy(x: 0, y: 100, duration: 0.3)
                let blink = SKAction.sequence([SKAction.fadeOut(withDuration: 0.25),SKAction.fadeIn(withDuration: 0.25)])
                spaceship.run(moveup)
                spaceship.run(SKAction.sequence([blink,blink,blink,blink,blink,blink]))
                self.addChild(spaceship)
            }
        }else if (firstBody.node?.name == "ships" && secondBody.node?.name == "enemy2"){
            mylife = mylife - 1
            setLife()
            if(mylife == 0)
            {
                self.alpha =  0.85
                self.isPaused = true
                alert()
                dead()
                press_restart()
            }
            else{
                contact.bodyA.node?.removeFromParent()
                let wait = SKAction.wait(forDuration: 1)
                let wait_3sec = SKAction.wait(forDuration: 3)
                self.run(wait)
                //重生
                let spaceship = newSpaceship()
                let protect = newDefend()
                let defend = SKAction.sequence([wait_3sec,SKAction.removeFromParent()])
                protect.run(defend)
                spaceship.addChild(protect)
                spaceship.position = CGPoint(x: self.frame.midX, y: self.frame.midY-300)
                let moveup = SKAction.moveBy(x: 0, y: 100, duration: 0.3)
                let blink = SKAction.sequence([SKAction.fadeOut(withDuration: 0.25),SKAction.fadeIn(withDuration: 0.25)])
                spaceship.run(moveup)
                spaceship.run(SKAction.sequence([blink,blink,blink,blink,blink,blink]))
                self.addChild(spaceship)
            }
        }
        else if (firstBody.node?.name == "ships" && secondBody.node?.name == "ammos"){
            contact.bodyB.node?.removeFromParent()
            if (weapon_level < 3){
                weapon_level += 1
            }
            switch weapon_level{
            case 1:
                if(weapon_kind == 1){
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(newRazer), userInfo: nil, repeats: true)
                }else if (weapon_kind == 0){
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(newBullet), userInfo: nil, repeats: true)
                }
            case 2:
                if (weapon_kind == 1){
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(newRazer2), userInfo: nil, repeats: true)
                }else if (weapon_kind == 0){
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(newBullet2), userInfo: nil, repeats: true)
                }
            case 3:
                if(weapon_kind == 1){
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(newRazer3), userInfo: nil, repeats: true)
                }else if (weapon_kind == 0){
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(newBullet3), userInfo: nil, repeats: true)
                }
            default:
                self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(newBullet), userInfo: nil, repeats: true)
            }
            numScore += 100
            setScore()
        }else if (firstBody.node?.name == "ships" && secondBody.node?.name == "ammos2"){
            contact.bodyB.node?.removeFromParent()
            if (weapon_kind == 0){
                weapon_kind = 1
            }else{
                weapon_kind = 0
            }
            switch weapon_kind{
            case 0:
                if(weapon_level == 1){
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(newBullet), userInfo: nil, repeats: true)
                }else if (weapon_level == 2){
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(newBullet2), userInfo: nil, repeats: true)
                }else if (weapon_level == 3){
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(newBullet3), userInfo: nil, repeats: true)
                }
            case 1:
                if(weapon_level == 1){
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(newRazer), userInfo: nil, repeats: true)
                }else if (weapon_level == 2){
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(newRazer2), userInfo: nil, repeats: true)
                }else if (weapon_level == 3){
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(newRazer3), userInfo: nil, repeats: true)
                }
            default:
                break
            }
            numScore += 100
            setScore()
        }else if (firstBody.node?.name == "bullets" && secondBody.node?.name == "enemy")
        {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            numScore += 20
            setScore()
        }else if (firstBody.node?.name == "bullets" && secondBody.node?.name == "enemy2")
        {
            if contact.bodyA.node?.name == "bullets" {
                contact.bodyA.node?.removeFromParent()
            }
            else{
                contact.bodyB.node?.removeFromParent()
            }
            enemy_life = enemy_life-1
            if (enemy_life == 0)
            {
                secondBody.node?.removeFromParent()
                enemy_life = 10
                //contact.bodyB.node?.removeFromParent()
                numScore += 300
                setScore()
            }
            numScore += 20
            setScore()
        }else if (firstBody.node?.name == "bullets" && secondBody.node?.name == "boss")
        {
            if contact.bodyA.node?.name == "bullets" {
                contact.bodyA.node?.removeFromParent()
            }
            else{
                contact.bodyB.node?.removeFromParent()
            }
            boss_life = boss_life-1
            if (boss_life <= 0)
            {
                secondBody.node?.removeFromParent()
                //contact.bodyB.node?.removeFromParent()
                numScore += 3000
                setScore()
                win()
            }
            numScore += 20
            setScore()
        }else if (firstBody.node?.name == "razer1" && secondBody.node?.name == "boss")
        {
            if contact.bodyA.node?.name == "razer1" {
                contact.bodyA.node?.removeFromParent()
            }
            else{
                contact.bodyB.node?.removeFromParent()
            }
            boss_life = boss_life-2
            if (boss_life <= 0)
            {
                secondBody.node?.removeFromParent()
                //contact.bodyB.node?.removeFromParent()
                numScore += 3000
                //win scene
                setScore()
                win()
            }
            numScore += 20
            setScore()
        }else if (firstBody.node?.name == "razer2" && secondBody.node?.name == "boss")
        {
            if contact.bodyA.node?.name == "razer2" {
                contact.bodyA.node?.removeFromParent()
            }
            else{
                contact.bodyB.node?.removeFromParent()
            }
            boss_life = boss_life-4
            if (boss_life <= 0)
            {
                secondBody.node?.removeFromParent()
                //contact.bodyB.node?.removeFromParent()
                numScore += 3000
                //win scene
                setScore()
                win()
            }
            numScore += 20
            setScore()
        }else if (firstBody.node?.name == "razer3" && secondBody.node?.name == "boss")
        {
            if contact.bodyA.node?.name == "razer3" {
                contact.bodyA.node?.removeFromParent()
            }
            else{
                contact.bodyB.node?.removeFromParent()
            }
            boss_life = boss_life - 6
            if (boss_life <= 0)
            {
                secondBody.node?.removeFromParent()
                //contact.bodyB.node?.removeFromParent()
                numScore += 3000
                //win scene
                setScore()
                win()
            }
            numScore += 20
            setScore()
        }else if (firstBody.node?.name == "razer1" && secondBody.node?.name == "enemy")
        {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            numScore += 20
            setScore()
        }else if (firstBody.node?.name == "razer1" && secondBody.node?.name == "enemy2")
        {
            if contact.bodyA.node?.name == "razer1" {
                contact.bodyA.node?.removeFromParent()
            }
            else{
                contact.bodyB.node?.removeFromParent()
            }
            enemy_life = enemy_life-2
            if (enemy_life <= 0)
            {
                secondBody.node?.removeFromParent()
                enemy_life = 10
                //contact.bodyB.node?.removeFromParent()
                numScore += 300
                setScore()
            }
            numScore += 20
            setScore()
        }else if (firstBody.node?.name == "razer2" && secondBody.node?.name == "enemy")
        {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            numScore += 20
            setScore()
        }else if (firstBody.node?.name == "razer2" && secondBody.node?.name == "enemy2")
        {
            if contact.bodyA.node?.name == "razer2" {
                contact.bodyA.node?.removeFromParent()
            }
            else{
                contact.bodyB.node?.removeFromParent()
            }
            enemy_life = enemy_life-4
            if (enemy_life <= 0)
            {
                secondBody.node?.removeFromParent()
                enemy_life = 10
                //contact.bodyB.node?.removeFromParent()
                numScore += 300
                setScore()
            }
            numScore += 20
            setScore()
        }else if (firstBody.node?.name == "razer3" && secondBody.node?.name == "enemy")
        {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            numScore += 20
            setScore()
        }else if (firstBody.node?.name == "razer3" && secondBody.node?.name == "enemy2")
        {
            if contact.bodyA.node?.name == "razer3" {
                contact.bodyA.node?.removeFromParent()
            }
            else{
                contact.bodyB.node?.removeFromParent()
            }
            enemy_life = enemy_life-6
            if (enemy_life <= 0)
            {
                secondBody.node?.removeFromParent()
                enemy_life = 10
                //contact.bodyB.node?.removeFromParent()
                numScore += 300
                setScore()
            }
            numScore += 20
            setScore()
        }
        else if (firstBody.node?.name == "defends" && secondBody.node?.name == "enemy" || firstBody.node?.name == "defends" && secondBody.node?.name == "e_bullets")
        {
            if contact.bodyA.node?.name == "defends" {
                contact.bodyB.node?.removeFromParent()
            }else{
                contact.bodyA.node?.removeFromParent()
            }
            
        }else if (firstBody.node?.name == "ships" && secondBody.node?.name == "e_bullets")
        {
            contact.bodyB.node?.removeFromParent()
            mylife = mylife - 1
            setLife()
            if(mylife == 0)
            {
                self.alpha =  0.85
                self.isPaused = true
                alert()
                dead()
                press_restart()
            }
            else{
                contact.bodyA.node?.removeFromParent()
                let wait = SKAction.wait(forDuration: 1)
                let wait_3sec = SKAction.wait(forDuration: 3)
                self.run(wait)
                //重生
                let spaceship = newSpaceship()
                let protect = newDefend()
                let defend = SKAction.sequence([wait_3sec,SKAction.removeFromParent()])
                protect.run(defend)
                spaceship.addChild(protect)
                spaceship.position = CGPoint(x: self.frame.midX, y: self.frame.midY-300)
                let moveup = SKAction.moveBy(x: 0, y: 100, duration: 0.3)
                let blink = SKAction.sequence([SKAction.fadeOut(withDuration: 0.25),SKAction.fadeIn(withDuration: 0.25)])
                spaceship.run(moveup)
                spaceship.run(SKAction.sequence([blink,blink,blink,blink,blink,blink]))
                self.addChild(spaceship)
            }
        }
    }
}
