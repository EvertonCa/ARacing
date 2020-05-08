//
//  SIngleARViewControllerDelegates.swift
//  ARacing
//
//  Created by Everton Cardoso on 15/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

//MARK: - Options Segue Delegate

extension ARViewController: OptionViewDelegate{
    // which option was selected
    func passSelectedOption(selectedOption: Int) {
        switch selectedOption{
        case GameMode.SinglePlayer.rawValue:
            self.game.gameTypeSelected = GameMode.SinglePlayer.rawValue
            self.singlePlayerSelected()
            self.goToMapsViewController()
            
        case GameMode.MultiPlayer.rawValue:
            self.game.gameTypeSelected = GameMode.MultiPlayer.rawValue
            self.multiPlayerSelected()
            self.goToMultiPeerViewController()
            
        case GameMode.RCMode.rawValue:
            self.game.gameTypeSelected = GameMode.RCMode.rawValue
            self.rcModeSelected()
            self.goToVehicleSelectionViewController()
        default: break
        }
    }
}

//MARK: - Maps Segue Delegate
extension ARViewController: MapViewDelegate {
    func passMapSelected(mapSelected: Int) {
        self.game.mapSelected = mapSelected
        
        self.goToVehicleSelectionViewController()
    }
}

//MARK: - Vehicle Selection Segue Delegate
extension ARViewController: VehicleSelectionDelegate {
    func passSelectedVehicle(selectedOption: Int) {
        self.game.vehicleSelected = selectedOption
        
        switch self.game.gameTypeSelected {
        case GameMode.SinglePlayer.rawValue:
            self.startSinglePlayer()
            
        case GameMode.MultiPlayer.rawValue:
            self.startMultiPlayer()
            
        case GameMode.RCMode.rawValue:
            self.startRC()
            
        default: break
        }
    }
}

//MARK: - Multipeer Selection Segue Delegate
extension ARViewController: MultiPeerViewDelegate {
    func passSelectedConnection(selectedConnection: Int) {
        self.game.multipeerConnectionSelected = selectedConnection
        
        switch selectedConnection {
        case Connection.Host.rawValue:
            self.goToMapsViewController()
            
        case Connection.Join.rawValue:
            self.goToVehicleSelectionViewController()
            
        default:
            break
        }
    }
}


//MARK: - ARSCNViewDelegate
extension ARViewController: ARSCNViewDelegate {
    
    // when a anchor is detected
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        self.arBrain.didAddNodeRenderer(node: node, anchor: anchor)
    }
    
    // creates a node for each new anchor detected
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if anchor.name == "map" {
            node.name = "mapAnchorNode"
        } else {
            node.name = "surfaceAnchorNode"
        }
        return node
    }
    
    //when the anchor is updated
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        self.arBrain.didUpdateNodeRenderer(node: node, anchor: anchor)
    }
    
    //when the anchor is removed
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        self.arBrain.didRemoveNodeRenderer(node: node, anchor: anchor)
    }
    
    // used for vehicle and physics updates
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        self.arBrain.updateAtTimeRenderer()
    }
}

//MARK: - ARSessionDelegate

extension ARViewController: ARSessionDelegate {
    
    // when camera's tracking state changed
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        self.arBrain.cameraDidChangeTrackingState(for: session.currentFrame!, trackingState: camera.trackingState)
    }
    
    // Check Mapping Status
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        self.arBrain.sessionDidUpdate(frame: frame)
    }
}

//MARK: - SCNPhysicsContactDelegate
extension ARViewController: SCNPhysicsContactDelegate {
    
    // checks collision in the scene
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        self.arBrain.didBeginContact(contact: contact)
    }
}

//MARK: - Gesture Recognizer Delegate
extension ARViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        switch self.game.gameTypeSelected {
        case GameMode.SinglePlayer.rawValue:
            // Single player with map NOT PLACED = enable tap gesture and disable spin gesture
            if !self.singleARBrain!.map.mapPlaced {
                if gestureRecognizer.name == "TapGesture" {
                    return true
                }
                else if gestureRecognizer.name == "SpinGesture" {
                    return false
                }
            }
            // Single player with map placed but NOT locked = disable tap gesture and enable spin gesture
            else if self.singleARBrain!.map.mapPlaced && !self.singleARBrain!.map.mapLocked {
                if gestureRecognizer.name == "TapGesture" {
                    return false
                }
                else if gestureRecognizer.name == "SpinGesture" {
                    return true
                }
            }
            // Single player with map placed and locked = disable all gestures
            else {
                return false
            }
            
        case GameMode.MultiPlayer.rawValue:
            // Multi player with map NOT PLACED = enable tap gesture and disable spin gesture
            if !self.multiARBrain!.map.mapPlaced {
                if gestureRecognizer.name == "TapGesture" {
                    return true
                }
                else if gestureRecognizer.name == "SpinGesture" {
                    return false
                }
            }
            // Multi player with map placed but NOT locked = disable tap gesture and enable spin gesture
            else if self.multiARBrain!.map.mapPlaced && !self.multiARBrain!.map.mapLocked {
                if gestureRecognizer.name == "TapGesture" {
                    return false
                }
                else if gestureRecognizer.name == "SpinGesture" {
                    return true
                }
            }
            // Multi player with map placed and locked = disable all gestures
            else {
                return false
            }
            
        case GameMode.RCMode.rawValue:
            return true
        default:
            break
        }
        
        return false
    }
}

//MARK: - Extension to description

extension ARFrame.WorldMappingStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notAvailable:
            return "Not Available"
        case .limited:
            return "Limited"
        case .extending:
            return "Extending"
        case .mapped:
            return "Mapped"
        @unknown default:
            return "Unknown"
        }
    }
}

