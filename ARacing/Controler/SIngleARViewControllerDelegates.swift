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
            // changes startButton alpha to 1 and enables the button
            self.showStartButton()
            
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
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        node.enumerateChildNodes { ( childNode, _ ) in
            childNode.removeFromParentNode()
        }
        let gridNode = singleARBrain.createGrid(planeAnchor: planeAnchor)
        node.addChildNode(gridNode)
    }
    
    //when the anchor is removed
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        
        node.enumerateChildNodes { ( childNode, _ ) in
            childNode.removeFromParentNode()
        }
    }
    
    // used for vehicle and physics updates
    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
//        self.vehicle.setSteeringAngle(orientation, forWheelAt: 2)
//        self.vehicle.setSteeringAngle(orientation, forWheelAt: 3)
//
//        var engineForce: CGFloat = 0
//        var breakingForce: CGFloat = 0
//
//        if self.touched == 1 {
//            // accelerate
//            engineForce = 50
//        } else if self.touched == 2 {
//            // reverse
//            engineForce = -50
//        } else if self.touched == 3 {
//            // break
//            breakingForce = 100
//        } else {
//            engineForce = 0
//            breakingForce = 0
//        }
//
//        self.vehicle.applyEngineForce(engineForce, forWheelAt: 0)
//        self.vehicle.applyEngineForce(engineForce, forWheelAt: 1)
//
//        self.vehicle.applyBrakingForce(breakingForce, forWheelAt: 0)
//        self.vehicle.applyBrakingForce(breakingForce, forWheelAt: 1)
    }
}

