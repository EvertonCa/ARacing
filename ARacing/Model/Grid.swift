//
//  Grid.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 07/05/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import ARKit

struct Grid {
    // creates the grid that shows the horizontal surface
    static func createGrid(planeAnchor: ARPlaneAnchor) -> SCNNode {
        
        let gridNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
        gridNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Grid")
        gridNode.geometry?.firstMaterial?.isDoubleSided = true
        gridNode.position = SCNVector3(CGFloat(planeAnchor.center.x), CGFloat(planeAnchor.center.y), CGFloat(planeAnchor.center.z))
        gridNode.eulerAngles = SCNVector3(x: Float(90.degreesToRadians), y: 0, z: 0)
        
        // static is not affected by forces, but it is interact-able
        let staticBody = SCNPhysicsBody.static()
        
        gridNode.physicsBody = staticBody
        gridNode.physicsBody?.allowsResting = false
        gridNode.physicsBody?.friction = CGFloat(0.4)
        
        return gridNode
    }
}
