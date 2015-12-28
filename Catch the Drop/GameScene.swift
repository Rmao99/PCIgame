//
//  GameScene.swift
//  Catch the Drop
//
//  Created by Richard and Smayra on 12/6/15.
//  Copyright (c) 2015 Project Concern International. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var player = SKSpriteNode(imageNamed: "person1.png")
  
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        player.position = CGPointMake(self.size.width/2, self.size.height/5)
        //selector: what function it calls every second
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("spawnDrop"), userInfo: nil, repeats: true)
        
        var EnemyTime = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("spawnEnemies"), userInfo: nil, repeats: true)
        self.addChild(player)
        
        }
    
    func spawnDrop(){
        
        var drop = SKSpriteNode(imageNamed: "wuterdrip.png")
        drop.zPosition = -5
        drop.position = CGPointMake(player.position.x, player.position.y)
        let action = SKAction.moveToY(self.size.height + 30, duration: 1.0)
        drop.runAction(SKAction.repeatActionForever(action))
        self.addChild(drop)
        
    }
    
    func spawnEnemies(){
        var enemy = SKSpriteNode(imageNamed: "wuterdrip.png")
        var minValue = self.size.width/8
        var maxValue = self.size.width - 20
        
        var spawnPoint = UInt32(maxValue - minValue)
        enemy.position = CGPoint(x: CGFloat(arc4random_uniform(spawnPoint)), y: self.size.height)
        
        let action = SKAction.moveToY(-30, duration: 3.0)
        enemy.runAction(SKAction.repeatActionForever(action))
        self.addChild(enemy)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            player.position.x = location.x;
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
