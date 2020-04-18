//
//  SingleARBrains.swift
//  ARacing
//
//  Created by Everton Cardoso on 18/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

class RA_ARBrains {
    
    //MARK: - Global Variables
    
    // ARKit scene View
    var sceneView:ARSCNView!
    
    // World Tracking configuration
    let arConfiguration = ARWorldTrackingConfiguration()
    
    // Vehicle
    var vehicle = SCNPhysicsVehicle()
    
    //MARK: - Functions
    
    init(_ sceneView: ARSCNView) {
        self.sceneView = sceneView
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
        self.registerGesturesrecognizers()
        
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
    func createVehicle() {
        
        // variables for the position of the device
        guard let pointOfView = sceneView.pointOfView else { return }
        
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let currentPositionOfCamera = orientation + location
        
        // vehicle scene
        let scene = SCNScene(named: "3D Models.scnassets/Placeholder.scn")
        
        // Main vehicle node
        let chassis = (scene?.rootNode.childNode(withName: "chassis", recursively: false))!
        
        // Actual Chassis node
        //let chassis2 = (scene?.rootNode.childNode(withName: "chassis2", recursively: true))!
        
        // vehicle wheels nodes
        let frontLeftWheel = (chassis.childNode(withName: "FLP", recursively: true))!
        let frontRightWheel = (chassis.childNode(withName: "FRP", recursively: true))!
        let rearLeftWheel = (chassis.childNode(withName: "RLP", recursively: true))!
        let rearRightWheel = (chassis.childNode(withName: "RRP", recursively: true))!
        
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
        let frontLeftWheelToChassis = frontLeftWheel.convertPosition(SCNVector3Zero, to: chassis)
        let frontLeftPositionToConnect = SCNVector3Make(frontLeftWheelToChassis.x - centerFL, frontLeftWheelToChassis.y, frontLeftWheelToChassis.z)
        v_frontLeftWheel.connectionPosition = frontLeftPositionToConnect

        let frontRightWheelToChassis = frontRightWheel.convertPosition(SCNVector3Zero, to: chassis)
        let frontRightPositionToConnect = SCNVector3Make(frontRightWheelToChassis.x + centerFR, frontRightWheelToChassis.y, frontRightWheelToChassis.z)
        v_frontRightWheel.connectionPosition = frontRightPositionToConnect

        let rearLeftWheelToChassis = rearLeftWheel.convertPosition(SCNVector3Zero, to: chassis)
        let rearLeftPositionToConnect = SCNVector3Make(rearLeftWheelToChassis.x - centerRL, rearLeftWheelToChassis.y, rearLeftWheelToChassis.z)
        v_rearLeftWheel.connectionPosition = rearLeftPositionToConnect

        let rearRightWheelToChassis = rearRightWheel.convertPosition(SCNVector3Zero, to: chassis)
        let rearRightPositionToConnect = SCNVector3Make(rearRightWheelToChassis.x + centerRR, rearRightWheelToChassis.y, rearRightWheelToChassis.z)
        v_rearRightWheel.connectionPosition = rearRightPositionToConnect
        
        //if the option is true, it considers all of the geometries. If false, just combines into one geometry
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: chassis, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
        
        // mass in kg
        body.mass = 15
        body.allowsResting = false
        body.restitution = 0.1
        body.friction = 0.1
        body.rollingFriction = 0
        
        // sets the position of the chassis
        chassis.position = currentPositionOfCamera
        
        // sets the physics body to the chassis
        chassis.physicsBody = body
        
        // Vehicle physics
        self.vehicle = SCNPhysicsVehicle(chassisBody: chassis.physicsBody!, wheels: [v_rearLeftWheel, v_rearRightWheel, v_frontRightWheel, v_frontLeftWheel])
        
        // adds the vehicle to the physics world
        self.sceneView.scene.physicsWorld.addBehavior(self.vehicle)
        
        // adds the vehicle to the scene
        self.sceneView.scene.rootNode.addChildNode(chassis)
        
        // scale the vehicle
        let scaleAction = SCNAction.scale(by: 0.6, duration: 0)
        chassis.runAction(scaleAction)
        frontLeftWheel.runAction(scaleAction)
        frontRightWheel.runAction(scaleAction)
        rearLeftWheel.runAction(scaleAction)
        rearRightWheel.runAction(scaleAction)
    }
    
    // creates and places the scenary in the AR view
    func addScenary(hitTestResult: ARHitTestResult) {
        let scene = SCNScene(named: "3D Models.scnassets/Scenary.scn")
        let node = (scene?.rootNode.childNode(withName: "plane", recursively: false))!
        let transform = hitTestResult.worldTransform
        let thirdColumn = transform.columns.3
        node.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
        
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    // Manager for Gestures
    func registerGesturesrecognizers() {
        // recognizer for Tap Gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        // recognizer for spin Gesture
        let spinGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotation))
        self.sceneView.addGestureRecognizer(spinGestureRecognizer)
        
        // recognizer for Pinch Gesture
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        self.sceneView.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    // handler for Tap Gesture for adding scene to plane
    @objc func tapped(sender:UITapGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        if !hitTest.isEmpty {
            print("Touched horizontal surface")
            self.addScenary(hitTestResult: hitTest.first!)
        } else {
            print("No match")
        }
    }
    
    // handler for Rotation Gesture for fixing location of the Scenary
    @objc func rotation(sender:UIRotationGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let rotationLocation = sender.location(in: sceneView)
        let angle = sender.rotation
        
        let hitTest = sceneView.hitTest(rotationLocation)
        
        if !hitTest.isEmpty {
            if let results = hitTest.first {
                let node = results.node
                
                let rotateAction = SCNAction.rotateBy(x: 0, y: angle, z: 0, duration: 0)
                
                node.runAction(rotateAction)
                
                sender.rotation = 0
                print(angle)
            }
        }
    }
    
    // handler for Pinch Gesture to resize scene
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let pinchLocation = sender.location(in: sceneView)
        
        let hitTest = sceneView.hitTest(pinchLocation)
        
        if !hitTest.isEmpty {
            if let results = hitTest.first {
                let node = results.node
                
                // scale the node with the gesture
                let pinchAction = SCNAction.scale(by: sender.scale, duration: 0)
                
                node.runAction(pinchAction)
                
                // avoids exponential growth
                sender.scale = 1.0
            }
        }
    }
}

