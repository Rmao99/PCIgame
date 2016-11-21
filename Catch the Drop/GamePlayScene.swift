//
//  GameScene.swift
//  Catch the Drop
//
//  Created by Richard and Smayra on 12/6/15.
//  Copyright (c) 2015 Project Concern International. All rights reserved.
//

import SpriteKit
import AVFoundation

struct PhysicsCategory{
    static let drop : UInt32 = 1 //000...(32)1
    static let bottom : UInt32 = 2
    static let player : UInt32 = 3
}

class GamePlayScene: SKScene, SKPhysicsContactDelegate {
    
    var highScore = Int()
    var player = SKSpriteNode(imageNamed: "walk 4 water (3).png")
    var score = 0
    var scoreLabel = UILabel()
    var soundPlayer = AVAudioPlayer()
    //var splash = AVAudioPlayer()
    let splash = SKAction.playSoundFileNamed("Water-splash-sound-effect.mp3", waitForCompletion: false)
    var MULTIPLIER = 1.0;
    var isDone = false
    var isGamePaused = false
    var DropTimer = NSTimer()
    
    var pauseBtn : UIButton!
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer{
        
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String) //needs to find where the soundfile is
        let url = NSURL.fileURLWithPath(path!) //converts to url
        
        var audioPlayer:AVAudioPlayer? //optional AVAudioPlayer incase it isn't created
        
        do{
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        }
        catch{
            print("Player not available")
        }
        
        return audioPlayer!
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        player.xScale = 0.1
        player.yScale = 0.1
        
        let backgroundMusic = self.setupAudioPlayerWithFile("Rain-background", type: "mp3")
        soundPlayer = backgroundMusic
        soundPlayer.volume = 0.3
        soundPlayer.numberOfLoops = -1
        soundPlayer.play();
        
 //       let splashSound = self.setupAudioPlayerWithFile("Water-splash-sound-effect", type: "mp3")
 //       splash = splashSound;
        
        var highScoreDefault = NSUserDefaults.standardUserDefaults()
        
        if(highScoreDefault.valueForKey("HighScore") == nil){
            highScore = 0;
        }
        else{
            highScore = highScoreDefault.valueForKey("HighScore") as! NSInteger
        }
        
        physicsWorld.contactDelegate = self //CRUCIAL
        
        pauseBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        pauseBtn.center = CGPoint(x: view.frame.size.width - 100 , y: view.frame.size.width / 2)
        pauseBtn.setTitle("Pause", forState: UIControlState.Normal) //text says "Main Menu" when nothing is pressed
        pauseBtn.backgroundColor = UIColor.clearColor()
        pauseBtn.layer.cornerRadius = 10
        pauseBtn.layer.borderWidth = 1
        pauseBtn.layer.borderColor = UIColor.blackColor().CGColor
        pauseBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        pauseBtn.addTarget(self, action: Selector("pauseClick"), forControlEvents: UIControlEvents.TouchDown)
        self.view?.addSubview(pauseBtn);

        
        self.scene?.backgroundColor = UIColor.darkGrayColor()
        //TODO: WHAT DO I DOOOOOO
        self.scene?.size = CGSize(width: 640, height: 1136)
        
        self.addChild(SKEmitterNode(fileNamed: "RainParticle")!)
        
        player.position = CGPointMake(self.size.width/2, self.size.height/15)
        var point = CGPointMake(player.position.x, player.position.y)
        var size = CGSize(width: 13, height: 10)
        
        var physicsBodySize:CGSize = CGSize(width: 10.0, height : 5.0)
        
        player.physicsBody = SKPhysicsBody(rectangleOfSize: physicsBodySize, center: CGPoint(x : -10.0, y: 0.0))
    
        //player.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.drop //triggers didBeginContact
        player.physicsBody?.dynamic = false
        
        let bottomRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        bottom.physicsBody!.categoryBitMask = PhysicsCategory.bottom
        self.addChild(bottom)
        
