//
//  RCViewController.swift
//  ARacing
//
//  Created by Everton Cardoso on 19/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import UIKit
import ARKit

class RCViewController: UIViewController {
    
    //MARK: - Global IBOutlets and Variables

    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var accButton: UIButton!
    @IBOutlet weak var brakeButton: UIButton!
    @IBOutlet weak var turnRightButton: UIButton!
    @IBOutlet weak var turnLeftButton: UIButton!
    @IBOutlet weak var accButtonBackground: UIImageView!
    @IBOutlet weak var brakeButtonBackground: UIImageView!
    @IBOutlet weak var turnLeftButtonBackground: UIImageView!
    @IBOutlet weak var turnRightButtonBackground: UIImageView!
    
    // RC Brain
    var rcBrains: RCBrains!
    
    //MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start Single AR Brain
        rcBrains = RCBrains(sceneView, self)
        
        // setup delegate
        self.sceneView.delegate = self
        
        // hide all the UI
        self.hideButtons()
        
        // setup the AR Experience
        self.rcBrains.setupView()
        
        // show feedback to move the camera
        self.showFeedback(text: "Move your device to detect the plane to place your RC car!")
        
    }
    
    // hide all buttons with alpha = 0
    func hideButtons() {
        // alphas to 0
        self.accButton.alpha = 0
        self.turnRightButton.alpha = 0
        self.turnLeftButton.alpha = 0
        self.brakeButton.alpha = 0
        self.accButtonBackground.alpha = 0
        self.brakeButtonBackground.alpha = 0
        self.turnLeftButtonBackground.alpha = 0
        self.turnRightButtonBackground.alpha = 0
        
        // disables all buttons
        self.accButton.isEnabled = false
        self.turnRightButton.isEnabled = false
        self.turnLeftButton.isEnabled = false
        self.brakeButton.isEnabled = false
    }
    
    // enables driving buttons
    func showDrivingUI() {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
            // alphas to 1
            self.accButton.alpha = 0.5
            self.turnRightButton.alpha = 0.5
            self.turnLeftButton.alpha = 0.5
            self.brakeButton.alpha = 0.5
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
    
    @IBAction func accPressed(_ sender: UIButton) {
        self.rcBrains.accelerating = true
        self.accButtonBackground.alpha = 0.8
    }
    @IBAction func accReleased(_ sender: UIButton) {
        self.rcBrains.accelerating = false
        self.accButtonBackground.alpha = 1.0
    }
    
    @IBAction func brakePressed(_ sender: UIButton) {
        self.rcBrains.breaking = true
        self.brakeButtonBackground.alpha = 0.8
    }
    @IBAction func brakeReleased(_ sender: UIButton) {
        self.rcBrains.breaking = false
        self.brakeButtonBackground.alpha = 1.0
    }
    
    @IBAction func rightPressed(_ sender: UIButton) {
        self.rcBrains.turningRight = true
        self.turnRightButtonBackground.alpha = 0.8
    }
    @IBAction func rightReleased(_ sender: UIButton) {
        self.rcBrains.turningRight = false
        self.turnRightButtonBackground.alpha = 1.0
    }
    
    @IBAction func leftPressed(_ sender: UIButton) {
        self.rcBrains.turningLeft = true
        self.turnLeftButtonBackground.alpha = 0.8
    }
    @IBAction func leftReleased(_ sender: UIButton) {
        self.rcBrains.turningLeft = false
        self.turnLeftButtonBackground.alpha = 1.0
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
