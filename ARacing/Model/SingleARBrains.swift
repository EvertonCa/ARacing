//
//  SingleARBrains.swift
//  ARacing
//
//  Created by Everton Cardoso on 03/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

class SingleARBrains {
    
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
        self.sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        
        // show statistics
        self.sceneView.showsStatistics = true
        
        // config to detect horizontal surfaces
        self.arConfiguration.planeDetection = .horizontal
        
        // enables default lighting
        self.sceneView.autoenablesDefaultLighting = true
        
        // run session
        self.sceneView.session.run(arConfiguration)
        
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
        let scene = SCNScene(named: "Models.scnassets/Car-Scene.scn")
        
        //vehicle chassis
        let chassis = (scene?.rootNode.childNode(withName: "chassis", recursively: false))!
        
        // vehicle wheels nodes
        let frontLeftWheel = (chassis.childNode(withName: "frontLeftParent", recursively: false))!
        let frontRightWheel = (chassis.childNode(withName: "frontRightParent", recursively: false))!
        let rearLeftWheel = (chassis.childNode(withName: "rearLeftParent", recursively: false))!
        let rearRightWheel = (chassis.childNode(withName: "rearRightParent", recursively: false))!
        
        // vehicles wheels
        let v_frontLeftWheel = SCNPhysicsVehicleWheel(node: frontLeftWheel)
        let v_frontRightWheel = SCNPhysicsVehicleWheel(node: frontRightWheel)
        let v_rearLeftWheel = SCNPhysicsVehicleWheel(node: rearLeftWheel)
        let v_rearRightWheel = SCNPhysicsVehicleWheel(node: rearRightWheel)
        
        //if the option is true, it considers all of the geometries. If false, just combines into one geometry
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: chassis, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
        
        // mass of 50 N
        body.mass = 50
        
        // sets the position of the chassis
        chassis.position = currentPositionOfCamera
        
        // sets the physics body to the chassis
        chassis.physicsBody = body
        
        // Vehicle physics
        self.vehicle = SCNPhysicsVehicle(chassisBody: chassis.physicsBody!, wheels: [v_rearRightWheel, v_rearLeftWheel, v_frontRightWheel, v_frontLeftWheel])
        
        // adds the vehicle to the physics world
        self.sceneView.scene.physicsWorld.addBehavior(self.vehicle)
        
        // adds the vehicle to the scene
        self.sceneView.scene.rootNode.addChildNode(chassis)
    }
    
}

//MARK: - Extension to Int

extension Int {
    
    var degreesToRadians: Double { return Double(self) * .pi/180 }
}


//MARK: - Overload +

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
