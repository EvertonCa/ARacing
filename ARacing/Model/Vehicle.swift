//
//  Vehicle.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 01/05/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

class Vehicle {
    
    //MARK: - Vehicle
    
    // Vehicle Scene
    var vehicleScene = SCNScene()
    
    // Vehicle SCNPhysicsVehicle
    var vehiclePhysics = SCNPhysicsVehicle()
    
    // Vehicle node
    var vehicleNode = SCNNode()
    
    // Vehicle Collision Geometry
    var collisionGeometry = SCNNode()
    
    // Vehicle Index for Multiplayer
    var vehicleIndex:Int?
    
    //MARK: - Driving and Vehicle Parameters
    
    // Steer angle
    let steerAngle:CGFloat = 0.8
    
    // Engine force
    let engineForce: CGFloat = 2
    
    // Breaking force
    let frontBreakingForce: CGFloat = 2
    let rearBreakingForce: CGFloat = 1
    
    // Driving variables
    var turningRight = false
    var turningLeft = false
    var accelerating = false
    var breaking = false
    
    // Body Parameters
    let allowsResting = false
    let mass:CGFloat = 1
    let restitution:CGFloat = 0.1
    let friction:CGFloat = 0.5
    let rollingFriction:CGFloat = 0.1
    
    // Suspension Parameter
    let maximumSuspensionForce:CGFloat = 0
    let frictionSlip:CGFloat = 0.1
    
    //MARK: - Control Variables
    
    // Vehicle Spawned
    var vehicleSpawned = false
    
    // Vehicle Initial Spawn position
    let initialSpawnPosition:SCNVector3
    
    // Vehicle spawn position
    var spawnPosition = SCNVector3Zero
    
    //MARK: - Brains
    
    // AR Brains
    var singleARBrain:SingleARBrains?
    var multiARBrain:MultiARBrains?
    var rcBrain:RCBrains?
    
    //MARK: - Other Variables
    // SceneView
    var sceneView:ARSCNView
    
    // ARView
    var arView:ARViewController
    
    // Game
    var game:Game
    
    //MARK: - Inits
    
    init(arView:ARViewController, singleBrain:SingleARBrains, game:Game, sceneView:ARSCNView) {
        self.arView = arView
        self.singleARBrain = singleBrain
        self.game = game
        self.sceneView = sceneView
        self.initialSpawnPosition = self.game.vehiclePosition()
    }
    
    init(arView:ARViewController, rcBrains:RCBrains, game:Game, sceneView:ARSCNView) {
        self.arView = arView
        self.rcBrain = rcBrains
        self.game = game
        self.sceneView = sceneView
        self.initialSpawnPosition = SCNVector3Zero
    }
    
    init(arView:ARViewController, multiARBrain:MultiARBrains, game:Game, sceneView:ARSCNView, index:Int) {
        self.arView = arView
        self.multiARBrain = multiARBrain
        self.game = game
        self.sceneView = sceneView
        self.vehicleIndex = index
        self.initialSpawnPosition = self.game.listVehiclesSpawn[self.game.mapSelected][self.vehicleIndex!]
    }
    
    //MARK: - Functions
    
    // create vehicle for single player mode
    func createVehicleSinglePlayer() {
        self.createVehicle()
        self.setupVehicleCollision()
        self.vehicleNode.position = self.initialSpawnPosition
        self.spawnPosition = self.initialSpawnPosition
        
        // adds the vehicle to the scenery
        self.arView.singleARBrain?.mapNode.addChildNode(self.vehicleNode)
        
        self.vehicleSpawned = true
    }
    
    // create vehicle for multi player mode
    func createVehicleMultiPlayer() {
        self.createVehicle()
        self.setupVehicleCollision()
        self.vehicleNode.position = self.initialSpawnPosition
        self.spawnPosition = self.initialSpawnPosition
        
        // adds the vehicle to the scenery
        self.arView.multiARBrain?.mapNode.addChildNode(self.vehicleNode)
        
        self.vehicleSpawned = true
    }
    
    //create vehicle for RC Mode
    func createVehicleRC(hitTest: ARHitTestResult) {
        self.createVehicle()
        
        // hit test to position the vehicle
        let transform = hitTest.worldTransform
        let thirdColumn = transform.columns.3
        self.vehicleNode.position = SCNVector3(thirdColumn.x, thirdColumn.y + 0.1, thirdColumn.z)
        
        // adds the vehicle to the scene
        self.sceneView.scene.rootNode.addChildNode(self.vehicleNode)
        
        self.vehicleSpawned = true
    }
    
