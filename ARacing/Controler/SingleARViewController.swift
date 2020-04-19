//
//  SingleARViewController.swift
//  ARacing
//
//  Created by Everton Cardoso on 03/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import UIKit
import ARKit

class SingleARViewController: UIViewController {
    
    //MARK: - Global IBOutlets and Variables
    
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var startButtonBackground: UIImageView!
    @IBOutlet weak var accButton: UIButton!
    @IBOutlet weak var brakeButton: UIButton!
    @IBOutlet weak var turnRightButton: UIButton!
    @IBOutlet weak var turnLeftButton: UIButton!
    @IBOutlet weak var accButtonBackground: UIImageView!
    @IBOutlet weak var brakeButtonBackground: UIImageView!
    @IBOutlet weak var turnLeftButtonBackground: UIImageView!
    @IBOutlet weak var turnRightButtonBackground: UIImageView!
    
    // Single AR Brain
    var singleARBrain: SingleARBrains!
    
    //MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start Single AR Brain
        singleARBrain = SingleARBrains(sceneView, self)
        
        // setup delegate
        self.sceneView.delegate = self
        
        // hide all the UI
        self.hideButtons()
        
        // setup the AR Experience
        self.singleARBrain.setupView()
        
        // show feedback to move the camera
        self.showFeedback(text: "Move your device to detect the plane to place your AR map!")
        
    }
    
    // hide all buttons with alpha = 0
    func hideButtons() {
        // alphas to 0
        self.startButton.alpha = 0
        self.startButtonBackground.alpha = 0
        self.accButton.alpha = 0
        self.turnRightButton.alpha = 0
        self.turnLeftButton.alpha = 0
        self.brakeButton.alpha = 0
        self.accButtonBackground.alpha = 0
        self.brakeButtonBackground.alpha = 0
        self.turnLeftButtonBackground.alpha = 0
        self.turnRightButtonBackground.alpha = 0
        
        // disables all buttons
        self.startButton.isEnabled = false
        self.accButton.isEnabled = false
        self.turnRightButton.isEnabled = false
        self.turnLeftButton.isEnabled = false
        self.brakeButton.isEnabled = false
    }
    
    // enables and changes alpha to 1 for the startButton
    func showStartButton() {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
            self.startButton.alpha = 1
            self.startButtonBackground.alpha = 1
            self.startButton.isEnabled = true
        })
    }
    
    // re-enables and changes alpha to 1 for the startButton and changes the text to respawn
    func reanableStartButton() {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
            self.startButton.alpha = 1
            self.startButtonBackground.alpha = 1
            self.startButton.isEnabled = true
            self.startButton.setTitle("Respawn!", for: .normal)
        })
    }
    
    // hides the start button
    func hideStartButton() {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
            self.startButton.isEnabled = false
            self.startButton.alpha = 0
            self.startButtonBackground.alpha = 0
        })
    }
    
    // enables driving buttons
    func showDrivingUI() {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
            // alphas to 1
            self.accButton.alpha = 1
            self.turnRightButton.alpha = 1
            self.turnLeftButton.alpha = 1
            self.brakeButton.alpha = 1
            self.accButtonBackground.alpha = 1
            self.brakeButtonBackground.alpha = 1
            self.turnLeftButtonBackground.alpha = 1
            self.turnRightButtonBackground.alpha = 1
            
            // enables all buttons
            self.accButton.isEnabled = true
            self.turnRightButton.isEnabled = true
            self.turnLeftButton.isEnabled = true
            self.brakeButton.isEnabled = true
        })
    }
    
    // enables feedback label
    func showFeedback(text:String) {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
            self.feedbackLabel.alpha = 1.0
            self.feedbackLabel.text = text
        })
    }
    
    // hide feedback label
    func hideFeedback() {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
            self.feedbackLabel.alpha = 0
            self.feedbackLabel.text = ""
        })
    }
    
    //MARK: - IBActions
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        if self.startButton.currentTitle == "Start" {
            // show vehicle in the view
            self.singleARBrain.createVehicle()
            
            // disable gestures
            self.singleARBrain.gesturesBrain.removeRotationGesture()
            
            // removes feedback label
            self.hideFeedback()
            
            // sets the scenery to locked
            self.singleARBrain.sceneryLocked = true
            
            //shows driving UI
            self.showDrivingUI()
        } else {
            // show vehicle in the view
            self.singleARBrain.createVehicle()
        }
        // hides the button
        //self.hideStartButton()
        
    }
    
    @IBAction func accPressed(_ sender: UIButton) {
        self.singleARBrain.accelerating = true
        self.accButton.alpha = 0.8
        self.accButtonBackground.alpha = 0.8
    }
    @IBAction func accReleased(_ sender: UIButton) {
        self.singleARBrain.accelerating = false
        self.accButton.alpha = 1.0
        self.accButtonBackground.alpha = 1.0
    }
    @IBAction func brakePressed(_ sender: UIButton) {
        self.singleARBrain.breaking = true
        self.brakeButton.alpha = 0.8
        self.brakeButtonBackground.alpha = 0.8
    }
    @IBAction func breakReleased(_ sender: UIButton) {
        self.singleARBrain.breaking = false
        self.brakeButton.alpha = 1.0
        self.brakeButtonBackground.alpha = 1.0
    }
    @IBAction func turnRightPressed(_ sender: UIButton) {
        self.singleARBrain.turningRight = true
        self.turnRightButton.alpha = 0.8
        self.turnRightButtonBackground.alpha = 0.8
    }
    @IBAction func turnRightReleased(_ sender: UIButton) {
        self.singleARBrain.turningRight = false
        self.turnRightButton.alpha = 1.0
        self.turnRightButtonBackground.alpha = 1.0
    }
    @IBAction func turnLeftPressed(_ sender: UIButton) {
        self.singleARBrain.turningLeft = true
        self.turnLeftButton.alpha = 0.8
        self.turnLeftButtonBackground.alpha = 0.8
    }
    @IBAction func turnLeftReleased(_ sender: UIButton) {
        self.singleARBrain.turningLeft = false
        self.turnLeftButton.alpha = 1.0
        self.turnLeftButtonBackground.alpha = 1.0
    }
}
