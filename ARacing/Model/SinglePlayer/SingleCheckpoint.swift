//
//  SingleCheckpoint.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 22/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

class SingleCheckpoint {
    
    //MARK: - Variables and Constants
    
    // Scenery
    var scenery:SCNNode
    
    // checkpoints positions
    var checkpointsPositions:[SCNVector3] = [SCNVector3(0.1, -0.2, 0.2)]
    
    // checkpoint being shown in the moment
    var checkpointNow:Int = 0
    
    //MARK: - Functions
    
    init(sceneryNode: SCNNode) {
        self.scenery = sceneryNode
    }
    
    // sets up and show the checkpoint
    func setupCheckpoints() {
        let scene = SCNScene(named: "3D Models.scnassets/CheckPoint.scn")
        let checkpoint = (scene?.rootNode.childNode(withName: "checkpoint", recursively: true))!
        
        checkpoint.position = self.checkpointsPositions[self.checkpointNow]
        checkpoint.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: checkpoint, options: nil))
        checkpoint.physicsBody?.categoryBitMask = BitMaskCategory.Checkpoint.rawValue
        checkpoint.physicsBody?.contactTestBitMask = BitMaskCategory.Vehicle.rawValue
        checkpoint.physicsBody?.mass = CGFloat(0.0)
        
        // Particles in the checkpoint
        let particle = SCNParticleSystem(named: "3D Models.scnassets/Fire.scnp", inDirectory: nil)
        particle?.loops = true
        //particle?.particleLifeSpan = 4
        particle?.emitterShape = checkpoint.geometry
        let particleNode = SCNNode()
        particleNode.addParticleSystem(particle!)
        particleNode.position = SCNVector3(0, 0, 0)
        particleNode.eulerAngles = SCNVector3(x: 0, y: 0, z: 0)
        
        checkpoint.addChildNode(particleNode)
        self.scenery.addChildNode(checkpoint)
        
    }
}
