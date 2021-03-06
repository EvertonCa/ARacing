//
//  ARBrain.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 30/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import UIKit
import ARKit

class ARBrain {
    //MARK: - Constants and Variables
    
    // Game class
    var game:Game!
    
    // ARViewController
    var arViewController:ARViewController
    
    // initializers
    init(game:Game, view: ARViewController) {
        self.arViewController = view
        self.game = game
        self.game.arBrain = self
    }
    
    //MARK: - Buttons Handlers
    
    // start button pressed
    func startButtonPressed() {
        switch self.game.gameTypeSelected {
        case GameMode.SinglePlayer.rawValue:
            self.singleStartPressed()
        case GameMode.MultiPlayer.rawValue:
            self.multiStartPressed()
        default: break
        }
    }
    
    // Begin Hosting Button Pressed
    func beginHostingPressed() {
        self.beginHost()
    }
    
    // accelerator pressed
    func accPressed() {
        switch self.game.gameTypeSelected {
        case GameMode.SinglePlayer.rawValue:
            self.arViewController.singleARBrain?.vehicle.accelerating = true
            
        case GameMode.MultiPlayer.rawValue:
            self.arViewController.multiARBrain?.multipeerSession.encodeAndSend(message: (self.arViewController.multiARBrain!.messageVehicleControlChanged(control: MessageType.Accelerating.rawValue)))
            self.arViewController.multiARBrain?.getRightVehicle()!.accelerating = true
            
        case GameMode.RCMode.rawValue:
            self.arViewController.rcBrains?.vehicle.accelerating = true
        default: break
        }
    }
    
    // accelerator released
    func accReleased() {
        switch self.game.gameTypeSelected {
        case GameMode.SinglePlayer.rawValue:
            self.arViewController.singleARBrain?.vehicle.accelerating = false
            
        case GameMode.MultiPlayer.rawValue:
            self.arViewController.multiARBrain?.multipeerSession.encodeAndSend(message: (self.arViewController.multiARBrain!.messageVehicleControlChanged(control: MessageType.NotAccelerating.rawValue)))
            self.arViewController.multiARBrain?.getRightVehicle()!.accelerating = false
            
        case GameMode.RCMode.rawValue:
            self.arViewController.rcBrains?.vehicle.accelerating = false
        default: break
        }
    }
    
    // brake pressed
    func brakePressed() {
        switch self.game.gameTypeSelected {
        case GameMode.SinglePlayer.rawValue:
            self.arViewController.singleARBrain?.vehicle.breaking = true
            
        case GameMode.MultiPlayer.rawValue:
            self.arViewController.multiARBrain?.multipeerSession.encodeAndSend(message: (self.arViewController.multiARBrain!.messageVehicleControlChanged(control: MessageType.Breaking.rawValue)))
            self.arViewController.multiARBrain?.getRightVehicle()!.breaking = true
            
        case GameMode.RCMode.rawValue:
            self.arViewController.rcBrains?.vehicle.breaking = true
        default: break
        }
    }
    
    // brake released
    func brakeReleased() {
        switch self.game.gameTypeSelected {
        case GameMode.SinglePlayer.rawValue:
            self.arViewController.singleARBrain?.vehicle.breaking = false
            
        case GameMode.MultiPlayer.rawValue:
            self.arViewController.multiARBrain?.multipeerSession.encodeAndSend(message: (self.arViewController.multiARBrain!.messageVehicleControlChanged(control: MessageType.NotBreaking.rawValue)))
            self.arViewController.multiARBrain?.getRightVehicle()!.breaking = false
            
        case GameMode.RCMode.rawValue:
            self.arViewController.rcBrains?.vehicle.breaking = false
        default: break
        }
    }
    
    // turn right pressed
   func turnRightPressed() {
       switch self.game.gameTypeSelected {
       case GameMode.SinglePlayer.rawValue:
           self.arViewController.singleARBrain?.vehicle.turningRight = true
        
       case GameMode.MultiPlayer.rawValue:
            self.arViewController.multiARBrain?.multipeerSession.encodeAndSend(message: (self.arViewController.multiARBrain!.messageVehicleControlChanged(control: MessageType.TurningRight.rawValue)))
           self.arViewController.multiARBrain?.getRightVehicle()!.turningRight = true
           
       case GameMode.RCMode.rawValue:
           self.arViewController.rcBrains?.vehicle.turningRight = true
       default: break
       }
   }
       
