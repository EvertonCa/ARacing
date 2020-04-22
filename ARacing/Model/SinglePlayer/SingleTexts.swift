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
    
    //MARK: - Variables and Constants
    
    //text node
    var textNode:SCNNode?
    
    //MARK: - Functions
    
    func showReadyText() -> SCNNode {
        let scene = SCNScene(named: "3D Models.scnassets/ReadyText.scn")
        self.textNode = (scene?.rootNode.childNode(withName: "text", recursively: false))!
        self.textNode?.eulerAngles = SCNVector3(x: Float(90.degreesToRadians), y: 0, z: 0)
        
        return self.textNode!
    }
}
