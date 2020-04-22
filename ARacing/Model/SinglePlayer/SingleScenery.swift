//
//  SingleScenery.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 22/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

class SingleScenery {
    
    //MARK: - Variables and Constants
    
    // Scenery
    var scenery:SCNNode
    
    // SceneView
    var sceneView:ARSCNView
    
    // Scenery placed
    var sceneryPlaced = false
    
    // Scenery locked
    var sceneryLocked = false
    
    //MARK: - Functions
    init(sceneryNode: SCNNode, sceneView: ARSCNView) {
        self.scenery = sceneryNode
        self.sceneView = sceneView
    }
    
    // creates and places the scenary in the AR view
    func addScenery(hitTestResult: ARHitTestResult) -> SCNNode {
        let scene = SCNScene(named: "3D Models.scnassets/ScenerySinglePlayer1.scn")
        self.scenery = (scene?.rootNode.childNode(withName: "plane", recursively: false))!
        let transform = hitTestResult.worldTransform
        let thirdColumn = transform.columns.3
        self.scenery.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
        
        self.sceneView.scene.rootNode.addChildNode(self.scenery)
        
        // sets the scenary placed to true
        self.sceneryPlaced = true
        
        return self.scenery
    }
}
