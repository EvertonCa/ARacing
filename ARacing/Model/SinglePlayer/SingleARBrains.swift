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
    var sceneryNode = SCNNode()
    
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
    
    //MARK: - Models
    
    // Gestures
    var gesturesBrain:GesturesSingleAR!
    
    // ViewController
    var singleARViewController: SingleARViewController!
    
    // Checkpoints
    var checkpoints: SingleCheckpoint!
    
    // Scenery
    var scenery: SingleScenery!
    
    // Lap Timer
    var lapTimer: LapTimer!
    
    // AR Text
    var arText: SingleTexts!
    
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
        
        // setup scenery
        self.scenery = SingleScenery(sceneryNode: self.sceneryNode, sceneView: self.sceneView)
        
        // setup LapTimer
        self.lapTimer = LapTimer(timerLabel: singleARViewController.timerLabel)
        
        // setup AR Text
        self.arText = SingleTexts()
        
    }
    
    // creates the grid that shows the horizontal surface
    func createGrid(planeAnchor: ARPlaneAnchor) -> SCNNode {
        
        let gridNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
        gridNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Grid")
        gridNode.geometry?.firstMaterial?.isDoubleSided = true
        gridNode.position = SCNVector3(CGFloat(planeAnchor.center.x), CGFloat(planeAnchor.center.y), CGFloat(planeAnchor.center.z))
        gridNode.eulerAngles = SCNVector3(x: Float(90.degreesToRadians), y: 0, z: 0)
        
        gridNode.name = "Grid"
        
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
        
        v_frontLeftWheel.maximumSuspensionTravel = CGFloat(10)
        v_frontRightWheel.maximumSuspensionTravel = CGFloat(10)
        v_rearLeftWheel.maximumSuspensionTravel = CGFloat(10)
        v_rearRightWheel.maximumSuspensionTravel = CGFloat(10)
        
        v_frontLeftWheel.suspensionRestLength = CGFloat(0.045)
        v_frontRightWheel.suspensionRestLength = CGFloat(0.045)
        v_rearLeftWheel.suspensionRestLength = CGFloat(0.045)
        v_rearRightWheel.suspensionRestLength = CGFloat(0.045)
        
        // sets the position of the chassis
        self.vehicleNode.position = currentPositionOfCamera
        
        // rotation of the vehicle
        self.vehicleNode.eulerAngles = SCNVector3(x: -Float(90.degreesToRadians), y: 0, z: 0)
        
        // sets the physics body to the chassis
        self.vehicleNode.physicsBody = body
        
        // sets collision
        self.vehicleNode.physicsBody?.categoryBitMask = BitMaskCategory.Vehicle.rawValue
        self.vehicleNode.physicsBody?.contactTestBitMask = BitMaskCategory.Checkpoint.rawValue
        
        // Vehicle physics
        self.vehicle = SCNPhysicsVehicle(chassisBody: vehicleNode.physicsBody!, wheels: [v_rearLeftWheel, v_rearRightWheel, v_frontRightWheel, v_frontLeftWheel])
        
        // adds the vehicle to the physics world
        self.sceneView.scene.physicsWorld.addBehavior(self.vehicle)
        
        // adds the vehicle to the scenery
        self.sceneryNode.addChildNode(vehicleNode)
        
        self.startRace()
    }
    
    // removes the vehicle in the scenery
    func removeVehicle() {
        self.vehicleNode.removeFromParentNode()
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
    
    // adds the scenery and disable gestures and the grid nodes
    func setupScenery(hitTestResult: ARHitTestResult) {
        self.sceneryNode = self.scenery.addScenery(hitTestResult: hitTestResult)
        
        self.gesturesBrain.removeTapGesture()
        
        // changes feedback label
        self.singleARViewController.showFeedback(text: "Rotate the map to match your surface and press Start to place your car!")
        
        // removes all the grids in the scene
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "Grid" {
                node.removeFromParentNode()
            }
        }
        
        // setup checkpoints
        self.checkpoints = SingleCheckpoint(sceneryNode: self.sceneryNode)
    }
    
    // adds the checkpoints with particles in the right place
    func updateCheckpoint() {
        if !self.checkpoints.setupCheckpoints() {
            self.endRace()
        }
    }
    
    // shows the checkpoints, AR Text and starts the timer.
    func startRace() {
        
        // shows the Ready AR Text
        var textNode = self.arText.showReadyText()
        textNode.position = SCNVector3(0, 0, 0.3)
        textNode.opacity = 0
        self.sceneryNode.addChildNode(textNode)
        
        //animate fade in Ready Text
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        textNode.opacity = 1
        SCNTransaction.commit()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            //animate fade out Ready Text
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            textNode.opacity = 0
            SCNTransaction.completionBlock = {
                // removes the Ready text
                textNode.removeFromParentNode()
                
                // shows the Set AR Text
                textNode = self.arText.showSetText()
                textNode.position = SCNVector3(0, 0, 0.3)
                textNode.opacity = 0
                self.sceneryNode.addChildNode(textNode)
            }
            SCNTransaction.commit()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                //animate fade in Set Text
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                textNode.opacity = 1
                SCNTransaction.commit()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    //animate fade out Set text
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 0.5
                    textNode.opacity = 0
                    SCNTransaction.completionBlock = {
                        // removes the Set text
                        textNode.removeFromParentNode()
                    
                        // shows the GO AR Text
                        textNode = self.arText.showGoText()
                        textNode.position = SCNVector3(0, 0, 0.3)
                        textNode.opacity = 0
                        self.sceneryNode.addChildNode(textNode)
                    
                        // starts the timer
                        self.lapTimer.startTimer()
                        self.singleARViewController.timerLabel.isHidden = false
                    
                        // setup the checkpoints and particles
                        self.updateCheckpoint()
                        
                    }
                    SCNTransaction.commit()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        //animate fade in Go Text
                        SCNTransaction.begin()
                        SCNTransaction.animationDuration = 0.5
                        textNode.opacity = 1
                        SCNTransaction.commit()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            //animate fade out Go Text
                            SCNTransaction.begin()
                            SCNTransaction.animationDuration = 0.5
                            textNode.opacity = 0
                            SCNTransaction.completionBlock = {
                                // removes the Ready text
                                textNode.removeFromParentNode()
                            }
                            SCNTransaction.commit()
                        }
                    }
                }
                
            }
        }
        
    }
    
    // ends the race
    func endRace() {
        self.lapTimer.stopTimer()
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
