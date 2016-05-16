//
//  Plane.swift
//  Floomer
//
//  Created by Daniel Ungerfält on 15/05/16.
//  Copyright © 2016 Daniel Ungerfält. All rights reserved.
//

import Foundation
import SpriteKit

class Plane : SKSpriteNode {
    
    let MovingPlane1Texture = SKTexture(imageNamed: "Plane1")
    let MovingPlane2Texture = SKTexture(imageNamed: "Plane2")
    
    init(size: CGSize) {
        super.init(texture: MovingPlane1Texture, color: UIColor(), size: CGSizeMake(size.width, size.height))
        zPosition = 1
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func begin() {
        
        let animation = SKAction.animateWithTextures([MovingPlane1Texture, MovingPlane2Texture], timePerFrame: 0.1)
        runAction(SKAction.repeatActionForever(animation))
        
    }
    
}
