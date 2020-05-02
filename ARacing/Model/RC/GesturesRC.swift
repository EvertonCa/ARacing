//
//  GesturesRC.swift
//  ARacing
//
//  Created by Everton Cardoso on 19/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

class GesturesRC {
    
    //MARK: - Variables
    
    // Tap gesture recognizer
    var tapGestureRecognizer:UITapGestureRecognizer?
    
    // AR SceneView
    var sceneView:ARSCNView!
    
    // ARBrains
    var arBrains:RCBrains!
    
    //MARK: - Functions
    
    init(sceneView: ARSCNView, arBrains:RCBrains) {
        self.sceneView = sceneView
        self.arBrains = arBrains
    }
    
    // Manager for Gestures
    func registerGesturesrecognizers() {
        // recognizer for Tap Gesture
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer!)
        
    }
    
    // Remove tap gesture recognizer
    func removeTapGesture() {
        self.sceneView.removeGestureRecognizer(self.tapGestureRecognizer!)
    }
    
    // handler for Tap Gesture for adding scene to plane
    @objc func tapped(sender:UITapGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        if !hitTest.isEmpty {
            self.sceneView.scene.rootNode.enumerateChildNodes{ (childNode, _) in
                if childNode.name == "Vehicle" {
                    childNode.removeFromParentNode()
                }
            }
            
            self.arBrains.vehicle.createVehicleRC(hitTest: hitTest.first!)
            
            // removes the tap gesture
            //self.removeTapGesture()
            
            // hides the feedback label
            self.arBrains.arViewController.hideFeedback()
            
            // show the driving controls
            self.arBrains.arViewController.showDrivingUI()
        }
    }
    
}
