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
    init(type: Int, vehicle:Int, view: ARViewController) {
        self.arViewController = view
        self.game = Game(arBrain: self, gameTypeSelected: type, vehicleSelected: vehicle)
    }
    
    init(type: Int, map:Int, vehicle:Int, view: ARViewController) {
        self.arViewController = view
        self.game = Game(arBrain: self, gameTypeSelected: type, mapSelected: map, vehicleSelected: vehicle)
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
    
    // accelerator pressed
    func accPressed() {
        switch self.game.gameTypeSelected {
        case GameMode.SinglePlayer.rawValue:
            self.arViewController.singleARBrain?.vehicle.accelerating = true
        case GameMode.MultiPlayer.rawValue:
            //FIXME: multiplayer accelerator pressed
            break
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
            //FIXME: multiplayer accelerator released
            break
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
            //FIXME: multiplayer brake pressed
            break
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
            //FIXME: multiplayer brake released
            break
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
           //FIXME: multiplayer turn right pressed
           break
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
           //FIXME: multiplayer turn right released
           break
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
            //FIXME: multiplayer turn left pressed
            break
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
            //FIXME: multiplayer turn left released
            break
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
            //FIXME: multiplayer New Node Added
            break
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
            //FIXME: multiplayer Node updated
            break
        case GameMode.RCMode.rawValue:
            self.rcUpdatedNodeRendered(node: node, anchor: anchor)
        default: break
        }
    }
    
    // Node didRemove delegate handler
    func didRemoveNodeRenderer(node: SCNNode, anchor: ARAnchor) {
        node.enumerateChildNodes { ( childNode, _ ) in
            childNode.removeFromParentNode()
        }
    }
    
    // UpdatedAtTime delegate handler
    func updateAtTimeRenderer() {
        switch self.game.gameTypeSelected {
        case GameMode.SinglePlayer.rawValue:
            self.singleUpdateAtTime()
        case GameMode.MultiPlayer.rawValue:
            //FIXME: multiplayer UpdatedAtTime
            break
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
            //FIXME: multiplayer didBegin Contact
            break
        default: break
        }
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
    
    //MARK: - Single Player Functions
    
    // start button pressed in single player mode
    private func singleStartPressed() {
        
        // Stops the timer
        switch self.game.gameTypeSelected {
        case GameMode.SinglePlayer.rawValue:
            self.arViewController.singleARBrain?.lapTimer.stopTimer()
        case GameMode.MultiPlayer.rawValue:
            //FIXME: Lap reset for multiplayer
            break
        default: break
        }
        
        // show vehicle in the view
        self.arViewController.singleARBrain?.vehicle.createVehicleSinglePlayer()
        
        // disable gestures
        self.arViewController.singleARBrain?.gesturesBrain.removeRotationGesture()
        
        // sets the scenery to locked
        self.arViewController.singleARBrain?.map.mapLocked = true
        
        // start the race
        self.arViewController.singleARBrain?.startRace()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            //shows driving UI
            self.arViewController.showDrivingUI()
        }
    }
    
    // node added in single player
    private func singleDidAddNodeRendered(node: SCNNode, anchor: ARAnchor) {
        // if the scenary is not placed, adds the new grid
        if !self.arViewController.singleARBrain!.map.mapPlaced {
            DispatchQueue.main.async {
                // show feedback
                self.arViewController.showFeedback(text: "Click on the grid where you would like to place your map!")
            }
            
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            let gridNode = self.arViewController.singleARBrain!.createGrid(planeAnchor: planeAnchor)
            
            node.addChildNode(gridNode)
        }
    }
    
    // node updated in single player
    private func singleUpdatedNodeRendered(node: SCNNode, anchor: ARAnchor) {
        // if the scenary is not placed, updates the grid to the new size
        if !self.arViewController.singleARBrain!.map.mapPlaced {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            node.enumerateChildNodes { ( childNode, _ ) in
                childNode.removeFromParentNode()
            }
            
            self.arViewController.singleARBrain!.gridNode = node
            
            let gridNode = self.arViewController.singleARBrain!.createGrid(planeAnchor: planeAnchor)
            
            self.arViewController.singleARBrain!.gridNode!.addChildNode(gridNode)
        }
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
        
        if nodeA.physicsBody?.categoryBitMask == BitMaskCategory.Checkpoint.rawValue
            && nodeB.physicsBody?.categoryBitMask == BitMaskCategory.Vehicle.rawValue {
            
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
        else if nodeB.physicsBody?.categoryBitMask == BitMaskCategory.Checkpoint.rawValue
        && nodeA.physicsBody?.categoryBitMask == BitMaskCategory.Vehicle.rawValue {
            
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
    }
    
    //MARK: - Multi Player Functions
    
    // start button pressed in single player mode
    private func multiStartPressed() {
        
    }
    
    //MARK: - RC Mode Functions
    
    // node added in RC Mode
    private func rcDidAddNodeRendered(node: SCNNode, anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        DispatchQueue.main.async {
            // show feedback
            self.arViewController.showFeedback(text: "Click on the grid where you would like to place your RC Car!")
            //FIXME: make the label only appear if the vehicle hasn't spawned yet
        }
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let gridNode = self.arViewController.rcBrains!.createGrid(planeAnchor: planeAnchor)
        
        node.addChildNode(gridNode)
    }
    
    // node updated in RC Mode
    private func rcUpdatedNodeRendered(node: SCNNode, anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        node.enumerateChildNodes { ( childNode, _ ) in
            childNode.removeFromParentNode()
        }
        
        self.arViewController.rcBrains!.gridNode = node
        
        let gridNode = self.arViewController.rcBrains!.createGrid(planeAnchor: planeAnchor)
        self.arViewController.rcBrains!.gridNode!.addChildNode(gridNode)
    }
    
    // updateAtTime in RC mode
    private func rcUpdateAtTime() {
        DispatchQueue.main.async {
            self.arViewController.rcBrains!.vehicle.updatesVehicle()
        }
    }
    
}

