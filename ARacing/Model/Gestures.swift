//
//  Gestures.swift
//  ARacing
//
//  Created by Everton Cardoso on 18/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

class Gestures {
    
    //MARK: - Variables
    
    // ARViewController
    var arViewController:ARViewController
    
    // Tap gesture recognizer
    var tapGestureRecognizer:UITapGestureRecognizer?
    
    // Rotation gesture recognizer
    var spinGestureRecognizer:UIRotationGestureRecognizer?
    
    // AR SceneView
    var sceneView:ARSCNView!
    
    // Single ARBrains
    var singleARBrain:SingleARBrains!
    
    // Multi ARBrains
    var multiARBrains:MultiARBrains!
    
    // RC Brains
    var rcBrains:RCBrains!
    
    // Game
    var game:Game
    
    //MARK: - Functions
    
    // Single player init
    init(arViewController:ARViewController, sceneView: ARSCNView, singleARBrains:SingleARBrains, game:Game) {
        self.arViewController = arViewController
        self.sceneView = sceneView
        self.singleARBrain = singleARBrains
        self.game = game
        self.registerGesturesRecognizers()
    }
    
    // Multi player init
    init(arViewController:ARViewController, sceneView: ARSCNView, multiARBrains:MultiARBrains, game:Game) {
        self.arViewController = arViewController
        self.sceneView = sceneView
        self.multiARBrains = multiARBrains
        self.game = game
        self.registerGesturesRecognizers()
    }
    
    // RC mode init
    init(arViewController:ARViewController, sceneView: ARSCNView, rcBrain:RCBrains, game:Game) {
        self.arViewController = arViewController
        self.sceneView = sceneView
        self.rcBrains = rcBrain
        self.game = game
        self.registerGesturesRecognizers()
    }
    
    // Manager for Gestures
    func registerGesturesRecognizers() {
        
        if self.game.gameTypeSelected != GameMode.RCMode.rawValue {
            // recognizer for spin Gesture
            self.spinGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotation))
            self.spinGestureRecognizer?.name = "SpinGesture"
            self.sceneView.addGestureRecognizer(spinGestureRecognizer!)
            
            // delegate
            self.spinGestureRecognizer?.delegate = self.arViewController
        }
        // recognizer for Tap Gesture
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.tapGestureRecognizer?.name = "TapGesture"
        self.sceneView.addGestureRecognizer(tapGestureRecognizer!)
        
        // delegate
        self.tapGestureRecognizer?.delegate = self.arViewController
    }
    
    // Removes all Gestures Recognizers
    func removeAllGestures() {
        self.sceneView.removeGestureRecognizer(self.spinGestureRecognizer!)
        self.sceneView.removeGestureRecognizer(self.tapGestureRecognizer!)
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
        if self.game.gameTypeSelected == GameMode.RCMode.rawValue{
            let sceneView = sender.view as! ARSCNView
            let tapLocation = sender.location(in: sceneView)
            
            let hitTest = sceneView.hitTest(tapLocation, types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
            
            if !hitTest.isEmpty {
                self.sceneView.scene.rootNode.enumerateChildNodes{ (childNode, _) in
                    if childNode.name == "Vehicle" {
                        DispatchQueue.main.async {
                            childNode.removeFromParentNode()
                        }
                    }
                }
                
                self.rcBrains.vehicle.createVehicleRC(hitTest: hitTest.first!)
                
                // hides the feedback label
                self.rcBrains.arViewController.hideFeedback()
                
                // show the driving controls
                self.rcBrains.arViewController.showDrivingUI()
            }
        }
        else{
            let sceneView = sender.view as! ARSCNView
            let tapLocation = sender.location(in: sceneView)
            
            let hitTest = sceneView.hitTest(tapLocation, types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
            
            if !hitTest.isEmpty {
                if self.game.gameTypeSelected == GameMode.SinglePlayer.rawValue {
                    self.singleARBrain.createMapAnchor(hitTestResult: hitTest.first!)
                    self.singleARBrain.arViewController.showStartButton()
                }
                else {
                    self.multiARBrains.createMapAnchor(hitTestResult: hitTest.first!)
                    self.multiARBrains.arViewController.showStartButton()
                }
            }
        }
        
    }
    
    // handler for Rotation Gesture for fixing location of the Map
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
                    node.physicsBody?.resetTransform()
                    
                    sender.rotation = 0
                }
            }
        }
    }
}

