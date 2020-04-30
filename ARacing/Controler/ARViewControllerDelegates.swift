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
            self.singlePlayerSelected()
        case TypeSelected.MultiPlayer.rawValue:
            self.multiPlayerSelected()
        case TypeSelected.RCMode.rawValue:
            self.rcModeSelected()
        default: break
        }
    }
}

//MARK: - ARSCNViewDelegate
extension ARViewController: ARSCNViewDelegate {
    
    // when a anchor is detected
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        self.typeBrain.didAddNodeRenderer(node: node, anchor: anchor)
    }
    
    //when the anchor is updated
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        self.typeBrain.didUpdateNodeRenderer(node: node, anchor: anchor)
    }
    
    //when the anchor is removed
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        self.typeBrain.didRemoveNodeRenderer(node: node, anchor: anchor)
    }
    
    // used for vehicle and physics updates
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        self.typeBrain.updateAtTimeRenderer()
    }
}

//MARK: - SCNPhysicsContactDelegate
extension ARViewController: SCNPhysicsContactDelegate {
    
    // checks collision in the scene
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        self.typeBrain.didBeginContact(contact: contact)
    }
}