   // turn right released
   func turnRightReleased() {
       switch self.game.gameTypeSelected {
       case GameMode.SinglePlayer.rawValue:
           self.arViewController.singleARBrain?.vehicle.turningRight = false
        
       case GameMode.MultiPlayer.rawValue:
            self.arViewController.multiARBrain?.multipeerSession.encodeAndSend(message: (self.arViewController.multiARBrain!.messageVehicleControlChanged(control: MessageType.NotTurningRight.rawValue)))
           self.arViewController.multiARBrain?.getRightVehicle()!.turningRight = false
           
       case GameMode.RCMode.rawValue:
           self.arViewController.rcBrains?.vehicle.turningRight = false
       default: break
       }
   }
    
    // turn left pressed
    func turnLeftPressed() {
        switch self.game.gameTypeSelected {
        case GameMode.SinglePlayer.rawValue:
            self.arViewController.singleARBrain?.vehicle.turningLeft = true
            
        case GameMode.MultiPlayer.rawValue:
            self.arViewController.multiARBrain?.multipeerSession.encodeAndSend(message: (self.arViewController.multiARBrain!.messageVehicleControlChanged(control: MessageType.TurningLeft.rawValue)))
            self.arViewController.multiARBrain?.getRightVehicle()!.turningLeft = true
            
        case GameMode.RCMode.rawValue:
            self.arViewController.rcBrains?.vehicle.turningLeft = true
        default: break
        }
    }
    
    // turn left released
    func turnLeftReleased() {
        switch self.game.gameTypeSelected {
        case GameMode.SinglePlayer.rawValue:
            self.arViewController.singleARBrain?.vehicle.turningLeft = false
            
        case GameMode.MultiPlayer.rawValue:
            self.arViewController.multiARBrain?.multipeerSession.encodeAndSend(message: (self.arViewController.multiARBrain!.messageVehicleControlChanged(control: MessageType.NotTurningLeft.rawValue)))
            self.arViewController.multiARBrain?.getRightVehicle()!.turningLeft = false
            
        case GameMode.RCMode.rawValue:
            self.arViewController.rcBrains?.vehicle.turningLeft = false
        default: break
        }
    }
    
    //MARK: - Delegates Handlers
    
    // New Node Added delegate handler
    func didAddNodeRenderer(node: SCNNode, anchor: ARAnchor) {
        switch self.game.gameTypeSelected {
        case GameMode.SinglePlayer.rawValue:
            self.singleDidAddNodeRendered(node: node, anchor: anchor)
        case GameMode.MultiPlayer.rawValue:
            self.multiDidAddNodeRendered(node: node, anchor: anchor)
        case GameMode.RCMode.rawValue:
            self.rcDidAddNodeRendered(node: node, anchor: anchor)
        default: break
        }
    }
    
    // Node updated delegate handler
    func didUpdateNodeRenderer(node: SCNNode, anchor: ARAnchor) {
        switch self.game.gameTypeSelected {
        case GameMode.SinglePlayer.rawValue:
            self.singleUpdatedNodeRendered(node: node, anchor: anchor)
        case GameMode.MultiPlayer.rawValue:
            self.multiUpdatedNodeRendered(node: node, anchor: anchor)
        case GameMode.RCMode.rawValue:
            self.rcUpdatedNodeRendered(node: node, anchor: anchor)
        default: break
        }
    }
    
    // Node didRemove delegate handler
    func didRemoveNodeRenderer(node: SCNNode, anchor: ARAnchor) {
        DispatchQueue.main.async {
            node.enumerateChildNodes { ( childNode, _ ) in
                childNode.removeFromParentNode()
            }
        }
    }
    
    // UpdatedAtTime delegate handler
    func updateAtTimeRenderer() {
        switch self.game.gameTypeSelected {
        case GameMode.SinglePlayer.rawValue:
            self.singleUpdateAtTime()
        case GameMode.MultiPlayer.rawValue:
            self.multiUpdateAtTime()
        case GameMode.RCMode.rawValue:
            self.rcUpdateAtTime()
        default: break
        }
    }
    
    // didBegin Contact delegate handler
    func didBeginContact(contact: SCNPhysicsContact) {
        switch self.game.gameTypeSelected {
        case GameMode.SinglePlayer.rawValue:
            self.singleDidBeginContact(contact: contact)
        case GameMode.MultiPlayer.rawValue:
            self.multiDidBeginContact(contact: contact)
        default: break
        }
    }
    
    // cameraDidChangeTrackingState delegate handler
    func cameraDidChangeTrackingState(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        self.updateFeedbackLabel(for: frame, trackingState: trackingState)
    }
    
