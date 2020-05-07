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
        self.sceneView.debugOptions = [.showPhysicsShapes]
        
        // show statistics
        //self.sceneView.showsStatistics = true
        
        // config to detect horizontal surfaces
        self.arConfiguration.planeDetection = .horizontal
        
        // enables default lighting
        self.sceneView.autoenablesDefaultLighting = true
        
        // if the user is Host
        if self.game.multipeerConnectionSelected == Connection.Host.rawValue {
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
            //self.vehicle = Vehicle(arView: self.arViewController, singleBrain: self, game: self.game, sceneView: self.sceneView)
        }
        // if the device is client
        else
        {
            self.multipeerSession.joinSession()
        }
    }
    
    // creates the grid that shows the horizontal surface
    func createGrid(planeAnchor: ARPlaneAnchor) -> SCNNode {
        
        let gridNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
        gridNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Grid")
        gridNode.geometry?.firstMaterial?.isDoubleSided = true
        gridNode.position = SCNVector3(CGFloat(planeAnchor.center.x), CGFloat(planeAnchor.center.y), CGFloat(planeAnchor.center.z))
        gridNode.eulerAngles = SCNVector3(x: Float(90.degreesToRadians), y: 0, z: 0)
        
        gridNode.name = "Grid"
        
        // static is not affected by forces, but it is interact-able
        let staticBody = SCNPhysicsBody.static()
        
        gridNode.physicsBody = staticBody
        
        return gridNode
    }
    
    // adds the scenery and disable gestures and the grid nodes
    func setupMap(hitTestResult: ARHitTestResult) {
        self.mapNode = self.map.addMap(hitTestResult: hitTestResult)
        
        self.gesturesBrain.removeTapGesture()
        
        // changes feedback label
        self.arViewController.showFeedback(text: "Rotate the map to match your surface and press Start to begin!")
        
        // removes all the grids in the scene
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "Grid" {
                node.removeFromParentNode()
            }
        }
    }
    
    //MARK: - Multi-peer functions
    
    // Get AR World Map
    func getARWorldMap() -> ARWorldMap {
        var arWorldMap:ARWorldMap!
        self.sceneView.session.getCurrentWorldMap { worldMap, error in
            guard let safeMap = worldMap
                else { print("Error: \(error!.localizedDescription)"); return }
            arWorldMap = safeMap
        }
        return arWorldMap
    }
    
    // Join session
    func joinARSession(worldMap:ARWorldMap) {
        // sets the received world map as initial world
        self.arConfiguration.initialWorldMap = worldMap
        
        // run session
        self.sceneView.session.run(arConfiguration, options: [.removeExistingAnchors, .resetTracking])
    }
}

//MARK: - Multipeer Session Delegates
extension MultiARBrains: MultipeerSessionDelegate {
    // ARWorldMap received from peer
    func arWorldMapReceived(manager: MultipeerSession, worldMap: ARWorldMap) {
        self.joinARSession(worldMap: worldMap)
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

