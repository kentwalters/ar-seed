//
//  Plane.swift
//  ar-seed
//
//  Created by Kent Walters on 2019-05-17.
//  Copyright © 2019 ae. All rights reserved.
//

import Foundation
import ARKit

class Plane: SCNNode {
    var planeAnchor: ARPlaneAnchor
    
    var planeGeometry: SCNPlane
    var planeNode: SCNNode
    
    init(_ anchor: ARPlaneAnchor) {
        
        self.planeAnchor = anchor
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "field")
        
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        self.planeGeometry.materials = [material]
        
        self.planeGeometry.firstMaterial?.transparency = 1
        self.planeNode = SCNNode(geometry: planeGeometry)
        self.planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1, 0, 0)
        
        super.init()
        
        self.addChildNode(planeNode)
        
        self.position = SCNVector3(anchor.center.x, -0.002, anchor.center.z) // 2 mm below the origin of plane.
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ anchor: ARPlaneAnchor) {
        self.planeAnchor = anchor
        
        self.planeGeometry.width = CGFloat(anchor.extent.x)
        self.planeGeometry.height = CGFloat(anchor.extent.z)
        
        self.position = SCNVector3Make(anchor.center.x, -0.002, anchor.center.z)
    }
}
