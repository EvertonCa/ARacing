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
    var checkpointsPositions:[[SCNVector3]] = [[SCNVector3(0.8, 0.35, -0.8), SCNVector3(Float(45.degreesToRadians), 0, Float(90.degreesToRadians))],
                                               [SCNVector3(-0.8, 0.35, 0.0), SCNVector3(0, 0, Float(90.degreesToRadians))],
                                               [SCNVector3(0.8, 0.35, 0.8), SCNVector3(-Float(45.degreesToRadians), 0, Float(90.degreesToRadians))]]
    
    // checkpoint being shown in the moment
    var checkpointNow:Int = 0
    
    // checkpoint on screen
    var checkpointOnScreen = false
    
    //MARK: - Functions
    
    init(sceneryNode: SCNNode) {
        self.scenery = sceneryNode
    }
    
    // sets up and show the checkpoint
    func setupCheckpoints() -> Bool {
        if self.checkpointNow < self.checkpointsPositions.count {
            let scene = SCNScene(named: "3D Models.scnassets/CheckPoint.scn")
            let checkpoint = (scene?.rootNode.childNode(withName: "checkpoint", recursively: true))!
            
            checkpoint.position = self.checkpointsPositions[self.checkpointNow][0]
            checkpoint.eulerAngles = self.checkpointsPositions[self.checkpointNow][1]
            checkpoint.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: checkpoint, options: nil))
            checkpoint.physicsBody?.categoryBitMask = BitMaskCategory.Checkpoint.rawValue
            checkpoint.physicsBody?.contactTestBitMask = BitMaskCategory.Vehicle.rawValue
            checkpoint.physicsBody?.isAffectedByGravity = false
            checkpoint.name = String(self.checkpointNow)
            
            // Particles in the checkpoint
            let particle = SCNParticleSystem(named: "3D Models.scnassets/Fire.scnp", inDirectory: nil)
            let particle2 = SCNParticleSystem(named: "3D Models.scnassets/Fire2.scnp", inDirectory: nil)
            particle?.loops = true
            particle2?.loops = true
            particle?.emitterShape = checkpoint.geometry
            particle2?.emitterShape = checkpoint.geometry
            let particleNode = SCNNode()
            let particleNode2 = SCNNode()
            particleNode.addParticleSystem(particle!)
            particleNode2.addParticleSystem(particle2!)
            particleNode.position = SCNVector3(0, 0, 0)
            particleNode2.position = SCNVector3(0, 0, 0)
            particleNode.eulerAngles = SCNVector3(x: 0, y: 0, z: 0)
            particleNode2.eulerAngles = SCNVector3(x: 0, y: 0, z: 0)
            
            checkpoint.addChildNode(particleNode)
            checkpoint.addChildNode(particleNode2)
            
            checkpoint.opacity = 0
            self.scenery.addChildNode(checkpoint)
            
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1.0
            checkpoint.opacity = 1
            SCNTransaction.commit()
            
            self.checkpointNow += 1
            
            self.checkpointOnScreen = true
            return true
        }
        else {
            return false
        }
    }
}