    // creates the vehicle
    func createVehicle() {

        // vehicle scene for multiplayer
        if self.vehicleIndex != nil {
            self.vehicleScene = SCNScene(named: self.game.vehicleResourceWithIndex(index: self.vehicleIndex!))!
        }
        // vehicle scene for single player and RC
        else {
            self.vehicleScene = SCNScene(named: self.game.vehicleResource())!
        }
        
        // Main vehicle node
        self.vehicleNode = (self.vehicleScene.rootNode.childNode(withName: "Chassis", recursively: false))!
        self.vehicleNode.name = "Vehicle"
        
        // Collision Geometry
        self.collisionGeometry = (self.vehicleScene.rootNode.childNode(withName: "Physics", recursively: false))!
        
        // sets the physics body and its parameters
        self.vehicleNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: self.collisionGeometry, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
        
        self.vehicleNode.physicsBody?.allowsResting = self.allowsResting
        self.vehicleNode.physicsBody?.mass = self.mass
        self.vehicleNode.physicsBody?.restitution = self.restitution
        self.vehicleNode.physicsBody?.friction = self.friction
        self.vehicleNode.physicsBody?.rollingFriction = self.rollingFriction
        
        // Wheels setup
        let frontLeft = SCNPhysicsVehicleWheel(node: self.vehicleNode.childNode(withName: "FLP", recursively: true)!)
        let frontRight = SCNPhysicsVehicleWheel(node: self.vehicleNode.childNode(withName: "FRP", recursively: true)!)
        let rearLeft = SCNPhysicsVehicleWheel(node: self.vehicleNode.childNode(withName: "RLP", recursively: true)!)
        let rearRight = SCNPhysicsVehicleWheel(node: self.vehicleNode.childNode(withName: "RRP", recursively: true)!)
        
        let wheels = [rearLeft, rearRight, frontLeft, frontRight]
        
        wheels.forEach {
            $0.maximumSuspensionForce = self.maximumSuspensionForce
            $0.frictionSlip = self.frictionSlip
            var connectionPosition = $0.connectionPosition
            connectionPosition.x = -connectionPosition.x
            $0.connectionPosition = connectionPosition
        }
        
        // Creates the Physics Vehicle
        self.vehiclePhysics = SCNPhysicsVehicle(chassisBody: self.vehicleNode.physicsBody!, wheels: wheels)
        
        // sets the physics world
        self.sceneView.scene.physicsWorld.addBehavior(self.vehiclePhysics)
    }
    
    // removes the vehicle in the scenery and spawns another one
    func restartVehicle() {
        let particle = self.explodeVehicle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.vehicleNode.position = self.spawnPosition
            self.vehicleNode.physicsBody?.clearAllForces()
            particle.removeFromParentNode()
        }
    }
    
    // sets the collisions
    func setupVehicleCollision() {
        // sets collision
        self.vehicleNode.physicsBody?.categoryBitMask = BitMaskCategory.Vehicle.rawValue
        self.vehicleNode.physicsBody?.contactTestBitMask = BitMaskCategory.Checkpoint.rawValue
    }
    
    // explodes vehicle
    func explodeVehicle() -> SCNNode {
        // explosion
        let explosion = SCNParticleSystem(named: ParticlesResources.VehicleExplosion1.rawValue, inDirectory: nil)
        explosion?.loops = false
        explosion?.emissionDuration = 1
        explosion?.emitterShape = self.vehicleNode.geometry
        
        let explosion2 = SCNParticleSystem(named: ParticlesResources.VehicleExplosion2.rawValue, inDirectory: nil)
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
                self.vehiclePhysics.setSteeringAngle(-self.steerAngle, forWheelAt: 2)
                self.vehiclePhysics.setSteeringAngle(-self.steerAngle, forWheelAt: 3)
            }
            // steer the vehicle to left
            else if self.turningLeft {
                self.vehiclePhysics.setSteeringAngle(self.steerAngle, forWheelAt: 2)
                self.vehiclePhysics.setSteeringAngle(self.steerAngle, forWheelAt: 3)
            }
            // straightens the vehicle
            else {
                self.vehiclePhysics.setSteeringAngle(0, forWheelAt: 2)
                self.vehiclePhysics.setSteeringAngle(0, forWheelAt: 3)
            }

            // Acceleration, Breaking and Reversing
            if self.accelerating {
                self.vehiclePhysics.applyEngineForce(self.engineForce, forWheelAt: 0)
                self.vehiclePhysics.applyEngineForce(self.engineForce, forWheelAt: 1)
            } else if self.breaking {
                // if vehicle is stopped, reverse, else, brakes
                if self.vehiclePhysics.speedInKilometersPerHour < 0.1{
                    self.vehiclePhysics.applyEngineForce(-self.engineForce, forWheelAt: 0)
                    self.vehiclePhysics.applyEngineForce(-self.engineForce, forWheelAt: 1)
                } else {
                    // rear wheels
                    self.vehiclePhysics.applyBrakingForce(self.rearBreakingForce, forWheelAt: 0)
                    self.vehiclePhysics.applyBrakingForce(self.rearBreakingForce, forWheelAt: 1)
                    // front wheels
                    self.vehiclePhysics.applyBrakingForce(self.frontBreakingForce, forWheelAt: 2)
                    self.vehiclePhysics.applyBrakingForce(self.frontBreakingForce, forWheelAt: 3)
                }
                
            } else {
                // rear wheels
                self.vehiclePhysics.applyBrakingForce(0, forWheelAt: 0)
                self.vehiclePhysics.applyBrakingForce(0, forWheelAt: 1)
                // front wheels
                self.vehiclePhysics.applyBrakingForce(0, forWheelAt: 2)
                self.vehiclePhysics.applyBrakingForce(0, forWheelAt: 3)
                // resets reverse wheels
                self.vehiclePhysics.applyEngineForce(0, forWheelAt: 0)
                self.vehiclePhysics.applyEngineForce(0, forWheelAt: 1)
            }
            
            if self.game.gameTypeSelected != GameMode.RCMode.rawValue {
                if self.vehicleNode.presentation.position.x < -1.05 || self.vehicleNode.presentation.position.y < -1.05 ||
                    self.vehicleNode.presentation.position.x > 1.05 || self.vehicleNode.presentation.position.y > 1.05 {
                
                        self.restartVehicle()
                }
            }
        }
    }
}

