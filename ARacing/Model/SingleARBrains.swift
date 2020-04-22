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
    
    // Steer angle
    let steerAngle:CGFloat = 0.8
    
    // Engine force
    let engineForce: CGFloat = 10
    
    // Breaking force
    let frontBreakingForce: CGFloat = 20
    let rearBreakingForce: CGFloat = 10
    
    // Grid node
    var gridNode:SCNNode?
    
    // Feedback Label
    var feedbackLabel: UILabel?
    
    // Gestures
    var gesturesBrain:GesturesSingleAR!
    
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
        self.gesturesBrain = GesturesSingleAR(sceneView: self.sceneView, arBrains: self)
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
        let frontLeftWheelToChassis = frontLeftWheel.convertPosition(SCNVector3Zero, to: vehicleNode)
        let frontLeftPositionToConnect = SCNVector3Make(frontLeftWheelToChassis.x - centerFL, frontLeftWheelToChassis.y, frontLeftWheelToChassis.z)
        v_frontLeftWheel.connectionPosition = frontLeftPositionToConnect

        let frontRightWheelToChassis = frontRightWheel.convertPosition(SCNVector3Zero, to: vehicleNode)
        let frontRightPositionToConnect = SCNVector3Make(frontRightWheelToChassis.x + centerFR, frontRightWheelToChassis.y, frontRightWheelToChassis.z)
        v_frontRightWheel.connectionPosition = frontRightPositionToConnect

        let rearLeftWheelToChassis = rearLeftWheel.convertPosition(SCNVector3Zero, to: vehicleNode)
        let rearLeftPositionToConnect = SCNVector3Make(rearLeftWheelToChassis.x - centerRL, rearLeftWheelToChassis.y, rearLeftWheelToChassis.z)
        v_rearLeftWheel.connectionPosition = rearLeftPositionToConnect

        let rearRightWheelToChassis = rearRightWheel.convertPosition(SCNVector3Zero, to: vehicleNode)
        let rearRightPositionToConnect = SCNVector3Make(rearRightWheelToChassis.x + centerRR, rearRightWheelToChassis.y, rearRightWheelToChassis.z)
        v_rearRightWheel.connectionPosition = rearRightPositionToConnect
        
        //if the option is true, it considers all of the geometries. If false, just combines into one geometry
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: vehicleNode, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
        
        // body physical properties
        body.mass = 1
        body.allowsResting = false
        body.restitution = 0.5
        body.rollingFriction = 0.2
        body.friction = 0.2
        body.rollingFriction = 0
        
        // - - - - - - - - - wheels physical properties - - - - - - - - -
        
        // The default value of this property is 1.0. Lower values result in better traction, and higher values make the wheel more likely to slip (causing it to spin freely instead of moving the vehicle).
//        v_frontLeftWheel.frictionSlip = 1.2
//        v_frontRightWheel.frictionSlip = 1.2
//        v_rearLeftWheel.frictionSlip = 1.2
//        v_rearRightWheel.frictionSlip = 1.2
        
        // When you create a wheel from a node, its default radius is half of the largest dimension of the node’s bounding box. (A wheel is always circular, even if the content of the node representing it is not.)
//        v_frontLeftWheel.radius = CGFloat(0.018)
//        v_frontRightWheel.radius = CGFloat(0.018)
//        v_rearLeftWheel.radius = CGFloat(0.018)
//        v_rearRightWheel.radius = CGFloat(0.018)
        
        // The spring coefficient determines both how quickly the wheel returns to its natural position after a shock (for example, when the vehicle runs over a bump) and how much force from the shock it transmits to the vehicle. The default spring coefficient is 2.0.
//        v_frontLeftWheel.suspensionStiffness = CGFloat(1.0)
//        v_frontRightWheel.suspensionStiffness = CGFloat(1.0)
//        v_rearLeftWheel.suspensionStiffness = CGFloat(1.0)
//        v_rearRightWheel.suspensionStiffness = CGFloat(1.0)
        
        // The default suspension coefficient is 4.4. Lower values cause the wheel to return to its natural position more quickly.
//        v_frontLeftWheel.suspensionCompression = CGFloat(5)
//        v_frontRightWheel.suspensionCompression = CGFloat(5)
//        v_rearLeftWheel.suspensionCompression = CGFloat(5)
//        v_rearRightWheel.suspensionCompression = CGFloat(5)
        
        // Damping ratio measures the tendency of the suspension to oscillate after a shock—in other words, for the vehicle to bounce up and down after running over a bump. The default damping ratio of 2.3 causes the wheel to return to its neutral position quickly after a shock. Values lower than 1.0 result in more oscillation.
