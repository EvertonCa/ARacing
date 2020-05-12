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
    
    // Transform Matrix
    var transformMatrix:SCNMatrix4?
    
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
    
    // Vehicles list
    var vehiclesList:[Vehicle] = []
    
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
            
            // sets the host hash ID in the game list
            self.game.peersHashIDs[0] = self.multipeerSession.myPeerID.hash
            // sets the first vehicle in the list to be the host's
            self.game.listSelectedVehicles[0] = self.game.vehicleSelected
            
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
        
        // changes feedback label
        self.arViewController.showFeedback(text: "Rotate the map to match your surface and press Start to begin!")
    }
    
    // Start Multiplayer after all peers joined
    func finallyStart() {
        self.multipeerSession.encodeAndSend(message: self.messageStartGame())
        self.setupMultiplayerGame()
    }
    
    // Sets up the game
    func setupMultiplayerGame() {
        // instantiate the vehicles and creates the list with them
        for vehicleIndex in 0..<self.game.listSelectedVehicles.count {
            self.vehiclesList.append(Vehicle(arView: self.arViewController, multiARBrain: self, game: self.game, sceneView: self.sceneView, index: vehicleIndex))
        }
        
        // Show vehicles in the view
        for vehicle in self.vehiclesList {
            vehicle.createVehicleMultiPlayer()
        }
    }
    
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
        
        // Set the map flags to placed and locker
        self.map.mapPlaced = true
        self.map.mapLocked = true
        
        // Shows the Start Button
        self.arViewController.showStartButton()
    }
    
    //MARK: - Multi-peer Sending and encoding functions
    
    // Create message for ARWorldMap with transform
    func messageARWorldMap() -> Message {
        let tm = self.mapNode.transform
        let transformMatrixCodable = [[tm.m11, tm.m12, tm.m13, tm.m14],
                                      [tm.m21, tm.m22, tm.m23, tm.m24],
                                      [tm.m31, tm.m32, tm.m33, tm.m34],
                                      [tm.m41, tm.m42, tm.m43, tm.m44]]
        let arWorldMapData = self.multipeerSession.encodeARWorldMap(worldMap: self.arWorldMap!)
        let message = Message(peerHashID: self.multipeerSession.myPeerID.hash, messageType: MessageType.ARWorldMapAndTransformMatrix.rawValue, transform: transformMatrixCodable, arWorldMapData: arWorldMapData)
        
        return message
    }
    
    // creates a message with the selected vehicle info
    func messageVehicleSelected() -> Message {
        let message = Message(peerHashID: self.multipeerSession.myPeerID.hash, messageType: MessageType.SelectedVehicle.rawValue, transform: nil, arWorldMapData: nil, selectedVehicle: self.game.vehicleSelected)
        
        return message
    }
    
    // creates a message with all the parameters to start the game
    func messageStartGame() -> Message {
        let message = Message(peerHashID: self.multipeerSession.myPeerID.hash, messageType: MessageType.StartGame.rawValue, transform: nil, arWorldMapData: nil, selectedVehicle: nil, peersQuantity: self.game.peersQuantity, peersHashID: self.game.peersHashIDs, listSelectedVehicles: self.game.listSelectedVehicles)
        
        return message
    }
    
    //MARK: - Multi-peer Receiving and decoding functions
    
    // Interpret the received message
    func interpretReceivedMessage(message:Message) {
        switch message.messageType {
        case MessageType.ARWorldMapAndTransformMatrix.rawValue:
            self.receivedARWorldMapWithTransformMatrixMessage(message: message)
        case MessageType.SelectedVehicle.rawValue:
            self.receivedVehicleSelectedMessage(message: message)
        case MessageType.StartGame.rawValue:
            self.receivedStartGameMessage(message: message)
        default:
            break
        }
    }
    
    // handles messages with ARWorldMap and transform matrix
    func receivedARWorldMapWithTransformMatrixMessage(message:Message) {
        // decode of the transform matrix
        let tm = message.transform!
        let transformMatrix4x4 = SCNMatrix4(m11: tm[0][0], m12: tm[0][1], m13: tm[0][2], m14: tm[0][3],
                                            m21: tm[1][0], m22: tm[1][1], m23: tm[1][2], m24: tm[1][3],
                                            m31: tm[2][0], m32: tm[2][1], m33: tm[2][2], m34: tm[2][3],
                                            m41: tm[3][0], m42: tm[3][1], m43: tm[3][2], m44: tm[3][3])
        self.transformMatrix = transformMatrix4x4
        
        // decode of the ARWorldMap
        do {
            if let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: message.arWorldMapData!){
                self.arWorldMap = worldMap
                // loads the received world map
                self.loadReceivedARWorldMap()
            }
        } catch {
            print("can't decode world map received from")
        }
    }
    
    // handles messages with vehicle selected info
    func receivedVehicleSelectedMessage(message:Message) {
        // adds the peer and vehicle selected to the game controls
        self.game.peersHashIDs.append(message.peerHashID)
        self.game.listSelectedVehicles.append(message.selectedVehicle!)
        self.game.peersQuantity += 1
    }
    
    // handles messages with the information necessary to start the game
    func receivedStartGameMessage(message:Message) {
        // saves the necessary infos in the game class
        self.game.peersQuantity = message.peersQuantity!
        self.game.peersHashIDs = message.peersHashID!
        self.game.listSelectedVehicles = message.listSelectedVehicles!
        // Starts the game and starts it
        self.setupMultiplayerGame()
    }

}

//MARK: - Multipeer Session Delegates
extension MultiARBrains: MultipeerSessionDelegate {
    
    // Message received from peer
    func messageReceived(manager: MultipeerSession, message: Message) {
        interpretReceivedMessage(message: message)
    }
}

