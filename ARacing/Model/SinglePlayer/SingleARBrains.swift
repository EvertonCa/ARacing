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
    
    // Scenery
    var mapNode = SCNNode()
    
    // Grid node
    var gridNode:SCNNode?
    
    // Feedback Label
    var feedbackLabel: UILabel?
    
    //MARK: - Models
    
    // Game
    var game:Game
    
    // Gestures
    var gesturesBrain:GesturesSingleAR!
    
    // ViewController
    var arViewController: ARViewController!
    
    // Checkpoints
    var checkpoints: SingleCheckpoint!
    
    // Scenery
    var map: Map!
    
    // Lap Timer
    var lapTimer: LapTimer!
    
    // AR Text
    var arText: SingleTexts!
    
    // Vehicles
    var vehicle: Vehicle! = nil
    
    //MARK: - Functions
    
    init(_ sceneView: ARSCNView, _ view: ARViewController, _ game:Game) {
        self.sceneView = sceneView
        self.arViewController = view
        self.game = game
    }
    
    // setup the view when it loads
    func setupView() {
        
        // debug options - feature points and world origin
        self.sceneView.debugOptions = [.showPhysicsShapes]
        
        // show statistics
        //self.sceneView.showsStatistics = true
        
        // config to detect horizontal surfaces
        self.arConfiguration.planeDetection = .horizontal
        
        // enables default lighting
        self.sceneView.autoenablesDefaultLighting = true
        
        // run session
        self.sceneView.session.run(arConfiguration, options: [.removeExistingAnchors, .resetTracking])
        
        // setup the gestures recognizer
        self.gesturesBrain = GesturesSingleAR(sceneView: self.sceneView, arBrains: self)
        self.gesturesBrain.registerGesturesrecognizers()
        
        // setup scenery
        self.map = Map(mapNode: self.mapNode, sceneView: self.sceneView, game: self.game)
        
        // setup LapTimer
        self.lapTimer = LapTimer(timerLabel: arViewController.timerLabel)
        
        // setup AR Text
        self.arText = SingleTexts()
        
        // setup Vehicles
        self.vehicle = Vehicle(arView: self.arViewController, singleBrain: self, game: self.game, sceneView: self.sceneView)
        
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

    // adds the scenery and disable gestures and the grid nodes
    func setupMap(hitTestResult: ARHitTestResult) {
        self.mapNode = self.map.addMap(hitTestResult: hitTestResult)
        
        self.gesturesBrain.removeTapGesture()
        
        // changes feedback label
        self.arViewController.showFeedback(text: "Rotate the map to match your surface and press Start to begin!")
        
        // removes all the grids in the scene
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "Grid" {
                node.removeFromParentNode()
            }
        }
        
        // setup checkpoints
        self.checkpoints = SingleCheckpoint(mapNode: self.mapNode, game: self.game)
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
        textNode.position = SCNVector3(0, 0.6, 0)
        textNode.opacity = 0
        self.mapNode.addChildNode(textNode)
        
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
                textNode.position = SCNVector3(0, 0.6, 0)
                textNode.opacity = 0
                self.mapNode.addChildNode(textNode)
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
                        textNode.position = SCNVector3(0, 0.6, 0)
                        textNode.opacity = 0
                        self.mapNode.addChildNode(textNode)
                    
                        // starts the timer
                        self.lapTimer.startTimer()
                        self.arViewController.timerLabel.alpha = 1
                        self.arViewController.timerLabel.isHidden = false
                    
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
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
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
        self.checkRecord()
        self.lapTimer.resetTimer()
    }
    
    // checks if the time is a record
    func checkRecord() {
        if self.lapTimer.counter < self.game.checkRecord() {
            self.game.saveRecord(record:self.lapTimer.counter)
            
            
        }
    }
    
    // returns the current record for the selected map as a string to show to user
    func getRecordText() -> String {
        let currentRecordInSeconds = self.game.checkRecord()
        
        if currentRecordInSeconds == 99999999.9 {
            return "Best Time: ?"
        }
        
        let counterInt = Int(currentRecordInSeconds)
        let minutes = counterInt / 60
        let seconds = currentRecordInSeconds - Double(60 * minutes)
        
        let text = "Best Time: \(minutes)m" + String(format: "%.1f", seconds) + "s"
        
        return text
    }
    
    // animates the new record in the label
    func updateRecordLabel() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
            self.arViewController.recordLabel.alpha = 0.5
        }){ ( success ) in
            UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
                self.arViewController.recordLabel.text = self.getRecordText()
                self.arViewController.recordLabel.alpha = 1.0
            })
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
