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
    
    // Vehicle SCNPhysicsVehicle
    var vehicle = SCNPhysicsVehicle()
    
    // Vehicle node
    var vehicleNode = SCNNode()
    
    // Driving variables
    var turningRight = false
    var turningLeft = false
    var accelerating = false
    var breaking = false
    var goingBackwards = false
    
    // Grid node
    var gridNode:SCNNode?
    
    // Feedback Label
    var feedbackLabel: UILabel?
    
    // Gestures
    var gesturesBrain:GesturesRC!
    
    // ViewController
    var rcViewController: RCViewController!
    
    //MARK: - Functions
    
    init(_ sceneView: ARSCNView, _ view: RCViewController) {
        self.sceneView = sceneView
        self.rcViewController = view
    }
    
    // setup the view when it loads
    func setupView() {
        
        // debug options - feature points and world origin
        //self.sceneView.debugOptions = [.showFeaturePoints, .showPhysicsShapes, .showBoundingBoxes]
        
        // show statistics
        //self.sceneView.showsStatistics = true
        
        // config to detect horizontal surfaces
        self.arConfiguration.planeDetection = .horizontal
        
        // enables default lighting
        self.sceneView.autoenablesDefaultLighting = true
        
        // run session
        self.sceneView.session.run(arConfiguration)
        
        // setup the gestures recognizer
        self.gesturesBrain = GesturesRC(sceneView: self.sceneView, arBrains: self)
        self.gesturesBrain.registerGesturesrecognizers()
        
    }
    
    // creates the grid that shows the horizontal surface
    func createGrid(planeAnchor: ARPlaneAnchor) -> SCNNode {
        
        let gridNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
        gridNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Grid")
        gridNode.geometry?.firstMaterial?.isDoubleSided = true
        gridNode.position = SCNVector3(CGFloat(planeAnchor.center.x), CGFloat(planeAnchor.center.y), CGFloat(planeAnchor.center.z))
        gridNode.eulerAngles = SCNVector3(x: Float(90.degreesToRadians), y: 0, z: 0)
        
        // static is not affected by forces, but it is interactible
        let staticBody = SCNPhysicsBody.static()
        
        gridNode.physicsBody = staticBody
        
        return gridNode
    }
    
    // creates the vehicle
    func createVehicle(hitTest: ARHitTestResult) {
        
        // vehicle scene
        let scene = SCNScene(named: "3D Models.scnassets/RCPlaceholder.scn")
        
        // Main vehicle node
        self.vehicleNode = (scene?.rootNode.childNode(withName: "chassis", recursively: false))!
        
        // vehicle wheels nodes
        let frontLeftWheel = (self.vehicleNode.childNode(withName: "FLP", recursively: true))!
        let frontRightWheel = (self.vehicleNode.childNode(withName: "FRP", recursively: true))!
        let rearLeftWheel = (self.vehicleNode.childNode(withName: "RLP", recursively: true))!
        let rearRightWheel = (self.vehicleNode.childNode(withName: "RRP", recursively: true))!
        
        // vehicles wheels
        let v_frontLeftWheel = SCNPhysicsVehicleWheel(node: frontLeftWheel)
        let v_frontRightWheel = SCNPhysicsVehicleWheel(node: frontRightWheel)
        let v_rearLeftWheel = SCNPhysicsVehicleWheel(node: rearLeftWheel)
        let v_rearRightWheel = SCNPhysicsVehicleWheel(node: rearRightWheel)
        
        // reverse wheels spin
        v_frontLeftWheel.axle = SCNVector3(-1, 0, 0)
        v_frontRightWheel.axle = SCNVector3(-1, 0, 0)
        v_rearLeftWheel.axle = SCNVector3(-1, 0, 0)
        v_rearRightWheel.axle = SCNVector3(-1, 0, 0)
        
        // wheels bounding boxes
        let boundingBoxFL = frontLeftWheel.boundingBox
        let boundingBoxFR = frontRightWheel.boundingBox
        let boundingBoxRL = rearLeftWheel.boundingBox
        let boundingBoxRR = rearRightWheel.boundingBox
        
        // center wheel location
        let centerFL:Float = 0.5 * Float(boundingBoxFL.max.x - boundingBoxFL.min.x)
        let centerFR:Float = 0.5 * Float(boundingBoxFR.max.x - boundingBoxFR.min.x)
        let centerRL:Float = 0.5 * Float(boundingBoxRL.max.x - boundingBoxRL.min.x)
        let centerRR:Float = 0.5 * Float(boundingBoxRR.max.x - boundingBoxRR.min.x)
        
        // connection points for the wheels
        let frontLeftWheelToChassis = frontLeftWheel.convertPosition(SCNVector3Zero, to: self.vehicleNode)
        let frontLeftPositionToConnect = SCNVector3Make(frontLeftWheelToChassis.x - centerFL, frontLeftWheelToChassis.y, frontLeftWheelToChassis.z)
        v_frontLeftWheel.connectionPosition = frontLeftPositionToConnect

        let frontRightWheelToChassis = frontRightWheel.convertPosition(SCNVector3Zero, to: self.vehicleNode)
        let frontRightPositionToConnect = SCNVector3Make(frontRightWheelToChassis.x + centerFR, frontRightWheelToChassis.y, frontRightWheelToChassis.z)
        v_frontRightWheel.connectionPosition = frontRightPositionToConnect

        let rearLeftWheelToChassis = rearLeftWheel.convertPosition(SCNVector3Zero, to: self.vehicleNode)
        let rearLeftPositionToConnect = SCNVector3Make(rearLeftWheelToChassis.x - centerRL, rearLeftWheelToChassis.y, rearLeftWheelToChassis.z)
        v_rearLeftWheel.connectionPosition = rearLeftPositionToConnect

        let rearRightWheelToChassis = rearRightWheel.convertPosition(SCNVector3Zero, to: self.vehicleNode)
        let rearRightPositionToConnect = SCNVector3Make(rearRightWheelToChassis.x + centerRR, rearRightWheelToChassis.y, rearRightWheelToChassis.z)
        v_rearRightWheel.connectionPosition = rearRightPositionToConnect
        
        //if the option is true, it considers all of the geometries. If false, just combines into one geometry
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: self.vehicleNode, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
        
        // mass in kg
        body.mass = 15
        body.allowsResting = false
        body.restitution = 0.1
        body.friction = 0.1
        body.rollingFriction = 0
        
        // hit test to position the vehicle
        let transform = hitTest.worldTransform
        let thirdColumn = transform.columns.3
        self.vehicleNode.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
        
        // sets the physics body to the chassis
        self.vehicleNode.physicsBody = body
        
        // Vehicle physics
        self.vehicle = SCNPhysicsVehicle(chassisBody: self.vehicleNode.physicsBody!, wheels: [v_rearLeftWheel, v_rearRightWheel, v_frontRightWheel, v_frontLeftWheel])
        
        // adds the vehicle to the physics world
        self.sceneView.scene.physicsWorld.addBehavior(self.vehicle)
        
        // adds the vehicle to the scene
        self.sceneView.scene.rootNode.addChildNode(self.vehicleNode)
    }
    
    // removes the vehicle in the scenery
    func removeVehicle() {
        self.vehicleNode.removeFromParentNode()
    }
}