//        v_frontLeftWheel.suspensionDamping = CGFloat(5)
//        v_frontRightWheel.suspensionDamping = CGFloat(5)
//        v_rearLeftWheel.suspensionDamping = CGFloat(5)
//        v_rearRightWheel.suspensionDamping = CGFloat(5)
        
        // Travel is the total distance a wheel is allowed to move (in both directions), in the coordinate system of the node containing the vehicle’s chassis. The default suspension travel is 500.0.
        v_frontLeftWheel.maximumSuspensionTravel = CGFloat(10)
        v_frontRightWheel.maximumSuspensionTravel = CGFloat(10)
        v_rearLeftWheel.maximumSuspensionTravel = CGFloat(10)
        v_rearRightWheel.maximumSuspensionTravel = CGFloat(10)
        
        // The physics simulation applies a force of no greater than this magnitude when contact with the ground causes the wheel to move relative to the vehicle. The default maximum suspension force is 6000.0.
//        v_frontLeftWheel.maximumSuspensionForce = CGFloat(10)
//        v_frontRightWheel.maximumSuspensionForce = CGFloat(10)
//        v_rearLeftWheel.maximumSuspensionForce = CGFloat(10)
//        v_rearRightWheel.maximumSuspensionForce = CGFloat(10)
        
        // This property measures the length of the simulated spring between the vehicle and its wheel when the spring is not stressed by the weight of either body. When the wheel receives a shock (for example, when the vehicle runs over a bump), SceneKit adds the difference between the wheel’s current position and its connection position to this rest length and then applies a force between the wheel and vehicle proportional to the total.
        v_frontLeftWheel.suspensionRestLength = CGFloat(0.045)
        v_frontRightWheel.suspensionRestLength = CGFloat(0.045)
        v_rearLeftWheel.suspensionRestLength = CGFloat(0.045)
        v_rearRightWheel.suspensionRestLength = CGFloat(0.045)
        
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
    // handles Acceleration, Breaking, Reversing and Steering for the vehicle
    func updatesVehicle() {
        // steer the vehicle to right
        if self.turningRight {
            self.vehicle.setSteeringAngle(self.steerAngle, forWheelAt: 2)
            self.vehicle.setSteeringAngle(self.steerAngle, forWheelAt: 3)
        }
        // steer the vehicle to left
        else if self.turningLeft {
            self.vehicle.setSteeringAngle(-self.steerAngle, forWheelAt: 2)
            self.vehicle.setSteeringAngle(-self.steerAngle, forWheelAt: 3)
        }
        // straightens the vehicle
        else {
            self.vehicle.setSteeringAngle(0, forWheelAt: 2)
            self.vehicle.setSteeringAngle(0, forWheelAt: 3)
        }

        // Acceleration, Breaking and Reversing
        if self.accelerating {
            self.vehicle.applyEngineForce(self.engineForce, forWheelAt: 0)
            self.vehicle.applyEngineForce(self.engineForce, forWheelAt: 1)
        } else if self.breaking {
            // if vehicle is stopped, reverse, else, brakes
            if self.vehicle.speedInKilometersPerHour < 0.5{
                self.vehicle.applyEngineForce(-self.engineForce, forWheelAt: 0)
                self.vehicle.applyEngineForce(-self.engineForce, forWheelAt: 1)
            } else {
                // rear wheels
                self.vehicle.applyBrakingForce(self.rearBreakingForce, forWheelAt: 0)
                self.vehicle.applyBrakingForce(self.rearBreakingForce, forWheelAt: 1)
                // front wheels
                self.vehicle.applyBrakingForce(self.frontBreakingForce, forWheelAt: 2)
                self.vehicle.applyBrakingForce(self.frontBreakingForce, forWheelAt: 3)
            }
            
        } else {
            // rear wheels
            self.vehicle.applyBrakingForce(0, forWheelAt: 0)
            self.vehicle.applyBrakingForce(0, forWheelAt: 1)
            // front wheels
            self.vehicle.applyBrakingForce(0, forWheelAt: 2)
            self.vehicle.applyBrakingForce(0, forWheelAt: 3)
            // resets reverse wheels
            self.vehicle.applyEngineForce(0, forWheelAt: 0)
            self.vehicle.applyEngineForce(0, forWheelAt: 1)
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
