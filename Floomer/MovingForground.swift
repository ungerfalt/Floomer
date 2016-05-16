//
//  MovingForground.swift
//  Floomer
//
//  Created by Daniel Ungerfält on 15/05/16.
//  Copyright © 2016 Daniel Ungerfält. All rights reserved.
//

import Foundation
import SpriteKit

class MovingForground: SKSpriteNode {
    
    let MovingForgroundTexture = SKTexture(imageNamed: "MovingForground")
    let MovingGroundTexture = SKTexture(imageNamed: "MovingGround")
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor(), size: CGSizeMake(size.width, size.height))
        anchorPoint = CGPointMake(0, 0)
        position = CGPointMake(0.0, 0.0)
        
        for var i: CGFloat = 0; i<2 + self.frame.size.width / (MovingForgroundTexture.size().width); ++i {
            let groundsprite = SKSpriteNode(texture: self.MovingForgroundTexture)
            groundsprite.zPosition = 0
            groundsprite.anchorPoint = CGPointMake(0, 0)
            groundsprite.position = CGPointMake(i * groundsprite.size.width, 0)
            addChild(groundsprite)
        }    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func begin() {
        let movingGroundSprite = SKAction.moveByX(-MovingForgroundTexture.size().width, y: 0, duration: NSTimeInterval(0.05*MovingForgroundTexture.size().width))
        let resetGroundSprite = SKAction.moveByX(MovingForgroundTexture.size().width, y: 0, duration: 0.0)
        let moveSequence = SKAction.sequence([movingGroundSprite, resetGroundSprite])
        runAction(SKAction.repeatActionForever(moveSequence))
    }
    
}
