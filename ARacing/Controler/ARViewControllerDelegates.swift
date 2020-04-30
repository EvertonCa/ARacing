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
        case TypeSelected.SinglePlayer.rawValue:
            self.typeSelected = TypeSelected.SinglePlayer.rawValue
            self.goToMapsViewController()
            
        case TypeSelected.MultiPlayer.rawValue:
            self.typeSelected = TypeSelected.MultiPlayer.rawValue
            self.goToMapsViewController()
            
        case TypeSelected.RCMode.rawValue:
            self.rcModeSelected()
        default: break
        }
    }
}

//MARK: - Maps Segue Delegate

extension ARViewController: MapViewDelegate {
    func passMapSelected(mapSelected: Int) {
        switch mapSelected {
        case MapSelected.Map1.rawValue:
            self.mapSelected = MapSelected.Map1.rawValue
            self.menuBrains.stopIntroMusic()
            
        case MapSelected.Map2.rawValue:
            self.mapSelected = MapSelected.Map2.rawValue
            self.menuBrains.stopIntroMusic()
            
        case MapSelected.Map3.rawValue:
            self.mapSelected = MapSelected.Map3.rawValue
            self.menuBrains.stopIntroMusic()
            
        default: break
        }
        
        switch self.typeSelected {
        case TypeSelected.SinglePlayer.rawValue:
            self.singlePlayerSelected()
        case TypeSelected.MultiPlayer.rawValue:
            self.multiPlayerSelected()
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
