//
//  SingleCheckpoint.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 22/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

struct Checkpoint {
    let coordinates: SCNVector3
    let rotation: SCNVector3
    
    init(_ coord: SCNVector3, _ rotat: SCNVector3) {
        coordinates = coord
        rotation = rotat
    }
}

struct AllCheckpoints {
    
    // Map 1 Coordinates
    let map1Checkpoints: [Checkpoint] = [Checkpoint(SCNVector3(0.8, 0.25, -0.8), SCNVector3(Float(45.degreesToRadians), 0, Float(90.degreesToRadians))),
                                         Checkpoint(SCNVector3(-0.8, 0.25, 0.0), SCNVector3(0, 0, Float(90.degreesToRadians))),
                                         Checkpoint(SCNVector3(0.8, 0.25, 0.8), SCNVector3(-Float(45.degreesToRadians), 0, Float(90.degreesToRadians)))]
    
    // Map 2 Coordinates
    let map2Checkpoints: [Checkpoint] = [Checkpoint(SCNVector3(0.8, 0.25, -0.8), SCNVector3(Float(45.degreesToRadians), 0, Float(90.degreesToRadians))),
                                         Checkpoint(SCNVector3(-0.8, 0.25, 0.0), SCNVector3(0, 0, Float(90.degreesToRadians))),
                                         Checkpoint(SCNVector3(0.8, 0.25, 0.8), SCNVector3(-Float(45.degreesToRadians), 0, Float(90.degreesToRadians)))]
    
    // Map 3 Coordinates
    let map3Checkpoints: [Checkpoint] = [Checkpoint(SCNVector3(0.8, 0.25, -0.8), SCNVector3(Float(45.degreesToRadians), 0, Float(90.degreesToRadians))),
                                         Checkpoint(SCNVector3(-0.8, 0.25, 0.0), SCNVector3(0, 0, Float(90.degreesToRadians))),
                                         Checkpoint(SCNVector3(0.8, 0.25, 0.8), SCNVector3(-Float(45.degreesToRadians), 0, Float(90.degreesToRadians)))]
    
}

class SingleCheckpoint {
    //MARK: - Checkpoint Coordinates
    let allCheckpoints = AllCheckpoints()
    
    //MARK: - Variables and Constants
    
    // Scenery
    var scenery:SCNNode
    
    // checkpoint being shown in the moment
    var checkpointNow:Int = 0
    
    // checkpoint on screen
    var checkpointOnScreen = false
    
    // Map Selected
    var mapSelected: Int = MapSelected.Map1.rawValue
    
    //MARK: - Functions
    
    init(sceneryNode: SCNNode) {
        self.scenery = sceneryNode
    }
    
    // sets up and show the checkpoint
    func setupCheckpoints() -> Bool {
        
        var checkpointCoordinates:[Checkpoint] = self.allCheckpoints.map1Checkpoints
        
        switch self.mapSelected {
        case MapSelected.Map1.rawValue:
            checkpointCoordinates = self.allCheckpoints.map1Checkpoints
            
        case MapSelected.Map2.rawValue:
            checkpointCoordinates = self.allCheckpoints.map2Checkpoints
            
        case MapSelected.Map1.rawValue:
            checkpointCoordinates = self.allCheckpoints.map3Checkpoints
            
        default: break
        }
        
        if self.checkpointNow < checkpointCoordinates.count {
            let scene = SCNScene(named: CheckpointsResources.Checkpoint.rawValue)
            let checkpoint = (scene?.rootNode.childNode(withName: "checkpoint", recursively: true))!
            
            checkpoint.position = checkpointCoordinates[self.checkpointNow].coordinates
            checkpoint.eulerAngles = checkpointCoordinates[self.checkpointNow].rotation
            checkpoint.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: checkpoint, options: nil))
            checkpoint.physicsBody?.categoryBitMask = BitMaskCategory.Checkpoint.rawValue
            checkpoint.physicsBody?.contactTestBitMask = BitMaskCategory.Vehicle.rawValue
            checkpoint.physicsBody?.isAffectedByGravity = false
            checkpoint.name = String(self.checkpointNow)
            
            // Particles in the checkpoint
            let particle = SCNParticleSystem(named: CheckpointsResources.CheckpointFire1.rawValue, inDirectory: nil)
            let particle2 = SCNParticleSystem(named: CheckpointsResources.CheckpointFire2.rawValue, inDirectory: nil)
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
