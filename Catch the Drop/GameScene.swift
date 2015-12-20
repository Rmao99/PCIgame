//
//  GameScene.swift
//  Catch the Drop
//
//  Created by Siddhi on 12/6/15.
//  Copyright (c) 2015 Project Concern International. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var player = SKSpriteNode(imageNamed: "person1.png")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        player.position = CGPointMake(self.size.width/2, self.size.height/5)
        self.addChild(player)
        }
    
    func SpawnDrop(){
        
        var drop = SKSpriteNode(imageNamed: "wuterdrip.png")
        drop.zPosition = -5
        drop.position = CGPointMake(player.position.x, player.position.y)
        self.addChild(drop)
        
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
