//
//  RCViewControllerDelegates.swift
//  ARacing
//
//  Created by Everton Cardoso on 19/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

//MARK: - ARSCNViewDelegate

extension RCViewController: ARSCNViewDelegate {
    
    // when a anchor is detected
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        DispatchQueue.main.async {
            // show feedback
            self.showFeedback(text: "Click on the grid where you would like to place your RC Car!")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                //self.planeDetectedLabel.isHidden = true
            }
        }
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let gridNode = self.rcBrains.createGrid(planeAnchor: planeAnchor)
        
        node.addChildNode(gridNode)
    }
    
    //when the anchor is updated
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        self.rcBrains.gridNode = node
        
        node.enumerateChildNodes { ( childNode, _ ) in
            childNode.removeFromParentNode()
        }
        
        let gridNode = self.rcBrains.createGrid(planeAnchor: planeAnchor)
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
        
        let steerAngle:CGFloat = 0.8
        // steer the vehicle to right
        if self.rcBrains.turningRight {
            self.rcBrains.vehicle.setSteeringAngle(steerAngle, forWheelAt: 2)
            self.rcBrains.vehicle.setSteeringAngle(steerAngle, forWheelAt: 3)
        }
        // steer the vehicle to left
        else if self.rcBrains.turningLeft {
            self.rcBrains.vehicle.setSteeringAngle(-steerAngle, forWheelAt: 2)
            self.rcBrains.vehicle.setSteeringAngle(-steerAngle, forWheelAt: 3)
        } else {
            self.rcBrains.vehicle.setSteeringAngle(0, forWheelAt: 2)
            self.rcBrains.vehicle.setSteeringAngle(0, forWheelAt: 3)
        }
        
        // Accelerate the vehicle
        let engineForce: CGFloat = 10
        
        // Break the vehicle
        let frontBreakingForce: CGFloat = 20
        let rearBreakingForce: CGFloat = 10

        if self.rcBrains.accelerating {
            self.rcBrains.vehicle.applyEngineForce(engineForce, forWheelAt: 0)
            self.rcBrains.vehicle.applyEngineForce(engineForce, forWheelAt: 1)
        } else if self.rcBrains.breaking {
            // if vehicle is stopped, reverse, else, brakes
            if self.rcBrains.vehicle.speedInKilometersPerHour < 0.5{
                self.rcBrains.vehicle.applyEngineForce(-engineForce, forWheelAt: 0)
                self.rcBrains.vehicle.applyEngineForce(-engineForce, forWheelAt: 1)
            } else {
                // rear wheels
                self.rcBrains.vehicle.applyBrakingForce(rearBreakingForce, forWheelAt: 0)
                self.rcBrains.vehicle.applyBrakingForce(rearBreakingForce, forWheelAt: 1)
                // front wheels
                self.rcBrains.vehicle.applyBrakingForce(frontBreakingForce, forWheelAt: 2)
                self.rcBrains.vehicle.applyBrakingForce(frontBreakingForce, forWheelAt: 3)
            }
            
        } else {
            // rear wheels
            self.rcBrains.vehicle.applyBrakingForce(0, forWheelAt: 0)
            self.rcBrains.vehicle.applyBrakingForce(0, forWheelAt: 1)
            // front wheels
            self.rcBrains.vehicle.applyBrakingForce(0, forWheelAt: 2)
            self.rcBrains.vehicle.applyBrakingForce(0, forWheelAt: 3)
            // resets reverse wheels
            self.rcBrains.vehicle.applyEngineForce(0, forWheelAt: 0)
            self.rcBrains.vehicle.applyEngineForce(0, forWheelAt: 1)
        }
        
    }
}


