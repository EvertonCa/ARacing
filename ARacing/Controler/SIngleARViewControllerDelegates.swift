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
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        self.singleARBrain.gridNode = node
        
        node.enumerateChildNodes { ( childNode, _ ) in
            childNode.removeFromParentNode()
        }
        
        // if the scenary is placed, stop showing grid
        if !self.singleARBrain.sceneryPlaced {
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
    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        
        let steerAngle:CGFloat = 0.8
        // steer the vehicle to right
        if self.singleARBrain.turningRight {
            self.singleARBrain.vehicle.setSteeringAngle(steerAngle, forWheelAt: 2)
            self.singleARBrain.vehicle.setSteeringAngle(steerAngle, forWheelAt: 3)
        }
        // steer the vehicle to left
        else if self.singleARBrain.turningLeft {
            self.singleARBrain.vehicle.setSteeringAngle(-steerAngle, forWheelAt: 2)
            self.singleARBrain.vehicle.setSteeringAngle(-steerAngle, forWheelAt: 3)
        } else {
            self.singleARBrain.vehicle.setSteeringAngle(0, forWheelAt: 2)
            self.singleARBrain.vehicle.setSteeringAngle(0, forWheelAt: 3)
        }
        
        // Accelerate the vehicle
        let engineForce: CGFloat = 10
        
        // Break the vehicle
        let frontBreakingForce: CGFloat = 20
        let rearBreakingForce: CGFloat = 10

        if self.singleARBrain.accelerating {
            self.singleARBrain.vehicle.applyEngineForce(engineForce, forWheelAt: 0)
            self.singleARBrain.vehicle.applyEngineForce(engineForce, forWheelAt: 1)
        } else if self.singleARBrain.breaking {
            // if vehicle is stopped, reverse, else, brakes
            if self.singleARBrain.vehicle.speedInKilometersPerHour < 0.5{
                self.singleARBrain.vehicle.applyEngineForce(-engineForce, forWheelAt: 0)
                self.singleARBrain.vehicle.applyEngineForce(-engineForce, forWheelAt: 1)
            } else {
                // rear wheels
                self.singleARBrain.vehicle.applyBrakingForce(rearBreakingForce, forWheelAt: 0)
                self.singleARBrain.vehicle.applyBrakingForce(rearBreakingForce, forWheelAt: 1)
                // front wheels
                self.singleARBrain.vehicle.applyBrakingForce(frontBreakingForce, forWheelAt: 2)
                self.singleARBrain.vehicle.applyBrakingForce(frontBreakingForce, forWheelAt: 3)
            }
            
        } else {
            // rear wheels
            self.singleARBrain.vehicle.applyBrakingForce(0, forWheelAt: 0)
            self.singleARBrain.vehicle.applyBrakingForce(0, forWheelAt: 1)
            // front wheels
            self.singleARBrain.vehicle.applyBrakingForce(0, forWheelAt: 2)
            self.singleARBrain.vehicle.applyBrakingForce(0, forWheelAt: 3)
            // resets reverse wheels
            self.singleARBrain.vehicle.applyEngineForce(0, forWheelAt: 0)
            self.singleARBrain.vehicle.applyEngineForce(0, forWheelAt: 1)
        }
        
    }
}

