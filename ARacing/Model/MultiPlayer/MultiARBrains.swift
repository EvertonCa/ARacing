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
    
    // who's winning
    var winning:[Int] = [] {
        didSet {
            self.updateWinning()
        }
    }
    
    // checkpoints won
    var checkpointsWon:Int = 0
    
    //MARK: - Models
    
    // Game
    var game:Game
    
    // Gestures
    var gesturesBrain:Gestures!
    
    // ViewController
    var arViewController:ARViewController!
    
    // Checkpoints
    var checkpoints:Checkpoint!
    
    // Scenery
    var map:Map!
    
    // AR Text
    var arText:SingleTexts!
    
    // Vehicles list
    var vehiclesList:[Vehicle] = []
    
    // ARWorldMap
    var arWorldMap:ARWorldMap?
    
    // Sounds
    var soundController:Sounds!
    
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
        
        // setup checkpoints
        self.checkpoints = Checkpoint(mapNode: self.mapNode, game: self.game)
        
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
        
        // setup sounds
        self.soundController = self.arViewController.sounds
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
        // randomizes the checkpoints
        self.game.randomizeCheckpointsSpawns()
        
        // sends the message to all peers to start the game
        self.multipeerSession.encodeAndSend(message: self.messageStartGame())
        
        // setup the multiplayer
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
        
        //show the Driving UI
        self.arViewController.showDrivingUI()
        
        // Start race
        self.startRace()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            //shows driving UI
            self.arViewController.showDrivingUI()
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
    
    // returns the correct vehicle that this device is moving
    func getRightVehicle() -> Vehicle? {
        if let tempIndex = self.game.peersHashIDs.firstIndex(of: self.multipeerSession.myPeerID.hash) {
            if !self.vehiclesList.isEmpty {
                return self.vehiclesList[tempIndex]
            }
        }
        return nil
    }
    
    // adds the checkpoints with particles in the right place
    func updateCheckpoint() {
        if !self.checkpoints.setupCheckpoints() {
            self.endRace()
        }
    }
    
    // shows the checkpoints, AR Text and starts the timer.
    func startRace() {
        
        // stops the menu music
        self.soundController.stopMusic()
        
        // play the map music
        self.game.playMapMusic()
        
        // shows the Ready AR Text
        var textNode = self.arText.showReadyText()
        textNode.position = SCNVector3(0, 0.6, 0)
        textNode.opacity = 0
        var rootNode = SCNNode()
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "mapAnchorNode"{
                rootNode = node
            }
        }
        rootNode.addChildNode(textNode)
        
        textNode.addAudioPlayer(SCNAudioPlayer(source: self.soundController.readyTextAudioResource))
        
        //animate fade in Ready Text
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        textNode.opacity = 1
        SCNTransaction.commit()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            //animate fade out Ready Text
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            textNode.opacity = 0
            SCNTransaction.completionBlock = {
                // removes the Ready text
                textNode.removeFromParentNode()
                
                // shows the Set AR Text
                textNode = self.arText.showSetText()
                textNode.position = SCNVector3(0, 0.6, 0)
                textNode.opacity = 0
                rootNode.addChildNode(textNode)
                
                textNode.addAudioPlayer(SCNAudioPlayer(source: self.soundController.readyTextAudioResource))
            }
            SCNTransaction.commit()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                //animate fade in Set Text
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                textNode.opacity = 1
                SCNTransaction.commit()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    //animate fade out Set text
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 0.5
                    textNode.opacity = 0
                    SCNTransaction.completionBlock = {
                        // removes the Set text
                        textNode.removeFromParentNode()
                        
                        // shows the GO AR Text
                        textNode = self.arText.showGoText()
                        textNode.position = SCNVector3(0, 0.6, 0)
                        textNode.opacity = 0
                        rootNode.addChildNode(textNode)
                        
                        textNode.addAudioPlayer(SCNAudioPlayer(source: self.soundController.goTextAudioResource))
                        
                        // setup the checkpoints and particles
                        self.updateCheckpoint()
                        
                    }
                    SCNTransaction.commit()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        //animate fade in Go Text
                        SCNTransaction.begin()
                        SCNTransaction.animationDuration = 0.5
                        textNode.opacity = 1
                        SCNTransaction.commit()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            //animate fade out Go Text
                            SCNTransaction.begin()
                            SCNTransaction.animationDuration = 0.5
                            textNode.opacity = 0
                            SCNTransaction.completionBlock = {
                                // removes the Ready text
                                textNode.removeFromParentNode()
                            }
                            SCNTransaction.commit()
                        }
                    }
                }
            }
        }
    }
    
    // ends the race
    func endRace() {
        if self.didWon() {
            self.showGoldTrophy()
        }
    }
    
    // updates the label for who's winning
    func updateWinning() {
        let vehicleID = self.getRightVehicle()!.vehicleNode.hashValue
        self.checkpointsWon = 0
        for i in winning {
            if vehicleID == i{
                checkpointsWon += 1
            }
        }
        let totalCheckpoints = self.game.randomCheckpointSpawn.count
        let checkpointsLeft = totalCheckpoints - winning.count
        
        let checkPointsText = "Checkpoints: \(checkpointsWon) of \(totalCheckpoints)"
        let checkpointsLeftText = "\(checkpointsLeft) checkpoints left"
        
        self.arViewController.showFeedback(text: checkPointsText)
        self.arViewController.updateRecordLabel(text: checkpointsLeftText)
    }
    
    // Check if won
    func didWon() -> Bool {
        if self.checkpointsWon > (self.game.randomCheckpointSpawn.count / 2) {
            return true
        }
        else {
            return false
        }
    }
    
    // Show the Golden Trophy
    func showGoldTrophy() {
        let trophyNode = Trophy.getTrophy()
        trophyNode.enumerateChildNodes { (node, _) in
            if node.name == "TextWinner" {
                if let textGeometry = node.geometry as? SCNText {
                    textGeometry.string = "WINNER!"
                }
            }
        }
        self.mapNode.addChildNode(trophyNode)
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1.0
            self.mapNode.enumerateChildNodes { (node, _) in
                if node.name == "Trophy" {
                    node.opacity = 0.0
                }
            }
            SCNTransaction.completionBlock = {
                self.mapNode.enumerateChildNodes { (node, _) in
                    if node.name == "Trophy" {
                        node.removeFromParentNode()
                    }
                }
            }
            SCNTransaction.commit()
        }
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
        let message = Message(peerHashID: self.multipeerSession.myPeerID.hash, messageType: MessageType.SelectedVehicle.rawValue, selectedVehicle: self.game.vehicleSelected)
        
        return message
    }
    
    // creates a message with all the parameters to start the game
    func messageStartGame() -> Message {
        let message = Message(peerHashID: self.multipeerSession.myPeerID.hash, messageType: MessageType.StartGame.rawValue, peersQuantity: self.game.peersQuantity, peersHashID: self.game.peersHashIDs, randomCheckpoints:self.game.randomCheckpointSpawn, listSelectedVehicles: self.game.listSelectedVehicles)
        
        return message
    }
    
    // creates a message informing the host that the client is ready
    func messageReady() -> Message {
        let message = Message(peerHashID: self.multipeerSession.myPeerID.hash, messageType: MessageType.ClientReady.rawValue)
        
        return message
    }
    
    // creates a message with the changed vehicle control
    func messageVehicleControlChanged(control:Int) -> Message {

        // Transform matrix for the vehicle
        let tempMatrix = self.getRightVehicle()!.vehicleNode.presentation.transform
        let transformMatrixCodable = [[tempMatrix.m11, tempMatrix.m12, tempMatrix.m13, tempMatrix.m14],
                                      [tempMatrix.m21, tempMatrix.m22, tempMatrix.m23, tempMatrix.m24],
                                      [tempMatrix.m31, tempMatrix.m32, tempMatrix.m33, tempMatrix.m34],
                                      [tempMatrix.m41, tempMatrix.m42, tempMatrix.m43, tempMatrix.m44]]
        
        // creates the message with the status
        let message = Message(peerHashID: self.multipeerSession.myPeerID.hash, messageType: control, vehicleTransformMatrix: transformMatrixCodable)
        
        return message
    }
    
    //MARK: - Multi-peer Receiving and decoding functions
    
    // Interpret the received message
    func interpretReceivedMessage(message:Message) {
        switch message.messageType {
        case MessageType.Accelerating.rawValue...MessageType.NotTurningLeft.rawValue:
            self.receiveVehicleControlMessage(message: message)
        case MessageType.ARWorldMapAndTransformMatrix.rawValue:
            self.receivedARWorldMapWithTransformMatrixMessage(message: message)
        case MessageType.SelectedVehicle.rawValue:
            self.receivedVehicleSelectedMessage(message: message)
        case MessageType.StartGame.rawValue:
            self.receivedStartGameMessage(message: message)
        case MessageType.ClientReady.rawValue:
            self.receivedClientReadyMessage(message: message)
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
        self.game.peersReady.append(false)
        self.game.peersQuantity += 1
    }
    
    // handles messages with the information necessary to start the game
    func receivedStartGameMessage(message:Message) {
        // saves the necessary infos in the game class
        self.game.peersQuantity = message.peersQuantity!
        self.game.peersHashIDs = message.peersHashID!
        self.game.listSelectedVehicles = message.listSelectedVehicles!
        self.game.randomCheckpointSpawn = message.randomCheckpoints!
        
        // Starts the game and starts it
        self.setupMultiplayerGame()
    }
    
    // handles messages with client ready information
    func receivedClientReadyMessage(message: Message) {
        let tempIndex = self.game.peersHashIDs.firstIndex(of: message.peerHashID)
        self.game.peersReady[tempIndex!] = true
    }
    
    // handles messages with vehicle driving status
    func receiveVehicleControlMessage(message: Message) {
        // if the device is host, feed to other peers
        if self.game.multipeerConnectionSelected == Connection.Host.rawValue {
            self.multipeerSession.encodeAndSend(message: message)
        }
        
        // updates the received vehicle, if it isn't yourself
        if message.peerHashID != self.multipeerSession.myPeerID.hash {
            if let tempIndex = self.game.peersHashIDs.firstIndex(of: message.peerHashID) {
                if !self.vehiclesList.isEmpty {
                    let vehicle = self.vehiclesList[tempIndex]
                    
                    let tm = message.vehicleTransformMatrix!
                    let transformMatrix4x4 = SCNMatrix4(m11: tm[0][0], m12: tm[0][1], m13: tm[0][2], m14: tm[0][3],
                                                        m21: tm[1][0], m22: tm[1][1], m23: tm[1][2], m24: tm[1][3],
                                                        m31: tm[2][0], m32: tm[2][1], m33: tm[2][2], m34: tm[2][3],
                                                        m41: tm[3][0], m42: tm[3][1], m43: tm[3][2], m44: tm[3][3])
                    
                    vehicle.vehicleNode.transform = transformMatrix4x4
                    
                    switch message.messageType {
                    case MessageType.Accelerating.rawValue:
                        vehicle.accelerating = true
                    case MessageType.NotAccelerating.rawValue:
                        vehicle.accelerating = false
                    case MessageType.Breaking.rawValue:
                        vehicle.breaking = true
                    case MessageType.NotBreaking.rawValue:
                        vehicle.breaking = false
                    case MessageType.TurningRight.rawValue:
                        vehicle.turningRight = true
                    case MessageType.NotTurningRight.rawValue:
                        vehicle.turningRight = false
                    case MessageType.TurningLeft.rawValue:
                        vehicle.turningLeft = true
                    case MessageType.NotTurningLeft.rawValue:
                        vehicle.turningLeft = false
                    default:
                        break
                    }
                }
            }
        }
    }
}

//MARK: - Multipeer Session Delegates
extension MultiARBrains: MultipeerSessionDelegate {
    
    // Message received from peer
    func messageReceived(manager: MultipeerSession, message: Message) {
        interpretReceivedMessage(message: message)
    }
}

