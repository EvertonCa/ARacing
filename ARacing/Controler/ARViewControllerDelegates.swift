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
            self.goToMapsViewController()
            
        case GameMode.MultiPlayer.rawValue:
            self.game.gameTypeSelected = GameMode.MultiPlayer.rawValue
            self.goToMapsViewController()
            
        case GameMode.RCMode.rawValue:
            self.game.gameTypeSelected = GameMode.RCMode.rawValue
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
            self.singlePlayerSelected()
            
        case GameMode.MultiPlayer.rawValue:
            self.multiPlayerSelected()
            
        case GameMode.RCMode.rawValue:
            self.rcModeSelected()
            
        default: break
        }
    }
}


//MARK: - ARSCNViewDelegate
extension ARViewController: ARSCNViewDelegate {
    
    // when a anchor is detected
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        self.arBrain.didAddNodeRenderer(node: node, anchor: anchor)
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

//MARK: - SCNPhysicsContactDelegate
extension ARViewController: SCNPhysicsContactDelegate {
    
    // checks collision in the scene
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        self.arBrain.didBeginContact(contact: contact)
    }
}
