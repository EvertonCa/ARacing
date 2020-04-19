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
    
    // Vehicle SCNPhysicsVehicle
    var vehicle = SCNPhysicsVehicle()
    
    // Vehicle node
    var vehicleNode = SCNNode()
    
    // Scenery
    var scenery = SCNNode()
    
    // Scenery placed
    var sceneryPlaced = false
    
    // Scenery locked
    var sceneryLocked = false
    
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
    var gesturesBrain:Gestures!
    
    // ViewController
    var singleARViewController: SingleARViewController!
    
    //MARK: - Functions
    
    init(_ sceneView: ARSCNView, _ view: SingleARViewController) {
        self.sceneView = sceneView
        self.singleARViewController = view
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
        self.gesturesBrain = Gestures(sceneView: self.sceneView, arBrains: self)
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
    func createVehicle() {
        
        // position on the scenery to spawn
        let currentPositionOfCamera = SCNVector3(-0.8, -0.8, 0.06)
        
        // vehicle scene
        let scene = SCNScene(named: "3D Models.scnassets/SinglePlayerPlaceholder.scn")
        
        // Main vehicle node
        vehicleNode = (scene?.rootNode.childNode(withName: "chassis", recursively: false))!
        
        // vehicle wheels nodes
        let frontLeftWheel = (vehicleNode.childNode(withName: "FLP", recursively: true))!
        let frontRightWheel = (vehicleNode.childNode(withName: "FRP", recursively: true))!
        let rearLeftWheel = (vehicleNode.childNode(withName: "RLP", recursively: true))!
        let rearRightWheel = (vehicleNode.childNode(withName: "RRP", recursively: true))!
        
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
        
        // connection points for the wheels
        let frontLeftWheelToChassis = frontLeftWheel.convertPosition(SCNVector3Zero, to: vehicleNode)
        let frontLeftPositionToConnect = SCNVector3Make(frontLeftWheelToChassis.x, frontLeftWheelToChassis.y, frontLeftWheelToChassis.z)
        v_frontLeftWheel.connectionPosition = frontLeftPositionToConnect

        let frontRightWheelToChassis = frontRightWheel.convertPosition(SCNVector3Zero, to: vehicleNode)
        let frontRightPositionToConnect = SCNVector3Make(frontRightWheelToChassis.x, frontRightWheelToChassis.y, frontRightWheelToChassis.z)
        v_frontRightWheel.connectionPosition = frontRightPositionToConnect

        let rearLeftWheelToChassis = rearLeftWheel.convertPosition(SCNVector3Zero, to: vehicleNode)
        let rearLeftPositionToConnect = SCNVector3Make(rearLeftWheelToChassis.x, rearLeftWheelToChassis.y, rearLeftWheelToChassis.z)
        v_rearLeftWheel.connectionPosition = rearLeftPositionToConnect

        let rearRightWheelToChassis = rearRightWheel.convertPosition(SCNVector3Zero, to: vehicleNode)
        let rearRightPositionToConnect = SCNVector3Make(rearRightWheelToChassis.x, rearRightWheelToChassis.y, rearRightWheelToChassis.z)
        v_rearRightWheel.connectionPosition = rearRightPositionToConnect
        
        //if the option is true, it considers all of the geometries. If false, just combines into one geometry
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: vehicleNode, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
        
        // - - - - - - - - - Body physical properties - - - - - - - - -
        
        // The mass of a body affects its momentum and how it responds to forces. The default mass for dynamic bodies is 1.0. The default mass for static and kinematic bodies is 0.0, but these bodies are unaffected by mass.
        body.mass = 5
        
        // A body’s charge determines its behavior when affected by an electric or magnetic field. Use the SCNPhysicsField class to add these fields to your scene. Bodies with positive or negative charges behave differently when affected by electric or magnetic fields. The default electric charge on a physics body is 0.0, causing it to be unaffected by electric and magnetic fields.
        body.charge = 0.0
        
        // This property simulates the roughness of the body’s surface. When two bodies are in contact and a force is applied that would cause them to slide against one another, the friction values for both bodies determine their resistance to motion. If both bodies’ friction value is 0.0, they slide freely against each other. If both bodies’ friction value is 1.0, they do not slide at all. The default friction is 0.5.
        body.friction = 0.1
        
        // This property simulates the traction between a rounded body and bodies it might roll against. A rolling friction of 0.0 (the default) means that a body induced to roll (for example, by being placed on an inclined surface) will continue to roll without slowing down unless otherwise acted upon, and a rolling friction of 1.0 prevents the body from rolling.
        body.rollingFriction = 0.2
        
        //This property simulates the “bounciness” of a body. A restitution of 1.0 means that the body loses no energy in a collision—for example, a ball dropped onto a flat surface will bounce back to the height it fell from. A restitution of 0.0 means the body does not bounce after a collision. A restitution of greater than 1.0 causes the body to gain energy in collisions. The default restitution is 0.5.
        body.restitution = 0.5
        
        // This property simulates the effect of fluid friction or air resistance on a body. A damping factor of 0.0 specifies no loss in velocity, and a damping factor of 1.0 prevents the body from moving. The default damping factor is 0.1.
        body.damping = 0.1
        
        // This property simulates the effect of rotational friction on a body. A damping factor of 0.0 specifies no loss in angular velocity, and a damping factor of 1.0 prevents the body from rotating. The default damping factor is 0.1.
        body.angularDamping = 0.1
        
        // The results of physics interactions with a body depend on its center of mass. For example, a collision close to or in line with the center of mass tends to move the whole body (that is, it adds linear velocity), but a collision not aligned with the center of mass tends to cause the body to rotate or topple (that is, it adds angular velocity).
        //When this property’s value is the vector (0, 0, 0) (the default), SceneKit simulates interactions with the assumption that the body’s center of mass is at the origin of its local coordinate space (the simdPosition of the node owning the physics body).
        body.centerOfMassOffset = SCNVector3(0, 0, 0)
        
        // If true (the default), SceneKit keeps track of whether the body is moving or affected by forces, automatically setting its isResting property to true when it is “at rest.” The physics simulation runs faster when simulating fewer bodies, so treating a body as resting temporarily removes it from the simulation to improve performance.
        body.allowsResting = false
        
        
        // - - - - - - - - - Wheels physical properties - - - - - - - - -
        
        // The default value of this property is 1.0. Lower values result in better traction, and higher values make the wheel more likely to slip (causing it to spin freely instead of moving the vehicle).
        v_frontLeftWheel.frictionSlip = 1.0
        v_frontRightWheel.frictionSlip = 1.0
        v_rearLeftWheel.frictionSlip = 1.0
        v_rearRightWheel.frictionSlip = 1.0
        
        // When you create a wheel from a node, its default radius is half of the largest dimension of the node’s bounding box. (A wheel is always circular, even if the content of the node representing it is not.)
        v_frontLeftWheel.radius = CGFloat(0.018)
        v_frontRightWheel.radius = CGFloat(0.018)
        v_rearLeftWheel.radius = CGFloat(0.018)
        v_rearRightWheel.radius = CGFloat(0.018)
        
        // The spring coefficient determines both how quickly the wheel returns to its natural position after a shock (for example, when the vehicle runs over a bump) and how much force from the shock it transmits to the vehicle. The default spring coefficient is 2.0.
        v_frontLeftWheel.suspensionStiffness = CGFloat(1.0)
        v_frontRightWheel.suspensionStiffness = CGFloat(1.0)
        v_rearLeftWheel.suspensionStiffness = CGFloat(1.0)
        v_rearRightWheel.suspensionStiffness = CGFloat(1.0)
        
        // The default suspension coefficient is 4.4. Lower values cause the wheel to return to its natural position more quickly.
        v_frontLeftWheel.suspensionCompression = CGFloat(4)
        v_frontRightWheel.suspensionCompression = CGFloat(4)
        v_rearLeftWheel.suspensionCompression = CGFloat(4)
        v_rearRightWheel.suspensionCompression = CGFloat(4)
        
        // Damping ratio measures the tendency of the suspension to oscillate after a shock—in other words, for the vehicle to bounce up and down after running over a bump. The default damping ratio of 2.3 causes the wheel to return to its neutral position quickly after a shock. Values lower than 1.0 result in more oscillation.
        v_frontLeftWheel.suspensionDamping = CGFloat(5)
        v_frontRightWheel.suspensionDamping = CGFloat(5)
        v_rearLeftWheel.suspensionDamping = CGFloat(5)
        v_rearRightWheel.suspensionDamping = CGFloat(5)
        
        // Travel is the total distance a wheel is allowed to move (in both directions), in the coordinate system of the node containing the vehicle’s chassis. The default suspension travel is 500.0.
        v_frontLeftWheel.maximumSuspensionTravel = CGFloat(1)
        v_frontRightWheel.maximumSuspensionTravel = CGFloat(1)
        v_rearLeftWheel.maximumSuspensionTravel = CGFloat(1)
        v_rearRightWheel.maximumSuspensionTravel = CGFloat(1)
        
        // The physics simulation applies a force of no greater than this magnitude when contact with the ground causes the wheel to move relative to the vehicle. The default maximum suspension force is 6000.0.
        v_frontLeftWheel.maximumSuspensionForce = CGFloat(5)
        v_frontRightWheel.maximumSuspensionForce = CGFloat(5)
        v_rearLeftWheel.maximumSuspensionForce = CGFloat(5)
        v_rearRightWheel.maximumSuspensionForce = CGFloat(5)
        
        // This property measures the length of the simulated spring between the vehicle and its wheel when the spring is not stressed by the weight of either body. When the wheel receives a shock (for example, when the vehicle runs over a bump), SceneKit adds the difference between the wheel’s current position and its connection position to this rest length and then applies a force between the wheel and vehicle proportional to the total.
        v_frontLeftWheel.suspensionRestLength = CGFloat(0.005)
        v_frontRightWheel.suspensionRestLength = CGFloat(0.005)
        v_rearLeftWheel.suspensionRestLength = CGFloat(0.005)
        v_rearRightWheel.suspensionRestLength = CGFloat(0.005)
        
        // sets the position of the chassis
        vehicleNode.position = currentPositionOfCamera
        
        // rotation of the vehicle
        vehicleNode.eulerAngles = SCNVector3(x: -Float(90.degreesToRadians), y: 0, z: 0)
        
        // sets the physics body to the chassis
        vehicleNode.physicsBody = body
        
        // Vehicle physics
        self.vehicle = SCNPhysicsVehicle(chassisBody: vehicleNode.physicsBody!, wheels: [v_rearLeftWheel, v_rearRightWheel, v_frontRightWheel, v_frontLeftWheel])
        
        // adds the vehicle to the physics world
        self.sceneView.scene.physicsWorld.addBehavior(self.vehicle)
        
        // adds the vehicle to the scenery
        self.scenery.addChildNode(vehicleNode)
        
    }
    
    // removes the vehicle in the scenery
    func removeVehicle() {
        self.vehicleNode.removeFromParentNode()
    }
    
    // creates and places the scenary in the AR view
    func addScenery(hitTestResult: ARHitTestResult) {
        let scene = SCNScene(named: "3D Models.scnassets/ScenerySinglePlayer1.scn")
        scenery = (scene?.rootNode.childNode(withName: "plane", recursively: false))!
        let transform = hitTestResult.worldTransform
        let thirdColumn = transform.columns.3
        scenery.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
        
        self.sceneView.scene.rootNode.addChildNode(scenery)
        
        // sets the scenary placed to true and remove the tap gesture
        self.sceneryPlaced = true
        self.gesturesBrain.removeTapGesture()
        
        // changes feedback label
        self.singleARViewController.showFeedback(text: "Rotate the map to match your surface and press Start to place your car!")
        
        // removes the grid from view
        self.gridNode!.enumerateChildNodes { ( childNode, _ ) in
            childNode.removeFromParentNode()
        }
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
