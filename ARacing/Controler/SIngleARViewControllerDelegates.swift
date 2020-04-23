//
//  SIngleARViewControllerDelegates.swift
//  ARacing
//
//  Created by Everton Cardoso on 15/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

//MARK: - ARSCNViewDelegate
extension SingleARViewController: ARSCNViewDelegate {
    
    // when a anchor is detected
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        DispatchQueue.main.async {
            // show feedback
            self.showFeedback(text: "Click on the grid where you would like to place your map!")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                //self.planeDetectedLabel.isHidden = true
            }
        }
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let gridNode = singleARBrain.createGrid(planeAnchor: planeAnchor)
        
        node.addChildNode(gridNode)
    }
    
    //when the anchor is updated
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        // if the scenary is not placed, updates the grid to the new size
        if !self.singleARBrain.scenery.sceneryPlaced {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            self.singleARBrain.gridNode = node
            
            node.enumerateChildNodes { ( childNode, _ ) in
                childNode.removeFromParentNode()
            }
            
            let gridNode = self.singleARBrain.createGrid(planeAnchor: planeAnchor)
            node.addChildNode(gridNode)
        }
        
    }
    
    //when the anchor is removed
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        node.enumerateChildNodes { ( childNode, _ ) in
            childNode.removeFromParentNode()
        }
    }
    
    // used for vehicle and physics updates
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            // updates vehicle
            self.singleARBrain.vehicles.updatesVehicle()
            
            //updates text look at
            self.singleARBrain.arText.lookAtCamera(sceneView: self.sceneView, sceneryNode: self.singleARBrain.sceneryNode)
        }
    }
}

//MARK: - SCNPhysicsContactDelegate
extension SingleARViewController: SCNPhysicsContactDelegate {
    
    // checks collision in the scene
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        if nodeA.physicsBody?.categoryBitMask == BitMaskCategory.Checkpoint.rawValue
            && nodeB.physicsBody?.categoryBitMask == BitMaskCategory.Vehicle.rawValue {
            
            nodeA.physicsBody?.categoryBitMask = 0

            // removes the node
            nodeA.removeFromParentNode()
            // calls another checkpoint
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.singleARBrain.updateCheckpoint()
            }
            
            
            
        } else if nodeB.physicsBody?.categoryBitMask == BitMaskCategory.Checkpoint.rawValue
        && nodeA.physicsBody?.categoryBitMask == BitMaskCategory.Vehicle.rawValue {
            
            nodeB.physicsBody?.categoryBitMask = 0

            // removes the node
            nodeB.removeFromParentNode()
            // calls another checkpoint
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.singleARBrain.updateCheckpoint()
            }
            
        }
    }
}
