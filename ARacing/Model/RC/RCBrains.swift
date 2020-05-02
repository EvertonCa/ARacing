//
//  SingleARBrains.swift
//  ARacing
//
//  Created by Everton Cardoso on 18/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

class RCBrains {
    
    //MARK: - Global Variables
    
    // ARKit scene View
    var sceneView:ARSCNView!
    
    // World Tracking configuration
    let arConfiguration = ARWorldTrackingConfiguration()
    
    // Grid node
    var gridNode:SCNNode?
    
    // Feedback Label
    var feedbackLabel: UILabel?
    
    // Gestures
    var gesturesBrain:GesturesRC!
    
    // ViewController
    var arViewController: ARViewController!
    
    // Vehicle
    var vehicle:Vehicle! = nil
    
    //MARK: - Functions
    
    init(_ sceneView: ARSCNView, _ view: ARViewController) {
        self.sceneView = sceneView
        self.arViewController = view
        self.vehicle = Vehicle(arView: arViewController, rcBrains: self, gameMode: GameMode.RCMode.rawValue, vehicleSelected: VehicleResources.PlaceholderRC.rawValue, sceneView: self.sceneView)
    }
    
    // setup the view when it loads
    func setupView() {
        
        // debug options - feature points and world origin
        self.sceneView.debugOptions = [.showFeaturePoints, .showPhysicsShapes, .showBoundingBoxes]
        
        // show statistics
        self.sceneView.showsStatistics = true
        
        // config to detect horizontal surfaces
        self.arConfiguration.planeDetection = .horizontal
        
        // enables default lighting
        self.sceneView.autoenablesDefaultLighting = true
        
        // run session
        self.sceneView.session.run(arConfiguration, options: [.removeExistingAnchors, .resetTracking])
        
        // setup the gestures recognizer
        self.gesturesBrain = GesturesRC(sceneView: self.sceneView, arBrains: self)
        self.gesturesBrain.registerGesturesrecognizers()
        
    }
    
    // creates the grid that shows the horizontal surface
    func createGrid(planeAnchor: ARPlaneAnchor) -> SCNNode {
        
        let gridNode = SCNNode(geometry: SCNBox(width: CGFloat(planeAnchor.extent.x), height: CGFloat(0.08), length: CGFloat(planeAnchor.extent.z), chamferRadius: 1))
        gridNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Grid")
        gridNode.position = SCNVector3(CGFloat(planeAnchor.center.x), CGFloat(planeAnchor.center.y), CGFloat(planeAnchor.center.z))

        // static is not affected by forces, but it is interactible
        let staticBody = SCNPhysicsBody.static()

        gridNode.physicsBody = staticBody

        return gridNode
        
    }
    
}

