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
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.singleARBrain.updatesVehicle()
        }
    }
}

