//
//  Gestures.swift
//  ARacing
//
//  Created by Everton Cardoso on 18/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

class GesturesSingleAR {
    
    //MARK: - Variables
    
    // Tap gesture recognizer
    var tapGestureRecognizer:UITapGestureRecognizer?
    
    // Rotation gesture recognizer
    var spinGestureRecognizer:UIRotationGestureRecognizer?
    
    // AR SceneView
    var sceneView:ARSCNView!
    
    // ARBrains
    var arBrains:SingleARBrains!
    
    //MARK: - Functions
    
    init(sceneView: ARSCNView, arBrains:SingleARBrains) {
        self.sceneView = sceneView
        self.arBrains = arBrains
    }
    
    // Manager for Gestures
    func registerGesturesrecognizers() {
        // recognizer for Tap Gesture
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer!)
        
        // recognizer for spin Gesture
        self.spinGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotation))
        self.sceneView.addGestureRecognizer(spinGestureRecognizer!)
        
    }
    
    // Remove rotation gesture recognizer
    func removeRotationGesture() {
        self.sceneView.removeGestureRecognizer(self.spinGestureRecognizer!)
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
            self.arBrains.setupScenery(hitTestResult: hitTest.first!)
            self.arBrains.arViewController.showStartButton()
        }
    }
    
    // handler for Rotation Gesture for fixing location of the Scenary
    @objc func rotation(sender:UIRotationGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let rotationLocation = sender.location(in: sceneView)
        let angle = sender.rotation
        
        let hitTest = sceneView.hitTest(rotationLocation)
        
        if !hitTest.isEmpty {
            if let results = hitTest.first {
                let node = results.node
                
                if node.name == "Track" {
                    let rotateAction = SCNAction.rotateBy(x: 0, y: -angle, z: 0, duration: 0)
                    
                    node.runAction(rotateAction)
                    
                    sender.rotation = 0
                }
            }
        }
    }
}
