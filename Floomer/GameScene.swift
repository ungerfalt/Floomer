//
//  GameScene.swift
//  Floomer
//
//  Created by Daniel Ungerfält on 14/05/16.
//  Copyright (c) 2016 Daniel Ungerfält. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var movingGround : MovingGround!
    var movingBackground : MovingBackground!
    var movingMidGround : MovingMidground!
    var movingForground : MovingForground!
    var plane : Plane!
    var model : Model!
    
    let movingGroundTexture = SKTexture(imageNamed: "MovingGround")
    let movingBackgroundTexture = SKTexture(imageNamed: "MovingBackground")
    let movingMidGroundTexture = SKTexture(imageNamed: "movingMidGround")
    let movingForgroundTexture = SKTexture(imageNamed: "movingForground")
    let pipe1Texture = SKTexture(imageNamed: "Pipe1")
    let pipe2Texture = SKTexture(imageNamed: "Pipe2")
    let movingPlaneTexture = SKTexture(imageNamed: "Plane1")
    let modelTexture = SKTexture(imageNamed: "Plane1")
    
    
    var spaceColor = UIColor(red: 133.0/255.0, green: 197.0/255.0, blue: 207.0/255.0, alpha: 1.0)
    
    var moving = SKNode()
    var pipePair = SKNode()
    var pipes = SKNode()
    var groundLevel = SKNode()
    var skyLimit = SKNode()
    
    var alreadyAddedToTheScene = Bool()
    
    var movePipesAndRemove = SKAction()
    var spawnThenDelayForever = SKAction()
    
    let planeCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    
    var score = NSInteger()
    var scoreLabelNode = SKLabelNode()
    
    var gameSceneAudioPlayer = AVAudioPlayer()
    var gameSceneSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bgMusic64", ofType: "mp3")!)
    var gameSceneEffectAudioPlayer = AVAudioPlayer()
    var gameSceneEffectSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("fail", ofType: "mp3")!)
    
    
    override func didMoveToView(view: SKView) {
        
            addChild(moving)
        
            self.physicsWorld.gravity = CGVectorMake(0.0, -5.5)
            self.physicsWorld.contactDelegate = self
        
            alreadyAddedToTheScene = false
        
            backgroundColor = spaceColor
        
            movingGround = MovingGround(size: CGSizeMake(movingGroundTexture.size().width, movingGroundTexture.size().height))
                moving.addChild(movingGround)
        
            movingBackground = MovingBackground(size: CGSizeMake(movingBackgroundTexture.size().width, movingBackgroundTexture.size().height))
            moving.addChild(movingBackground)
        
            movingMidGround = MovingMidground(size: CGSizeMake(movingMidGroundTexture.size().width, movingMidGroundTexture.size().height))
            moving.addChild(movingMidGround)
        
            movingForground = MovingForground(size: CGSizeMake(movingForgroundTexture.size().width, movingForgroundTexture.size().height))
            moving.addChild(movingForground)
        
            moving.addChild(pipes)
        
            let distanceToMove = CGFloat(self.frame.size.width + 5.0 * pipe1Texture.size().width)
        
            let movePipes = SKAction.moveByX(-distanceToMove, y: 0.0, duration: NSTimeInterval(0.004 * distanceToMove))
        
            let removePipes = SKAction.removeFromParent()
        
            movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
        
        let spawn = SKAction.runBlock({() in self.spawnPipes()})
        let delay = SKAction.waitForDuration(1.9, withRange: 2.0)
        let spawnThenDelay = SKAction.sequence([spawn,delay])
        spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        
        model = Model(size: CGSizeMake(modelTexture.size().width, modelTexture.size().height))
        model.position = CGPoint(x: self.frame.width / 2.8, y: self.frame.size.height / 2)
        addChild(model)
        
        plane = Plane(size: CGSizeMake(movingPlaneTexture.size().width, movingPlaneTexture.size().height))
        plane.position = CGPoint(x: self.frame.size.width / 2.8, y: self.frame.size.height / 2)
        
        plane.physicsBody = SKPhysicsBody(circleOfRadius: plane.size.height / 2)
        plane.physicsBody?.dynamic = true
        plane.physicsBody?.allowsRotation = false
        plane.physicsBody?.categoryBitMask = planeCategory
        plane.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        plane.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
        
        groundLevel.position = CGPointMake(self.frame.width / 2, movingGroundTexture.size().height / 2)
        groundLevel.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, movingGroundTexture.size().height))
        groundLevel.physicsBody?.dynamic = false
        groundLevel.physicsBody?.categoryBitMask = worldCategory
        groundLevel.physicsBody?.contactTestBitMask = planeCategory
        self.addChild(groundLevel)
        
        skyLimit.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        skyLimit.physicsBody?.friction = 0
        skyLimit.physicsBody?.categoryBitMask = worldCategory
        skyLimit.physicsBody?.contactTestBitMask = planeCategory
        self.addChild(skyLimit)
        
        score = 0
        scoreLabelNode.fontName = "Helvetica"
        scoreLabelNode.position = CGPointMake(self.frame.size.width / 1.2, self.frame.size.height / 1.2)
        scoreLabelNode.fontColor = UIColor.darkGrayColor()
        scoreLabelNode.zPosition = 1
        scoreLabelNode.text = "\(score)"
        scoreLabelNode.fontSize = 65
        self.addChild(scoreLabelNode)
        
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
            addStuffToTheScene()
            alreadyAddedToTheScene = true
        
        if(moving.speed > 0) {
            
            plane.physicsBody?.velocity = CGVectorMake(0, 0)
            plane.physicsBody?.applyImpulse(CGVectorMake(0, 18))
        }
          }
   
    override func update(currentTime: CFTimeInterval) {
        
        if(moving.speed > 0) {
            plane.zRotation = tiltContrants(-1, max: 0.5, value: plane.physicsBody!.velocity.dy * (plane!.physicsBody?.velocity.dx < 0 ? 0.003 : 0.001))
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if(moving.speed > 0) {
            
            if((contact.bodyA.categoryBitMask & scoreCategory) == scoreCategory || (contact.bodyB.categoryBitMask & scoreCategory) == scoreCategory) {
                
                // Increments the score
                score++
                
                // Saving the score to be used the the Game Over scene
                kScore = score
                
                // Update the ScoreLabelNode in the scene to display the users current score
                scoreLabelNode.text = "\(score)"
                
            } else {
                moving.speed = 0
                plane.physicsBody?.collisionBitMask = worldCategory
                let rotatePlane = SKAction.rotateByAngle(0.0, duration: 0.003)
                let stopPlane = SKAction.runBlock({() in self.killSpeed()})
                let slowDownSequence = SKAction.sequence([rotatePlane,stopPlane])
                plane.runAction(slowDownSequence)
                gameSceneAudioPlayer.stop()
                playGameOverEffectAudio()
                delay(0.5) {
                    
                    self.gameOver()
                }
            }
        }
    }
    
    func addStuffToTheScene() {
        
        if(alreadyAddedToTheScene == false) {
            movingGround.begin()
            movingBackground.begin()
            movingMidGround.begin()
            movingForground.begin()
            self.runAction(spawnThenDelayForever)
            model.removeFromParent()
            addChild(plane)
            plane.begin()
            playGameSceneAudio()
        }
    }
    
    func spawnPipes() {
        
        let pipePair = SKNode()
        pipePair.position = CGPointMake(self.frame.size.width + pipe1Texture.size().width, 0)
        pipePair.zPosition = 0
        
        let height = UInt(self.frame.height / 3 )
        let y = UInt(arc4random()) % height
        let pipe1 = SKSpriteNode(texture: pipe1Texture)
        
        pipe1.position = CGPointMake(0.0, CGFloat(y))
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipe1.size)
        pipe1.physicsBody?.dynamic = false
        pipe1.physicsBody?.categoryBitMask = pipeCategory
        pipe1.physicsBody?.contactTestBitMask = planeCategory
        pipePair.addChild(pipe1)
        
        let maxGap = UInt(self.frame.height / 5)
        let minGap = UInt32(self.frame.height / 8)
        let gap = UInt(arc4random_uniform(minGap)) + maxGap
        
        let pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPointMake(0.0, CGFloat(y) + pipe2.size.height + CGFloat(gap))
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2.size)
        pipe2.physicsBody?.dynamic = false
        pipe2.physicsBody?.categoryBitMask = pipeCategory
        pipe2.physicsBody?.contactTestBitMask = planeCategory
        pipePair.addChild(pipe2)
        
        let contactPlaneNode = SKNode()
        contactPlaneNode.position = CGPointMake(pipe1.size.width + plane.size.width, CGRectGetMidY(self.frame))
        contactPlaneNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width, self.frame.size.height))
        contactPlaneNode.physicsBody?.dynamic = false
        contactPlaneNode.physicsBody?.categoryBitMask = scoreCategory
        contactPlaneNode.physicsBody?.contactTestBitMask = planeCategory
        pipePair.addChild(contactPlaneNode)
        
        
        pipePair.runAction(movePipesAndRemove)
        
        pipes.addChild(pipePair)
    }
    
    func tiltContrants (min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
        
        if(value > max) {
            return max
        } else if(value < min) {
            return min
        } else {
            return value
        }
    }
    
    func killSpeed() {
        
        plane.speed = 0
    }
    
    func delay(delay: Double, closure:() -> ()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(delay * Double(NSEC_PER_SEC))),dispatch_get_main_queue(), closure)
    }
    
    func playGameSceneAudio() {
        
        // Setting up the audioplayer for game scene audio
        do {
            try gameSceneAudioPlayer = AVAudioPlayer(contentsOfURL:
                gameSceneSound)
        } catch {
            print("GameScene. gameSceneAudioPlayer is not available")
        }
        gameSceneAudioPlayer.prepareToPlay()
        gameSceneAudioPlayer.numberOfLoops = -1
        gameSceneAudioPlayer.play()
        
    }
    
    func playGameOverEffectAudio() {
        
        // Setting up the audioplayer for game over effect audio
        do {
            try gameSceneEffectAudioPlayer = AVAudioPlayer(contentsOfURL:
                gameSceneEffectSound)
        } catch {
            print("GameScene. gameSceneAudioPlayer is not available")
        }
        gameSceneEffectAudioPlayer.prepareToPlay()
        gameSceneEffectAudioPlayer.play()
    }
    
    func gameOver() {
        
        // Create the new scene to transition too
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder  = true
        
        // Remove scene before transitioning
        self.scene?.removeFromParent()
        
        // The transition effect
        let transition = SKTransition.fadeWithColor(UIColor.grayColor(), duration: 1.0)
        transition.pausesOutgoingScene = false
        
        // A variable to hold the GameOver scene
        var scene: GameOver!
        scene = GameOver(size: skView.bounds.size)
        
        // Setting the new scene´s aspect ratio to fill
        scene.scaleMode = .AspectFill
        
        // Presenting the new scene with a transition effect
        skView.presentScene(scene, transition: transition)
        
        
    }
}
