//
//  SingleTexts.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 22/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

class SingleTexts {
    
    //MARK: - Functions
    
    func showReadyText() -> SCNNode {
        let scene = SCNScene(named: "3D Models.scnassets/Text Assets/ReadyText.scn")
        let textNode = (scene?.rootNode.childNode(withName: "text", recursively: false))!
        textNode.eulerAngles = SCNVector3(x: 0, y: 0, z: 0)
        textNode.name = "Text"
        
        return textNode
    }
    
    func showSetText() -> SCNNode {
        let scene = SCNScene(named: "3D Models.scnassets/Text Assets/SetText.scn")
        let textNode = (scene?.rootNode.childNode(withName: "text", recursively: false))!
        textNode.eulerAngles = SCNVector3(x: 0, y: 0, z: 0)
        textNode.name = "Text"
        
        return textNode
    }
    
    func showGoText() -> SCNNode {
        let scene = SCNScene(named: "3D Models.scnassets/Text Assets/GoText.scn")
        let textNode = (scene?.rootNode.childNode(withName: "text", recursively: false))!
        textNode.eulerAngles = SCNVector3(x: 0, y: 0, z: 0)
        textNode.name = "Text"
        
        // Particles in the checkpoint
        let particle = SCNParticleSystem(named: "3D Models.scnassets/Text Assets/Confetti.scnp", inDirectory: nil)
        particle?.loops = false
        particle?.emissionDuration = 2
        particle?.emitterShape = textNode.geometry
        let particleNode = SCNNode()
        particleNode.addParticleSystem(particle!)
        particleNode.position = SCNVector3(0, 1, 0)
        particleNode.eulerAngles = SCNVector3(x: 0, y: 0, z: 0)
        
        textNode.addChildNode(particleNode)
        
        return textNode
    }
    
    func lookAtCamera(sceneView: ARSCNView, sceneryNode: SCNNode) {
        sceneView.scene.rootNode.enumerateChildNodes{ (node, _) in
            if node.name == "Text" {
                let relativePositionToScenery = sceneView.pointOfView?.convertPosition(SCNVector3Zero, to: sceneryNode)
                node.look(at: relativePositionToScenery!)
            }
        }
    }
}
