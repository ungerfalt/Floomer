//
//  Model.swift
//  Floomer
//
//  Created by Daniel Ungerfält on 15/05/16.
//  Copyright © 2016 Daniel Ungerfält. All rights reserved.
//

import Foundation
import SpriteKit

class Model : SKSpriteNode {
    let Modeltexture = SKTexture(imageNamed: "Plane1")
    
    init(size: CGSize) {
        super.init(texture: Modeltexture, color: UIColor(), size: CGSizeMake(size.width, size.height))
        zPosition = 1
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}