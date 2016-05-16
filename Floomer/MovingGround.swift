//
//  MovingGround.swift
//  Floomer
//
//  Created by Daniel Ungerfält on 14/05/16.
//  Copyright © 2016 Daniel Ungerfält. All rights reserved.
//

import Foundation
import SpriteKit

class MovingGround : SKSpriteNode {
    
    let MovingGroundTexture = SKTexture(imageNamed : "MovingGround")
    let myColor = UIColor(red: 150, green: 105, blue: 123, alpha: 1.0)
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor(), size: CGSizeMake(size.width, size.height))
        anchorPoint = CGPointMake(0, 0)
        position = CGPointMake(0.0, 0.0)
        zPosition = 1
        
        for var i: CGFloat = 0; i<2 + self.frame.size.width / (MovingGroundTexture.size().width); ++i {
            let groundsprite = SKSpriteNode(texture: self.MovingGroundTexture)
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
        let movingGroundSprite = SKAction.moveByX(-MovingGroundTexture.size().width, y: 0, duration: NSTimeInterval(0.004*MovingGroundTexture.size().width))
        let resetGroundSprite = SKAction.moveByX(MovingGroundTexture.size().width, y: 0, duration: 0.0)
        let moveSequence = SKAction.sequence([movingGroundSprite, resetGroundSprite])
        runAction(SKAction.repeatActionForever(moveSequence))
    }
    
    
    
    
}
