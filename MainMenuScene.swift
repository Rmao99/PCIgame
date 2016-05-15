//
//  MainMenuScene.swift
//  Catch the Drop
//
//  Created by Callie on 5/15/16.
//  Copyright © 2016 Project Concern International. All rights reserved.
//

import SpriteKit

class MainMenuScene : SKScene
{
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.brownColor()
        
        let viewSize:CGSize = view.bounds.size
        
        let BG = SKSpriteNode(imageNamed: "BG")
        BG.position = CGPoint(x: viewSize.width/2, y: viewSize.height/2)
        
        let myLabel = SKLabelNode(fontNamed: "Chalkduster")
        myLabel.text = "Game"
        myLabel.fontSize = 65
        myLabel.position = CGPoint(x: viewSize.width/2, y: viewSize.height * 0.8)
        
        let playBtn = SKSpriteNode(imageNamed: "playBtn")
        playBtn.position = CGPoint(x: viewSize.width/2, y: viewSize.height/2)
        
        
        self.addChild(playBtn)
        self.addChild(myLabel)
        self.addChild(BG)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
        }
    }
}
