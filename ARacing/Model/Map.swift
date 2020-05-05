//
//  SingleScenery.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 22/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

class Map {
    
    //MARK: - Variables and Constants
    
    // Scenery
    var mapNode:SCNNode
    
    // SceneView
    var sceneView:ARSCNView
    
    // Game
    var game:Game
    
    // Scenery placed
    var mapPlaced = false
    
    // Scenery locked
    var mapLocked = false
    
    //MARK: - Functions
    init(mapNode: SCNNode, sceneView: ARSCNView, game:Game) {
        self.mapNode = mapNode
        self.sceneView = sceneView
        self.game = game
    }
    
    // creates and places the scenary in the AR view
    func addMap(hitTestResult: ARHitTestResult) -> SCNNode {
        
        let scene = SCNScene(named: self.game.mapAddress())
        self.mapNode = (scene?.rootNode.childNode(withName: "Track", recursively: false))!
        
        // Collision Geometry
        let collisionGeometry = (scene?.rootNode.childNode(withName: "Physics", recursively: false))!
        
        // sets the physics body and its parameters
        self.mapNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: collisionGeometry, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
        self.mapNode.physicsBody?.isAffectedByGravity = false
        
        let transform = hitTestResult.worldTransform
        let thirdColumn = transform.columns.3
        self.mapNode.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
        
        self.sceneView.scene.rootNode.addChildNode(self.mapNode)
        
        // sets the map placed to true
        self.mapPlaced = true
        
        return self.mapNode
    }
}