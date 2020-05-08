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
    
    // Feedback Label
    var feedbackLabel:UILabel?
    
    // Can send world map
    var canSendWorldMap = false
    
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
    
    // ARWorldMap
    var arWorldMap:ARWorldMap?
    
    //MARK: - Functions
    
    init(_ sceneView: ARSCNView, _ view: ARViewController, _ game:Game) {
        self.sceneView = sceneView
        self.arViewController = view
        self.game = game
        self.setupMultipeer()
    }
    
    // setup Multipeer Connectivity
    func setupMultipeer() {
        // Multipeer setup
        self.multipeerSession = MultipeerSession(view: self.arViewController, multiBrain: self)
        self.multipeerSession.delegate = self
    }
    
    // setup the view when it loads
    func setupView() {
        
        // debug options - feature points and world origin
        self.sceneView.debugOptions = [.showFeaturePoints]
        
        // show statistics
        //self.sceneView.showsStatistics = true
        
        // config to detect horizontal surfaces
        self.arConfiguration.planeDetection = .horizontal
        
        // enables default lighting
        self.sceneView.autoenablesDefaultLighting = true
        
        // setup the gestures recognizer
        self.gesturesBrain = Gestures(arViewController:self.arViewController, sceneView: self.sceneView, multiARBrains: self, game: self.game)
        
        // setup scenery
        self.map = Map(mapNode: self.mapNode, sceneView: self.sceneView, game: self.game)
        
        // setup AR Text
        self.arText = SingleTexts()
        
        // if the user is Host
        if self.game.multipeerConnectionSelected == Connection.Host.rawValue {
            // run session
            self.sceneView.session.run(arConfiguration, options: [.removeExistingAnchors, .resetTracking])
            
            // setup Vehicles
            //self.vehicle = Vehicle(arView: self.arViewController, singleBrain: self, game: self.game, sceneView: self.sceneView)
        }
        // if the device is client
        else
        {
            self.multipeerSession.joinSession()
        }
    }
    
    // adds the scenery and disable gestures and the grid nodes
    func createMapAnchor(hitTestResult: ARHitTestResult) {
        // Place the anchor for the map
        let mapAnchor = ARAnchor(name: "map", transform: hitTestResult.worldTransform)
        self.sceneView.session.add(anchor: mapAnchor)
        
        self.gesturesBrain.removeTapGesture()
        
        // changes feedback label
        self.arViewController.showFeedback(text: "Rotate the map to match your surface and press Start to begin!")
    }
    
    //MARK: - Multi-peer functions
    
    // Get AR World Map
    func getARWorldMap() {
        self.sceneView.session.getCurrentWorldMap { (worldMap, error) in
            guard let safeWorldMap = worldMap else {
                print("Can't get current world map")
                return
            }
            self.arWorldMap = safeWorldMap
        }
    }
    
    // Join session
    func loadReceivedARWorldMap() {
        // sets the received world map as initial world
        self.arConfiguration.initialWorldMap = self.arWorldMap
        
        // run session
        self.sceneView.session.run(arConfiguration, options: [.removeExistingAnchors, .resetTracking])
        
        print("AR loaded")
    }
}

//MARK: - Multipeer Session Delegates
extension MultiARBrains: MultipeerSessionDelegate {
    // ARWorldMap received from peer
    func arWorldMapReceived(manager: MultipeerSession, worldMap: ARWorldMap) {
        self.arWorldMap = worldMap
    }
    
    // Handles changes in the list of connected peers
    func connectedDevicesChanged(manager: MultipeerSession, connectedDevices: [String]) {
        print(connectedDevices)
    }
    
    // Message received from peer
    func messageReceived(manager: MultipeerSession, message: Message) {
        print(message.name)
    }
}

