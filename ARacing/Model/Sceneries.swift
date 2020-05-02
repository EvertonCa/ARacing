//
//  SingleScenery.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 22/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

class Sceneries {
    
    //MARK: - Variables and Constants
    
    // Scenery
    var scenery:SCNNode
    
    // SceneView
    var sceneView:ARSCNView
    
    // Scenery placed
    var sceneryPlaced = false
    
    // Scenery locked
    var sceneryLocked = false
    
    // Map selected
    var mapSelected: Int = MapSelected.Map1.rawValue
    
    //MARK: - Functions
    init(sceneryNode: SCNNode, sceneView: ARSCNView) {
        self.scenery = sceneryNode
        self.sceneView = sceneView
    }
    
    // Returns the address for the Selected Map
    func mapAddress() -> String {
        switch self.mapSelected {
        case MapSelected.Map1.rawValue:
            return MapsResources.Map1.rawValue
            
        case MapSelected.Map2.rawValue:
            return MapsResources.Map2.rawValue
            
        case MapSelected.Map1.rawValue:
            return MapsResources.Map3.rawValue
            
        default: return ""
        }
    }
    
    // creates and places the scenary in the AR view
    func addScenery(hitTestResult: ARHitTestResult) -> SCNNode {
        
        let scene = SCNScene(named: self.mapAddress())
        self.scenery = (scene?.rootNode.childNode(withName: "Track", recursively: false))!
        
        // Collision Geometry
        let collisionGeometry = (scene?.rootNode.childNode(withName: "Physics", recursively: false))!
        
        // sets the physics body and its parameters
        self.scenery.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: collisionGeometry, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
        self.scenery.physicsBody?.isAffectedByGravity = false
        
        let transform = hitTestResult.worldTransform
        let thirdColumn = transform.columns.3
        self.scenery.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
        
        self.sceneView.scene.rootNode.addChildNode(self.scenery)
        
        // sets the scenary placed to true
        self.sceneryPlaced = true
        
        return self.scenery
    }
}
