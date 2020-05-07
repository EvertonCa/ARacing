//
//  MultiARBrains.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 06/05/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit
import MultipeerConnectivity

class MultiARBrains {
    
    //MARK: - Global Variables
    
    // ARKit scene View
    var sceneView:ARSCNView!
    
    // Multipeer
    var multipeerSession:MultipeerSession!
    
    // World Tracking configuration
    let arConfiguration = ARWorldTrackingConfiguration()
    
    // Scenery
    var mapNode = SCNNode()
    
    // Grid node
    var gridNode:SCNNode?
    
    // Feedback Label
    var feedbackLabel:UILabel?
    
    //MARK: - Models
    
    // Game
    var game:Game
    
    // Gestures
    var gesturesBrain:Gestures!
    
    // ViewController
    var arViewController:ARViewController!
    
    // Checkpoints
    var checkpoints:SingleCheckpoint!
    
    // Scenery
    var map:Map!
    
    // AR Text
    var arText:SingleTexts!
    
    // Vehicles
    var vehicle:Vehicle! = nil
    
    //MARK: - Functions
    
    init(_ sceneView: ARSCNView, _ view: ARViewController, _ game:Game) {
        self.sceneView = sceneView
        self.arViewController = view
        self.game = game
    }
    
    // setup the view when it loads
    func setupView() {
        
        // debug options - feature points and world origin
        self.sceneView.debugOptions = [.showPhysicsShapes]
        
        // show statistics
        //self.sceneView.showsStatistics = true
        
        // config to detect horizontal surfaces
        self.arConfiguration.planeDetection = .horizontal
        
        // enables default lighting
        self.sceneView.autoenablesDefaultLighting = true
        
        // run session
        self.sceneView.session.run(arConfiguration, options: [.removeExistingAnchors, .resetTracking])
        
        // setup the gestures recognizer
        self.gesturesBrain = Gestures(sceneView: self.sceneView, multiARBrains: self, game: self.game)
        self.gesturesBrain.registerGesturesRecognizers()
        
        // setup scenery
        self.map = Map(mapNode: self.mapNode, sceneView: self.sceneView, game: self.game)
        
        // setup AR Text
        self.arText = SingleTexts()
        
        // setup Vehicles
        self.vehicle = Vehicle(arView: self.arViewController, singleBrain: self, game: self.game, sceneView: self.sceneView)
        
        // Multipeer setup
        self.multipeerSession = MultipeerSession(view: self.arViewController)
        self.multipeerSession.delegate = self
        
    }
    
    //MARK: - Multi-peer functions
    
    // Send the anchor info to peers, so they can place the same content.
    func sendAnchor() {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: anchor, requiringSecureCoding: true)
            else { fatalError("can't encode anchor") }
        self.multipeerSession.sendToAllPeers(data)
    }
}

//MARK: - Multipeer Session Delegates
extension MultiARBrains: MultipeerSessionDelegate {
    
}

