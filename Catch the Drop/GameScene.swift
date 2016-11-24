//
//  MainMenuScene.swift
//  Catch the Drop
//
//  Created by Callie on 5/15/16.
//  Copyright © 2016 Project Concern International. All rights reserved.
//

import SpriteKit

class GameScene : SKScene
{
    var playBtn: SKNode! = nil
    
    override func didMoveToView(view: SKView) {
        
        let viewSize:CGSize = view.bounds.size
        
        let BG = SKSpriteNode(imageNamed: "BG")
        BG.position = CGPoint(x: viewSize.width/2+50, y: viewSize.height/2)
        BG.zPosition = 0
        
        BG.size.height = viewSize.height
        BG.size.width = viewSize.width + 100
        
        let myLabel = SKLabelNode(fontNamed: "Chalkduster")
        myLabel.fontColor = UIColor.blackColor()
        myLabel.text = "Catch The Drop"
        myLabel.fontSize = 35
        myLabel.position = CGPoint(x: viewSize.width/2, y: viewSize.height * 0.8)
        myLabel.zPosition = 1
        
        playBtn = SKSpriteNode(imageNamed: "playBtn")
        playBtn.position = CGPoint(x: viewSize.width/2, y: viewSize.height/2)
        playBtn.name = "playBtn"
        playBtn.zPosition = 1
        
        
        self.addChild(myLabel)
        self.addChild(BG)
        self.addChild(playBtn)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            
            //let node:SKNode = self.nodeAtPoint(location)
            
            if(playBtn.containsPoint(location))
            {
                let scene = GamePlayScene(size: view!.bounds.size)
                
                // Configure the view.
                
                let skView = self.view! as SKView
                
                
                skView.showsFPS = true
                skView.showsNodeCount = true
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = false
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .ResizeFill
                
                scene.size = skView.bounds.size
                skView.presentScene(scene)
                //self.view?.presentScene(scene)
            }
        }
    }
}