    // Check Mapping Status
    func sessionDidUpdate(frame: ARFrame) {
        if self.game.gameTypeSelected == GameMode.MultiPlayer.rawValue &&
            self.game.multipeerConnectionSelected == Connection.Host.rawValue {
            switch frame.worldMappingStatus {
            case .notAvailable, .limited:
                self.arViewController.multiARBrain?.multipeerSession.canSendMap = false
            case .extending:
                self.arViewController.multiARBrain?.multipeerSession.canSendMap = true
            case .mapped:
                self.arViewController.multiARBrain?.multipeerSession.canSendMap = true
            @unknown default:
                self.arViewController.multiARBrain?.multipeerSession.canSendMap = false
            }
        }
        self.arViewController.trackingFeedbackImage.alpha = 1.0
        self.arViewController.trackingFeedbackImage.image = UIImage(named: frame.worldMappingStatus.description)
        self.updateFeedbackLabel(for: frame, trackingState: frame.camera.trackingState)
        
    }
    
    //MARK: - Other Global Functions
    
    // reset AR Experience
    func resetExperience() {
        self.arViewController.sceneView.session.pause()
        self.arViewController.resetDelegates()
        
        self.arViewController.sceneView.scene.removeAllParticleSystems()
        self.arViewController.sceneView.scene.rootNode.enumerateChildNodes{ (node, _) in
            node.removeFromParentNode()
        }
        
        // hide all the UI
        self.arViewController.hideUI()
        
        // Starts the AR view with temporary configuration
        let tempConfig = ARWorldTrackingConfiguration()
        self.arViewController.sceneView.session.run(tempConfig)
        
        self.arViewController.goToOptionsViewController()
    }
    
    // Creates the surface node with the grid
    func updateSurfaceNode(node: SCNNode, anchor: ARAnchor) {
        if node.name == "surfaceAnchorNode" {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            DispatchQueue.main.async {
                node.enumerateChildNodes { ( childNode, _ ) in
                    childNode.removeFromParentNode()
                }
                let gridNode = Grid.createGrid(planeAnchor: planeAnchor)
                
                node.addChildNode(gridNode)
            }
        }
    }
    
    // updates the feedback label
    func updateFeedbackLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        // Update the UI to provide feedback on the state of the AR experience.
        let message: String
        
