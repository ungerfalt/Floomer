//
//  GameOver.swift
//  Floomer
//
//  Created by Daniel Ungerfält on 14/05/16.
//  Copyright © 2016 Daniel Ungerfält. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import AVFoundation

class GameOver: SKScene {
    
    var bgColor = UIColor(red: 163.0/255.0, green: 188.0/255.0, blue: 137.0/255.0, alpha: 1.0)
    var textColor = UIColor(red: 163.0/255.0, green: 188.0/255.0, blue: 137.0/255.0, alpha: 1.0)
    
    var replayButton = UIButton()
    var replayButtonImage = UIImage(named: "ReplayButton") as UIImage!
    
    var textLabel = UILabel()
    var scoreLabel = UILabel()
    var scoreLabelImage = UIImage(named: "ScoreBG") as UIImage!
    var scoreLabelImageView = UIImageView()
    
    var gameOverSceneAudioPlayer = AVAudioPlayer()
    var gameOverSceneSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("firstblood", ofType: "mp3")!)
    
    override func didMoveToView(view: SKView) {
        // Setting the background color to custom UIColor
        backgroundColor = bgColor
        
        // Create the replay button
        self.replayButton = UIButton(type: UIButtonType.Custom)
        self.replayButton.setImage(replayButtonImage, forState: .Normal)
        self.replayButton.frame = CGRectMake(self.frame.size.width / 2, self.frame.size.height / 2, 80, 80)
        self.replayButton.layer.anchorPoint = CGPointMake(1.0, 1.0)
        self.replayButton.layer.zPosition = 0
        
        // Make the replay button perform an action when it is touched
        self.replayButton.addTarget(self, action: "replayButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        delay(0.5) {
            view.addSubview(self.replayButton)
        }
        
        self.textLabel = UILabel(frame: CGRectMake(self.frame.size.width / 2, 200, 120, 60))
        self.textLabel.text = "Score:"
        self.textLabel.layer.zPosition = 0
        // Label to hold the player current score
        self.scoreLabel = UILabel(frame: CGRectMake(self.frame.size.width / 2, 200, 120, 120))
        self.scoreLabel.textAlignment = NSTextAlignment.Center
        self.scoreLabel.textColor = textColor
        self.scoreLabel.text = "\(kScore)"
        self.scoreLabel.font = UIFont(name: (scoreLabel.font?.fontName)!, size: 45)
        self.scoreLabel.layer.anchorPoint = CGPointMake(1.0, 1.0)
        self.scoreLabel.layer.zPosition = 1
        
        // Set background image for the score label
        self.scoreLabelImageView = UIImageView(image: scoreLabelImage!)
        self.scoreLabelImageView.frame = CGRectMake(self.frame.size.width / 2, 200, 120, 120)
        self.scoreLabelImageView.layer.anchorPoint = CGPointMake(1.0, 1.0)
        self.scoreLabelImageView.layer.zPosition = 0
        delay(0.5) {
            
            view.addSubview(self.scoreLabel)
            view.addSubview(self.scoreLabelImageView)
        }
        
        delay(0.5) {
            
            self.playGameOverSceneAudio()
        }
        
    }
    
    func delay(delay: Double, closure:() -> ()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(delay * Double(NSEC_PER_SEC))),dispatch_get_main_queue(), closure)
    }
    
    func replayButtonAction(sender: UIButton!) {
        delay(0.5) {
            
            // Play the game again
            self.playAgain()
        }
    }
    
    func playGameOverSceneAudio() {
        
        // Setting up the audioplayer for game over scene audio
        do {
            try gameOverSceneAudioPlayer = AVAudioPlayer(contentsOfURL:
                gameOverSceneSound)
        } catch {
            print("GameScene. gameSceneAudioPlayer is not available")
        }
        gameOverSceneAudioPlayer.prepareToPlay()
        gameOverSceneAudioPlayer.numberOfLoops = -1
        gameOverSceneAudioPlayer.play()
        
    }
    
    func playAgain() {
        
        // Removes the scorelabel from the view
        scoreLabel.removeFromSuperview()
        
        // Removes the scoreLabelImageView from the view
        scoreLabelImageView.removeFromSuperview()
        
        // Removes the replaybutton from the view
        replayButton.removeFromSuperview()
        
        // Create the new scene to transition too
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder  = true
        
        // Remove scene before transitioning
        self.scene?.removeFromParent()
        
        // The transition effect
        let transition = SKTransition.fadeWithColor(UIColor.grayColor(), duration: 1.0)
        transition.pausesOutgoingScene = false
        
        // A variable to hold the GameOver scene
        var scene: GameScene!
        scene = GameScene(size: skView.bounds.size)
        
        // Setting the new scene´s aspect ratio to fill
        scene.scaleMode = .AspectFill
        
        // Presenting the new scene with a transition effect
        skView.presentScene(scene, transition: transition)
    }
    
}