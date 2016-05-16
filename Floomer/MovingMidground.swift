//
//  MovingMidground.swift
//  Floomer
//
//  Created by Daniel Ungerfält on 15/05/16.
//  Copyright © 2016 Daniel Ungerfält. All rights reserved.
//

import Foundation
import SpriteKit

class MovingMidground : SKSpriteNode {
    
    let MovingMidGroundTexture = SKTexture(imageNamed: "MovingMidground")
    let MovingGroundTexture = SKTexture(imageNamed: "MovingGround")
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor(), size: CGSizeMake(MovingMidGroundTexture.size().width, MovingMidGroundTexture.size().height))
        anchorPoint = CGPointMake(0, 0)
        position = CGPointMake(0.0, 0.0)
        
        for var i: CGFloat = 0; i<2 + self.frame.size.width / (MovingMidGroundTexture.size().width); ++i {
            let groundsprite = SKSpriteNode(texture: self.MovingMidGroundTexture)
            groundsprite.zPosition = 0
            groundsprite.anchorPoint = CGPointMake(0, 0)
            groundsprite.position = CGPointMake(i * groundsprite.size.width, 0)
            addChild(groundsprite)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func begin() {
        let movingGroundSprite = SKAction.moveByX(-MovingMidGroundTexture.size().width, y: 0, duration: NSTimeInterval(0.1*MovingMidGroundTexture.size().width))
        let resetGroundSprite = SKAction.moveByX(MovingMidGroundTexture.size().width, y: 0, duration: 0.0)
        let moveSequence = SKAction.sequence([movingGroundSprite, resetGroundSprite])
        runAction(SKAction.repeatActionForever(moveSequence))
    }
}