        switch trackingState {
        case .normal where frame.anchors.isEmpty:
            // No planes detected; provide instructions for this app's AR interactions.
            message = "Move around to map the environment."
            
        case .notAvailable:
            message = "Tracking unavailable."
            
        case .limited(.excessiveMotion):
            message = "Move the device more slowly."
            
        case .limited(.insufficientFeatures):
            message = "Point the device at an area with visible surface detail, or improve lighting conditions."
            
        case .limited(.relocalizing):
            message = "Resuming Session - Move to where the map is."
            
        case .limited(.initializing):
            message = "Initializing AR session."
            
        default:
            // No feedback needed when tracking is normal and planes are visible.
            // (Nor when in unreachable limited-tracking states.)
            message = ""
            
        }
        if message.isEmpty {
            self.arViewController.hideTrackingFeedback()
        }
        else {
            self.arViewController.showTrackingFeedback(message: message)
        }
    }
    
    //MARK: - Single Player Functions
    
    // start button pressed in single player mode
    private func singleStartPressed() {
        
        // Stops the timer
        self.arViewController.singleARBrain?.lapTimer.stopTimer()
        
        // show vehicle in the view
        self.arViewController.singleARBrain?.vehicle.createVehicleSinglePlayer()
        
        // sets the scenery to locked
        self.arViewController.singleARBrain?.map.mapLocked = true
        
        // start the race
        self.arViewController.singleARBrain?.startRace()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            //shows driving UI
            self.arViewController.showDrivingUI()
            
            // show and update record label
            self.arViewController.recordLabel.alpha = 1
            self.arViewController.recordLabel.text = self.arViewController.singleARBrain?.getRecordText()
        }
    }
    
    // node added in single player
    private func singleDidAddNodeRendered(node: SCNNode, anchor: ARAnchor) {
        // if the scenery is not placed, adds the new grid
        if node.name == "mapAnchorNode" {
            DispatchQueue.main.async {
                self.arViewController.singleARBrain!.mapNode = self.arViewController.singleARBrain!.map.addMap()
                self.arViewController.singleARBrain!.checkpoints.map = self.arViewController.singleARBrain!.mapNode
                
                node.addChildNode(self.arViewController.singleARBrain!.mapNode)
                
                self.arViewController.singleARBrain!.checkpoints.map.addAudioPlayer(self.game.playAmbientSound())
                self.arViewController.sceneView.scene.rootNode.enumerateChildNodes { (SCNNode, _) in
                    if node.name == "surfaceAnchorNode"{
                        node.removeFromParentNode()
                    }
                }
            }
        }
        else if node.name == "surfaceAnchorNode" {
            self.updateSurfaceNode(node: node, anchor: anchor)
        }
    }
    
    // node updated in single player
    private func singleUpdatedNodeRendered(node: SCNNode, anchor: ARAnchor) {
        self.updateSurfaceNode(node: node, anchor: anchor)
    }
    
    // updateAtTime in single player
    private func singleUpdateAtTime() {
        DispatchQueue.main.async {
            // updates vehicle
            self.arViewController.singleARBrain!.vehicle.updatesVehicle()
            
            //updates text look at
            self.arViewController.singleARBrain!.arText.lookAtCamera(sceneView: self.arViewController.sceneView, sceneryNode: self.arViewController.singleARBrain!.mapNode)
        }
    }
    
    // didBegin Contact in single player
    private func singleDidBeginContact(contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        if nodeA.physicsBody?.categoryBitMask == CategoryBitmask.Checkpoint.rawValue
            && nodeB.physicsBody?.categoryBitMask == CategoryBitmask.Vehicle.rawValue {
            
            nodeA.physicsBody?.categoryBitMask = 0

            // sets the new spawn coordinate for the vehicle to be the collided checkpoint
            self.arViewController.singleARBrain!.vehicle.spawnPosition = nodeA.position
            
            // removes the node
            nodeA.removeFromParentNode()
            // calls another checkpoint
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.arViewController.singleARBrain!.updateCheckpoint()
            }
        }
        else if nodeB.physicsBody?.categoryBitMask == CategoryBitmask.Checkpoint.rawValue
        && nodeA.physicsBody?.categoryBitMask == CategoryBitmask.Vehicle.rawValue {
            
            nodeB.physicsBody?.categoryBitMask = 0
            
            // sets the new spawn coordinate for the vehicle to be the collided checkpoint
            self.arViewController.singleARBrain!.vehicle.spawnPosition = nodeB.position

            // removes the node
            nodeB.removeFromParentNode()
            // calls another checkpoint
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.arViewController.singleARBrain!.updateCheckpoint()
            }
            
        }
        else {
            if nodeA.physicsBody?.categoryBitMask == CategoryBitmask.Vehicle.rawValue {
                nodeA.removeAllAudioPlayers()
                nodeA.addAudioPlayer(SCNAudioPlayer(source: self.arViewController.sounds.crashAudioResource))
            }
            else if nodeB.physicsBody?.categoryBitMask == CategoryBitmask.Vehicle.rawValue {
                nodeB.removeAllAudioPlayers()
                nodeB.addAudioPlayer(SCNAudioPlayer(source: self.arViewController.sounds.crashAudioResource))
            }
        }
    }
    
    //MARK: - Multi Player Functions
    
    // start button pressed in single player mode
    private func multiStartPressed() {
        // If the device is Host
        if self.arViewController.multiARBrain?.game.multipeerConnectionSelected == Connection.Host.rawValue {
            self.arViewController.multiARBrain?.finallyStart()
        }
        // If the device is Client, sends a message saying that the client is ready
        else {
            self.arViewController.multiARBrain?.multipeerSession.encodeAndSend(message: self.arViewController.multiARBrain!.messageReady())
        }
    }
    
    // Begin Hosting Pressed
    private func beginHost() {
        // sets the scenery to locked
        self.arViewController.multiARBrain?.map.mapLocked = true
        self.arViewController.multiARBrain?.multipeerSession.startHosting()
        self.arViewController.multiARBrain?.getARWorldMap()
    }
    
    // node added in multi player
    private func multiDidAddNodeRendered(node: SCNNode, anchor: ARAnchor) {
        if node.name == "mapAnchorNode" {
            DispatchQueue.main.async {
                // creates the map node
                self.arViewController.multiARBrain!.mapNode = self.arViewController.multiARBrain!.map.addMap()
                self.arViewController.multiARBrain!.checkpoints.map = self.arViewController.multiARBrain!.mapNode
                // checks if the transformMatrix exists, and if true, applies it
                if let safeTransform = self.arViewController.multiARBrain!.transformMatrix {
                    self.arViewController.multiARBrain!.mapNode.transform = safeTransform
                }
                node.addChildNode(self.arViewController.multiARBrain!.mapNode)
                
                self.arViewController.multiARBrain!.checkpoints.map.addAudioPlayer(self.game.playAmbientSound())
                
                self.arViewController.sceneView.scene.rootNode.enumerateChildNodes { (SCNNode, _) in
                    if node.name == "surfaceAnchorNode"{
                        node.removeFromParentNode()
                    }
                }
            }
        }
        else if node.name == "surfaceAnchorNode" && self.game.multipeerConnectionSelected == Connection.Host.rawValue {
            self.updateSurfaceNode(node: node, anchor: anchor)
        }
    }
    
    // node updated in multi player
    private func multiUpdatedNodeRendered(node: SCNNode, anchor: ARAnchor) {
        if self.game.multipeerConnectionSelected == Connection.Host.rawValue {
            self.updateSurfaceNode(node: node, anchor: anchor)
        }
    }
    
    // updateAtTime in multi player
    private func multiUpdateAtTime() {
        DispatchQueue.main.async {
            // updates vehicle
            for vehicle in self.arViewController.multiARBrain!.vehiclesList {
                vehicle.updatesVehicle()
            }
            
            //updates text look at
            self.arViewController.multiARBrain!.arText.lookAtCamera(sceneView: self.arViewController.sceneView, sceneryNode: self.arViewController.multiARBrain!.mapNode)
        }
    }
    
    // didBegin Contact in multi player
    private func multiDidBeginContact(contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        
        if nodeA.physicsBody?.categoryBitMask == CategoryBitmask.Checkpoint.rawValue
            && nodeB.physicsBody?.categoryBitMask == CategoryBitmask.Vehicle.rawValue {
            
            nodeA.physicsBody?.categoryBitMask = 0
            
            // sets the new spawn coordinate for the vehicle to be the collided checkpoint
            for vehicle in self.arViewController.multiARBrain!.vehiclesList {
                if vehicle.vehicleNode.hashValue == nodeB.hashValue {
                    vehicle.spawnPosition = nodeA.position
                    self.arViewController.multiARBrain!.winning.append(vehicle.vehicleNode.hashValue)
                }
            }
            
            // removes the node
            nodeA.removeFromParentNode()
            // calls another checkpoint
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.arViewController.multiARBrain!.updateCheckpoint()
            }
        }
        else if nodeB.physicsBody?.categoryBitMask == CategoryBitmask.Checkpoint.rawValue
            && nodeA.physicsBody?.categoryBitMask == CategoryBitmask.Vehicle.rawValue {
            
            nodeB.physicsBody?.categoryBitMask = 0

            // sets the new spawn coordinate for the vehicle to be the collided checkpoint
            for vehicle in self.arViewController.multiARBrain!.vehiclesList {
                if vehicle.vehicleNode.hashValue == nodeA.hashValue {
                    vehicle.spawnPosition = nodeB.position
                    self.arViewController.multiARBrain!.winning.append(vehicle.vehicleNode.hashValue)
                }
            }
            
            // removes the node
            nodeB.removeFromParentNode()
            // calls another checkpoint
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.arViewController.multiARBrain!.updateCheckpoint()
            }
            
        }
        else {
            if nodeA.physicsBody?.categoryBitMask == CategoryBitmask.Vehicle.rawValue {
                nodeA.removeAllAudioPlayers()
                nodeA.addAudioPlayer(SCNAudioPlayer(source: self.arViewController.sounds.crashAudioResource))
            }
            else if nodeB.physicsBody?.categoryBitMask == CategoryBitmask.Vehicle.rawValue {
                nodeB.removeAllAudioPlayers()
                nodeB.addAudioPlayer(SCNAudioPlayer(source: self.arViewController.sounds.crashAudioResource))
            }
        }
    }
    
    //MARK: - RC Mode Functions
    
    // node added in RC Mode
    private func rcDidAddNodeRendered(node: SCNNode, anchor: ARAnchor) {
        if !self.arViewController.rcBrains!.floorCreated {
            guard anchor is ARPlaneAnchor else { return }
            DispatchQueue.main.async {
                // show feedback
                self.arViewController.showFeedback(text: "Click where you would like to place your RC Car!")
                //FIXME: make the label only appear if the vehicle hasn't spawned yet
            }
            
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            let gridNode = Grid.rcGrid(planeAnchor: planeAnchor)
            
            node.addChildNode(gridNode)
            
            self.arViewController.rcBrains!.floorCreated = true
        }
    }
    
    // node updated in RC Mode
    private func rcUpdatedNodeRendered(node: SCNNode, anchor: ARAnchor) {
        
    }
    
    // updateAtTime in RC mode
    private func rcUpdateAtTime() {
        DispatchQueue.main.async {
            self.arViewController.rcBrains!.vehicle.updatesVehicle()
        }
    }
    
}

