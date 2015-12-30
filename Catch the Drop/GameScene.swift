//
//  GameScene.swift
//  Catch the Drop
//
//  Created by Richard and Smayra on 12/6/15.
//  Copyright (c) 2015 Project Concern International. All rights reserved.
//

import SpriteKit

struct PhysicsCategory{
    static let drop : UInt32 = 1 //000...(32)1
    //static let bullet : UInt32 = 2
    static let player : UInt32 = 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player = SKSpriteNode(imageNamed: "person1.png")
    var score = Int()
    var scoreLabel = UILabel()
        
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        physicsWorld.contactDelegate = self //CRUCIAL
        
        player.position = CGPointMake(self.size.width/2, self.size.height/5)
        
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.drop //triggers didBeginContact
        player.physicsBody?.dynamic = false
        
        //selector: what function it calls every second
        /*var timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("spawnDrop"), userInfo: nil, repeats: true)*/
        
        var DropTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("spawnDrop"), userInfo: nil, repeats: true)
        self.addChild(player)
        
        scoreLabel.text = "\(score)"
        scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100,height: 20))
        scoreLabel.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.3)
        scoreLabel.textColor = UIColor.whiteColor()
        
        self.view?.addSubview(scoreLabel)
        
        
        }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody : SKPhysicsBody = contact.bodyA   //contact is passed from parameter and
        var secondBody : SKPhysicsBody = contact.bodyB  // A and B is the two objects
        
        if((firstBody.contactTestBitMask == PhysicsCategory.drop) &&
           (secondBody.contactTestBitMask == PhysicsCategory.player) ||
           (firstBody.contactTestBitMask == PhysicsCategory.player) &&
           (secondBody.contactTestBitMask == PhysicsCategory.drop))
        {
            collideWithPlayer(firstBody.node as! SKSpriteNode, player: secondBody.node as! SKSpriteNode )
        }
    }
    
    func collideWithPlayer(drop: SKSpriteNode, player: SKSpriteNode)
    {
        //drop.removeFromParent()
       
        score++
        
        scoreLabel.text = "\(score)"
        //can add sounds when collide
    }
    
    
    /*func spawnDrop(){
        
        var drop = SKSpriteNode(imageNamed: "wuterdrip.png")
        drop.zPosition = -5
        drop.position = CGPointMake(player.position.x, player.position.y)
        let action = SKAction.moveToY(self.size.height + 30, duration: 1.0)
        drop.runAction(SKAction.repeatActionForever(action))
        self.addChild(drop)
        
    }*/
    
    func spawnDrop(){
        var drop = SKSpriteNode(imageNamed: "wuterdrip.png")
        var minValue = self.size.width/8
        var maxValue = self.size.width - 20
        
        var spawnPoint = UInt32(maxValue - minValue)
        
        drop.position = CGPoint(x: CGFloat(arc4random_uniform(spawnPoint)), y: self.size.height)
        drop.physicsBody = SKPhysicsBody(rectangleOfSize: drop.size)
        drop.physicsBody?.categoryBitMask = PhysicsCategory.drop
        drop.physicsBody?.contactTestBitMask = PhysicsCategory.player
        drop.physicsBody?.affectedByGravity = false
        drop.physicsBody?.dynamic = true
        
        let action = SKAction.moveToY(-70, duration: 3.0)
        let actionDone = SKAction.removeFromParent()
        drop.runAction(SKAction.sequence([action, actionDone]))
        self.addChild(drop)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            player.position.x = location.x
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            player.position.x = location.x;

        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
