//
//  Checkpoint.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 13/05/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

class Checkpoint {
    
    //MARK: - Variables and Constants
    
    // Map
    var map:SCNNode
    
    // checkpoint being shown in the moment
    var checkpointNow:Int = 0
    
    // checkpoint on screen
    var checkpointOnScreen = false
    
    // Game
    var game:Game
    
    //MARK: - Functions
    
    init(mapNode: SCNNode, game:Game) {
        self.map = mapNode
        self.game = game
    }
    
    // sets up and show the checkpoint
    func setupCheckpoints() -> Bool {
        
        if self.checkpointNow < self.game.checkpointsQuantity() {
            let scene = SCNScene(named: CheckpointsResources.Checkpoint.rawValue)
            let checkpoint = (scene?.rootNode.childNode(withName: "checkpoint", recursively: true))!
            
            checkpoint.position = self.game.checkpointsCoordinates()[self.checkpointNow]
            checkpoint.eulerAngles = self.game.checkpointsRotations()[self.checkpointNow]
            checkpoint.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: checkpoint, options: nil))
            checkpoint.physicsBody?.categoryBitMask = CategoryBitmask.Checkpoint.rawValue
            checkpoint.physicsBody?.contactTestBitMask = ContactBitmask.Vehicle.rawValue
            checkpoint.physicsBody?.collisionBitMask = CollisionBitmask.Nothing.rawValue
            checkpoint.physicsBody?.isAffectedByGravity = false
            checkpoint.name = String(self.checkpointNow)
            
            // Particles in the checkpoint
            let particle = SCNParticleSystem(named: ParticlesResources.CheckpointFire1.rawValue, inDirectory: nil)
            let particle2 = SCNParticleSystem(named: ParticlesResources.CheckpointFire2.rawValue, inDirectory: nil)
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
            self.map.addChildNode(checkpoint)
            
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