        //selector: what function it calls every second
        
        
        DropTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("spawnDrop"), userInfo: nil, repeats: true)
        self.addChild(player)
        
        
        scoreLabel.text = "\(score)"
        scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100,height: 20))
        scoreLabel.backgroundColor = UIColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 0.3)
        scoreLabel.textColor = UIColor.whiteColor()
        
        self.view?.addSubview(scoreLabel)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody : SKPhysicsBody = contact.bodyA   //contact is passed from parameter and
        var secondBody : SKPhysicsBody = contact.bodyB  // A and B is the two objects
        
        isDone = false
        checkScore()
        if((firstBody.contactTestBitMask == PhysicsCategory.drop) &&
            (secondBody.contactTestBitMask == PhysicsCategory.player))
        {
            self.runAction(splash)
            if(firstBody.node != nil && secondBody.node != nil)
            {
                collideWithPlayer(firstBody.node as! SKSpriteNode, person: secondBody.node as! SKSpriteNode )
            }
        }
        else if((firstBody.contactTestBitMask == PhysicsCategory.player) &&
            (secondBody.contactTestBitMask == PhysicsCategory.drop))
        {
         //   splash.stop()
         //   splash.play()
            self.runAction(splash)
            if(secondBody.node != nil && firstBody.node != nil)
            {
                collideWithDrop(firstBody.node as! SKSpriteNode, drop: secondBody.node as! SKSpriteNode)
            }
            //firstBody.node as! SKSpriteNode, person: secondBody.node as! SKSpriteNode )
        }
        
        
        if(firstBody.categoryBitMask == PhysicsCategory.bottom && secondBody.categoryBitMask == PhysicsCategory.drop)
        {
            updateScore();
            
            
            secondBody.node?.removeFromParent()
            firstBody.node?.removeFromParent()
            soundPlayer.stop()
            self.view?.presentScene(EndScene())
            
            scoreLabel.removeFromSuperview()
        }
        
    }
    
    func checkScore()
    {
        if(score % 10 == 0 && isDone == false && score != 0)
        {
            
            isDone = true
            MULTIPLIER = MULTIPLIER * 0.80
            DropTimer.invalidate()
            DropTimer = NSTimer.scheduledTimerWithTimeInterval(1.0 * MULTIPLIER, target: self, selector: Selector("spawnDrop"), userInfo: nil, repeats: true)
            
        }
    }
    func updateScore()
    {
        var scoreDefault = NSUserDefaults.standardUserDefaults()
        scoreDefault.setValue(score, forKey: "Score") //grab this score from NSUerDefaults to update and check high scores. The key("Score) will be used to get the value of scoreDefault
        scoreDefault.synchronize()
        
        if(score > highScore)
        {
            var highScoreDefault = NSUserDefaults.standardUserDefaults()
            highScoreDefault.setValue(score, forKey: "HighScore")
        }
    }
    
    func collideWithPlayer(drop: SKSpriteNode, person: SKSpriteNode)
    {
        person.removeFromParent()
        //drop.removeFromParent()
        
        score++
        scoreLabel.text = "\(score)"
        
        
    }
    
    func collideWithDrop(person: SKSpriteNode, drop: SKSpriteNode)
    {
        drop.removeFromParent()
        //person.removeFromParent()
        
        score++
        
        scoreLabel.text =  "\(score)"
        
    }
    
    func pauseClick()
    {
        if(isGamePaused == false)
        {
           scene!.view!.paused = true
           isGamePaused = true
           DropTimer.invalidate()
           return;
        }
        
        if(isGamePaused == true)
        {
            scene!.view!.paused = false
            isGamePaused = false
            DropTimer = NSTimer.scheduledTimerWithTimeInterval(1.0 * MULTIPLIER, target: self, selector: Selector("spawnDrop"), userInfo: nil, repeats: true)
            return;
        }
        
    }
    
    func spawnDrop(){
        var drop = SKSpriteNode(imageNamed: "wuterdrip.png")
        var minValue = self.size.width/8
        var maxValue = self.size.width - 20
        
        var spawnPoint = UInt32(maxValue - minValue)
        
        drop.position = CGPoint(x: CGFloat(arc4random_uniform(spawnPoint)), y: self.size.height)
        drop.physicsBody = SKPhysicsBody(rectangleOfSize: drop.size)
        drop.physicsBody?.categoryBitMask = PhysicsCategory.drop
        drop.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.bottom
        //^ have to use the |(or for bits) instead of declaring another contacttestbitmask
        //drop.physicsBody?.contactTestBitMask = PhysicsCategory.bottom
        drop.physicsBody?.affectedByGravity = false
        drop.physicsBody?.allowsRotation = false
        drop.physicsBody?.dynamic = true
        
        let action = SKAction.moveToY(-70, duration: (3.0))
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
