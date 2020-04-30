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
    var vehiclePhysics: SCNPhysicsVehicle?
    
    // Vehicle node
    var vehicleNode = SCNNode()
    
    // Vehicle Wheels nodes
    var frontLeftWheel = SCNNode()
    var frontRightWheel = SCNNode()
    var rearLeftWheel = SCNNode()
    var rearRightWheel = SCNNode()
    
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
    var arViewController: ARViewController!
    
    //MARK: - Vehicle Body Parameters Constants
    
    // The mass of a body affects its momentum and how it responds to forces. The default mass for dynamic bodies is 1.0. The default mass for static and kinematic bodies is 0.0, but these bodies are unaffected by mass.
    let mass:CGFloat = 1
    
    // A body’s charge determines its behavior when affected by an electric or magnetic field. Use the SCNPhysicsField class to add these fields to your scene. Bodies with positive or negative charges behave differently when affected by electric or magnetic fields. The default electric charge on a physics body is 0.0, causing it to be unaffected by electric and magnetic fields.
    let charge:CGFloat = 0
    
    // This property simulates the roughness of the body’s surface. When two bodies are in contact and a force is applied that would cause them to slide against one another, the friction values for both bodies determine their resistance to motion. If both bodies’ friction value is 0.0, they slide freely against each other. If both bodies’ friction value is 1.0, they do not slide at all. The default friction is 0.5.
    let friction:CGFloat = 0.1
    
    // This property simulates the traction between a rounded body and bodies it might roll against. A rolling friction of 0.0 (the default) means that a body induced to roll (for example, by being placed on an inclined surface) will continue to roll without slowing down unless otherwise acted upon, and a rolling friction of 1.0 prevents the body from rolling.
    let rollingFriction:CGFloat = 0.2
    
    //This property simulates the “bounciness” of a body. A restitution of 1.0 means that the body loses no energy in a collision—for example, a ball dropped onto a flat surface will bounce back to the height it fell from. A restitution of 0.0 means the body does not bounce after a collision. A restitution of greater than 1.0 causes the body to gain energy in collisions. The default restitution is 0.5.
    let restitution:CGFloat = 0.5
    
    // This property simulates the effect of fluid friction or air resistance on a body. A damping factor of 0.0 specifies no loss in velocity, and a damping factor of 1.0 prevents the body from moving. The default damping factor is 0.1.
    let damping:CGFloat = 0.1
    
    // This property simulates the effect of rotational friction on a body. A damping factor of 0.0 specifies no loss in angular velocity, and a damping factor of 1.0 prevents the body from rotating. The default damping factor is 0.1.
    let angularDamping:CGFloat = 0.1
    
    // The results of physics interactions with a body depend on its center of mass. For example, a collision close to or in line with the center of mass tends to move the whole body (that is, it adds linear velocity), but a collision not aligned with the center of mass tends to cause the body to rotate or topple (that is, it adds angular velocity).
    //When this property’s value is the vector (0, 0, 0) (the default), SceneKit simulates interactions with the assumption that the body’s center of mass is at the origin of its local coordinate space (the simdPosition of the node owning the physics body).
    let centerOfMassOffset = SCNVector3(0, 0, 0)
    
    // If true (the default), SceneKit keeps track of whether the body is moving or affected by forces, automatically setting its isResting property to true when it is “at rest.” The physics simulation runs faster when simulating fewer bodies, so treating a body as resting temporarily removes it from the simulation to improve performance.
    let allowsResting = false
    
    //MARK: - Vehicle Wheels Parameters Constants
    
    // This vector is expressed in the coordinate space of the node containing the vehicle’s chassis. The default axle direction is {-1.0, 0.0, 0.0}.
    let axle = SCNVector3(-1, 0, 0)
    
    // This vector is expressed in the coordinate space of the node containing the vehicle’s chassis. The default steering axis is {0.0, -1.0, 0.0}.
    let steeringAxis = SCNVector3(0, -1, 0)
    
    // The default value of this property is 1.0. Lower values result in better traction, and higher values make the wheel more likely to slip (causing it to spin freely instead of moving the vehicle).
    let frictionSlip:CGFloat = 1.0
    
    // When you create a wheel from a node, its default radius is half of the largest dimension of the node’s bounding box. (A wheel is always circular, even if the content of the node representing it is not.)
    let radius:CGFloat = (0.08/2)
    
    // The spring coefficient determines both how quickly the wheel returns to its natural position after a shock (for example, when the vehicle runs over a bump) and how much force from the shock it transmits to the vehicle. The default spring coefficient is 2.0.
    let suspensionStiffness:CGFloat = 2.0
    
    // The default suspension coefficient is 4.4. Lower values cause the wheel to return to its natural position more quickly.
    let suspensionCompression:CGFloat = 4.0
    
    // Damping ratio measures the tendency of the suspension to oscillate after a shock—in other words, for the vehicle to bounce up and down after running over a bump. The default damping ratio of 2.3 causes the wheel to return to its neutral position quickly after a shock. Values lower than 1.0 result in more oscillation.
    let suspensionDamping:CGFloat = 3.0
    
    // Travel is the total distance a wheel is allowed to move (in both directions), in the coordinate system of the node containing the vehicle’s chassis. The default suspension travel is 500.0. (Unit is centimeters)
    let maximumSuspensionTravel:CGFloat = 10
    
    // The physics simulation applies a force of no greater than this magnitude when contact with the ground causes the wheel to move relative to the vehicle. The default maximum suspension force is 6000.0. (Unit is Neutons)
    let maximumSuspensionForce:CGFloat = 5
    
    // This property measures the length of the simulated spring between the vehicle and its wheel when the spring is not stressed by the weight of either body. When the wheel receives a shock (for example, when the vehicle runs over a bump), SceneKit adds the difference between the wheel’s current position and its connection position to this rest length and then applies a force between the wheel and vehicle proportional to the total. (Unit is Meters)
    let suspensionRestLength:CGFloat = 0.1
    
    //MARK: - Engine, Breaking and Steering Constants
    
    // Steer angle
    let steerAngle:CGFloat = 0.8
    
    // Engine force
    let engineForce: CGFloat = 5
    
    // Breaking force
    let frontBreakingForce: CGFloat = 5
    let rearBreakingForce: CGFloat = 2
    
    
    //MARK: - Functions
    
    init(_ sceneView: ARSCNView, _ view: ARViewController) {
        self.sceneView = sceneView
        self.arViewController = view
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
    
    // creates the vehicle
    func createVehicle(hitTest: ARHitTestResult) {
        
        // vehicle scene
        let scene = SCNScene(named: "3D Models.scnassets/Vehicles Assets/RCPlaceholder_v2.scn")
        
        // Main vehicle node
        self.vehicleNode = (scene?.rootNode.childNode(withName: "Chassis", recursively: false))!
        
        // vehicle wheels nodes
        self.frontLeftWheel = (self.vehicleNode.childNode(withName: "FLP", recursively: false))!
        self.frontRightWheel = (self.vehicleNode.childNode(withName: "FRP", recursively: false))!
        self.rearLeftWheel = (self.vehicleNode.childNode(withName: "RLP", recursively: false))!
        self.rearRightWheel = (self.vehicleNode.childNode(withName: "RRP", recursively: false))!
        
        // adds the wheels to the vehicle node
        self.vehicleNode.addChildNode(self.frontLeftWheel)
        self.vehicleNode.addChildNode(self.frontRightWheel)
        self.vehicleNode.addChildNode(self.rearLeftWheel)
        self.vehicleNode.addChildNode(self.rearRightWheel)
        
        // hiddes the vehicle
        self.vehicleNode.isHidden = true
        
        // hit test to position the vehicle
        let transform = hitTest.worldTransform
        let thirdColumn = transform.columns.3
        self.vehicleNode.position = SCNVector3(thirdColumn.x, thirdColumn.y + 0.1, thirdColumn.z)
        
        // adds the vehicle to the scene
        self.sceneView.scene.rootNode.addChildNode(self.vehicleNode)
        
        // creates the vehicle physics
        self.createVehiclePhysics()
        
        // shows the vehicle
        self.vehicleNode.isHidden = false
    }
    
    // creates a SCNPhysicsVehicleWheel
    func createVehicleWheel(wheelNode: SCNNode, position: SCNVector3) -> SCNPhysicsVehicleWheel {
        let wheel = SCNPhysicsVehicleWheel(node: wheelNode)
        //wheel.connectionPosition = position
        //wheel.axle = self.axle
        //wheel.steeringAxis = self.steeringAxis
        wheel.maximumSuspensionTravel = self.maximumSuspensionTravel
        wheel.maximumSuspensionForce = self.maximumSuspensionForce
        wheel.suspensionRestLength = self.suspensionRestLength
        wheel.suspensionDamping = self.suspensionDamping
        wheel.suspensionStiffness = self.suspensionStiffness
        wheel.suspensionCompression = self.suspensionCompression
        //wheel.radius = self.radius
        //wheel.frictionSlip = self.frictionSlip
        
        return wheel
    }
    
    // creates the Vehicle Physics
    func createVehiclePhysics() {
        if self.vehiclePhysics != nil {
            self.sceneView.scene.physicsWorld.removeBehavior(self.vehiclePhysics!)
        }
        
        let connectionFL = SCNVector3(self.frontLeftWheel.position.x + 0.025, self.frontLeftWheel.position.y, self.frontLeftWheel.position.z)
        let connectionFR = SCNVector3(self.frontRightWheel.position.x - 0.025, self.frontRightWheel.position.y, self.frontRightWheel.position.z)
        let connectionRL = SCNVector3(self.rearLeftWheel.position.x + 0.025, self.rearLeftWheel.position.y, self.rearLeftWheel.position.z)
        let connectionRR = SCNVector3(self.rearRightWheel.position.x - 0.025, self.rearRightWheel.position.y, self.rearRightWheel.position.z)
        
        let wheelFL = createVehicleWheel(wheelNode: self.frontLeftWheel, position: connectionFL)
        let wheelFR = createVehicleWheel(wheelNode: self.frontRightWheel, position: connectionFR)
        let wheelRL = createVehicleWheel(wheelNode: self.rearLeftWheel, position: connectionRL)
        let wheelRR = createVehicleWheel(wheelNode: self.rearRightWheel, position: connectionRR)
        
        //if the option is true, it considers all of the geometries. If false, just combines into one geometry
        let bodyPhysics = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: self.vehicleNode, options: [SCNPhysicsShape.Option.keepAsCompound: true, SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron]))

        // body physics parameters
        bodyPhysics.mass = self.mass
        bodyPhysics.charge = self.charge
        bodyPhysics.friction = self.friction
        bodyPhysics.rollingFriction = self.rollingFriction
        bodyPhysics.restitution = self.restitution
        bodyPhysics.damping = self.damping
        bodyPhysics.angularDamping = self.angularDamping
        bodyPhysics.centerOfMassOffset = self.centerOfMassOffset
        bodyPhysics.allowsResting = self.allowsResting
        
        self.vehicleNode.physicsBody = bodyPhysics
        
        // Vehicle physics
        self.vehiclePhysics = SCNPhysicsVehicle(chassisBody: self.vehicleNode.physicsBody!, wheels: [wheelRL, wheelRR, wheelFL, wheelFR])
        
        // adds the vehicle to the physics world
        self.sceneView.scene.physicsWorld.addBehavior(self.vehiclePhysics!)
    }
    
    // removes the vehicle in the scenery
    func removeVehicle() {
        self.vehicleNode.removeFromParentNode()
    }
    
    // handles Acceleration, Breaking, Reversing and Steering for the vehicle
    func updatesVehicle() {
        if self.vehiclePhysics != nil {
            
            // steer the vehicle to right
            if self.turningRight {
                self.vehiclePhysics!.setSteeringAngle(self.steerAngle, forWheelAt: 2)
                self.vehiclePhysics!.setSteeringAngle(self.steerAngle, forWheelAt: 3)
            }
            // steer the vehicle to left
            else if self.turningLeft {
                self.vehiclePhysics!.setSteeringAngle(-self.steerAngle, forWheelAt: 2)
                self.vehiclePhysics!.setSteeringAngle(-self.steerAngle, forWheelAt: 3)
            }
            // straightens the vehicle
            else {
                self.vehiclePhysics!.setSteeringAngle(0, forWheelAt: 2)
                self.vehiclePhysics!.setSteeringAngle(0, forWheelAt: 3)
            }

            // Acceleration, Breaking and Reversing
            if self.accelerating {
                self.vehiclePhysics!.applyEngineForce(self.engineForce, forWheelAt: 0)
                self.vehiclePhysics!.applyEngineForce(self.engineForce, forWheelAt: 1)
            } else if self.breaking {
                // if vehicle is stopped, reverse, else, brakes
                if self.vehiclePhysics!.speedInKilometersPerHour < 0.5{
                    self.vehiclePhysics!.applyEngineForce(-self.engineForce, forWheelAt: 0)
                    self.vehiclePhysics!.applyEngineForce(-self.engineForce, forWheelAt: 1)
                } else {
                    // rear wheels
                    self.vehiclePhysics!.applyBrakingForce(self.rearBreakingForce, forWheelAt: 0)
                    self.vehiclePhysics!.applyBrakingForce(self.rearBreakingForce, forWheelAt: 1)
                    // front wheels
                    self.vehiclePhysics!.applyBrakingForce(self.frontBreakingForce, forWheelAt: 2)
                    self.vehiclePhysics!.applyBrakingForce(self.frontBreakingForce, forWheelAt: 3)
                }
                
            } else {
                // rear wheels
                self.vehiclePhysics!.applyBrakingForce(0, forWheelAt: 0)
                self.vehiclePhysics!.applyBrakingForce(0, forWheelAt: 1)
                // front wheels
                self.vehiclePhysics!.applyBrakingForce(0, forWheelAt: 2)
                self.vehiclePhysics!.applyBrakingForce(0, forWheelAt: 3)
                // resets reverse wheels
                self.vehiclePhysics!.applyEngineForce(0, forWheelAt: 0)
                self.vehiclePhysics!.applyEngineForce(0, forWheelAt: 1)
            }
        }
        
    }
}

