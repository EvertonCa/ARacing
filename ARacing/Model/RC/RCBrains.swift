//
//  SingleARBrains.swift
//  ARacing
//
//  Created by Everton Cardoso on 18/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

class RCBrains {
    
    //MARK: - Global Variables
    
    // ARKit scene View
    var sceneView:ARSCNView!
    
    // World Tracking configuration
    let arConfiguration = ARWorldTrackingConfiguration()
    
    // Grid node
    var gridNode:SCNNode?
    
    // Feedback Label
    var feedbackLabel: UILabel?
    
    // Gestures
    var gesturesBrain:Gestures!
    
    // ViewController
    var arViewController: ARViewController!
    
    // Vehicle
    var vehicle:Vehicle! = nil
    
    // Game
    var game:Game
    
    //MARK: - Functions
    
    init(_ sceneView: ARSCNView, _ view: ARViewController, _ game:Game) {
        self.sceneView = sceneView
        self.arViewController = view
        self.game = game
        self.vehicle = Vehicle(arView: self.arViewController, rcBrains: self, game: self.game, sceneView: self.sceneView)
    }
    
    // setup the view when it loads
    func setupView() {
        
        // debug options - feature points and world origin
        //self.sceneView.debugOptions = [.showFeaturePoints, .showPhysicsShapes, .showBoundingBoxes]
        
        // show statistics
        //self.sceneView.showsStatistics = true
        
        // config to detect horizontal surfaces
        self.arConfiguration.planeDetection = .horizontal
        
        // enables default lighting
        self.sceneView.autoenablesDefaultLighting = true
        
        // run session
        self.sceneView.session.run(arConfiguration, options: [.removeExistingAnchors, .resetTracking])
        
        // setup the gestures recognizer
        self.gesturesBrain = Gestures(arViewController:self.arViewController, sceneView: self.sceneView, rcBrain: self, game: self.game)
        
    }
    
}

