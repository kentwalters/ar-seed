//
//  StanceScene.swift
//  ar-play-builder
//
//  Created by Kent Walters on 2019-07-16.
//  Copyright © 2019 ae. All rights reserved.
//

import Foundation
import ARKit

//class StanceScene: SCNScene {
//    let stance: Stances = Stances.RB
//    
//    override init(stance: Stances) {
//        self.stance = stance
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

enum Stances {
    case RB
    case DB
    case DL1
    case DL2
    case DL3
    case LB
    case OL2
    case QB
}
