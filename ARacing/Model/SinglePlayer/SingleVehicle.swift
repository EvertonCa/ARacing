//
//  SingleVehicle.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 22/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

class SingleVehicle {
    
    //MARK: - Variables and Constants
    
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
    
    // Vehicle Spawned
    var vehicleSpawned = false
    
    // Vehicle spawn position
    var spawnPosition = SCNVector3(-0.8, 0.3, 0.8)
    
    // Steer angle
    let steerAngle:CGFloat = 0.8
    
    // Engine force
    let engineForce: CGFloat = 10
    
    // Breaking force
    let frontBreakingForce: CGFloat = 20
    let rearBreakingForce: CGFloat = 10
    
    // AR Brains
    var arBrain:SingleARBrains
    
    //MARK: - Functions
    
    init(arBrain:SingleARBrains) {
        self.arBrain = arBrain
    }
    
    // creates the vehicle
    func createVehicle() {
        
        // position on the scenery to spawn
        let currentPositionOfCamera = self.spawnPosition
        
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
        //self.vehicleNode.eulerAngles = SCNVector3(x: -Float(90.degreesToRadians), y: 0, z: 0)
        
        // sets the physics body to the chassis
        self.vehicleNode.physicsBody = body
        
        // sets collision
        self.vehicleNode.physicsBody?.categoryBitMask = BitMaskCategory.Vehicle.rawValue
        self.vehicleNode.physicsBody?.contactTestBitMask = BitMaskCategory.Checkpoint.rawValue
        
        // Vehicle physics
        self.vehicle = SCNPhysicsVehicle(chassisBody: vehicleNode.physicsBody!, wheels: [v_rearLeftWheel, v_rearRightWheel, v_frontRightWheel, v_frontLeftWheel])
        
        // adds the vehicle to the physics world
        self.arBrain.sceneView.scene.physicsWorld.addBehavior(self.vehicle)
        
        // adds the vehicle to the scenery
        self.arBrain.sceneryNode.addChildNode(vehicleNode)
        
        // sets the flag to true
        self.vehicleSpawned = true
    }
    
    // removes the vehicle in the scenery and spawns another one
    func restartVehicle() {
        let particle = self.explodeVehicle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.vehicleNode.position = self.spawnPosition
            particle.removeFromParentNode()
            
        }
    }
    
    // explodes vehicle
    func explodeVehicle() -> SCNNode {
        // explosion
        let explosion = SCNParticleSystem(named: "3D Models.scnassets/Explosion.scnp", inDirectory: nil)
        explosion?.loops = false
        explosion?.emissionDuration = 1
        explosion?.emitterShape = self.vehicleNode.geometry
        
        let explosion2 = SCNParticleSystem(named: "3D Models.scnassets/Explosion2.scnp", inDirectory: nil)
        explosion2?.loops = false
        explosion2?.emissionDuration = 1
        explosion2?.emitterShape = self.vehicleNode.geometry
        
        let explosionNode = SCNNode()
        
        let particleNode = SCNNode()
        particleNode.addParticleSystem(explosion!)
        particleNode.position = SCNVector3(0, 0, 0)
        particleNode.eulerAngles = SCNVector3(x: 0, y: 0, z: 0)
        explosionNode.addChildNode(particleNode)
        
        let particleNode2 = SCNNode()
        particleNode2.addParticleSystem(explosion2!)
        particleNode2.position = SCNVector3(0, 0, 0)
        particleNode2.eulerAngles = SCNVector3(x: 0, y: 0, z: 0)
        explosionNode.addChildNode(particleNode2)
        
        self.vehicleNode.addChildNode(explosionNode)
        
        return explosionNode
    }
    
    // handles Acceleration, Breaking, Reversing and Steering for the vehicle. Also when vehicle is out of bounds
    func updatesVehicle() {
        if vehicleSpawned {
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
            
            if self.vehicleNode.presentation.position.x < -1.05 || self.vehicleNode.presentation.position.y < -1.05 ||
                self.vehicleNode.presentation.position.x > 1.05 || self.vehicleNode.presentation.position.y > 1.05 {
                
                print("Entrei!!")
                self.restartVehicle()
            }
        }
    }
}
