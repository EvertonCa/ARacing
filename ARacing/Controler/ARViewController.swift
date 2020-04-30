//
//  SingleARViewController.swift
//  ARacing
//
//  Created by Everton Cardoso on 03/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import UIKit
import ARKit

class ARViewController: UIViewController {
    
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
    
    @IBOutlet weak var timerLabel: UILabel!
    
    //MARK: - Brains
    
    // Single AR Brain
    var singleARBrain: SingleARBrains?
    
    // RC Brain
    var rcBrains: RCBrains?
    
    // Menu Brains
    var menuBrains: MenuBrains!
    
    // Type Brain
    var arBrain: ARBrain!
    
    //MARK: - Constants and Variables
    
    // Type Selected
    var typeSelected: Int?
    
    // Map selected
    var mapSelected: Int = 0
    
    //MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide all the UI
        self.hideUI()
        
        // Starts the AR view with temporary configuration
        let tempConfig = ARWorldTrackingConfiguration()
        self.sceneView.session.run(tempConfig)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.goToOptionsViewController()
    }
    
    // perform segue to OptionsViewController
    func goToOptionsViewController() {
        // perform segue to options controller
        performSegue(withIdentifier: "GoToType", sender: self)
    }
    
    // perform segue to MapsViewController
    func goToMapsViewController() {
        // perform segue to options controller
        performSegue(withIdentifier: "GoToMaps", sender: self)
    }
    
    // Starts AR Session as Single Player Mode
    func singlePlayerSelected() {
        // sets the selected type
        self.typeSelected = TypeSelected.SinglePlayer.rawValue
        
        // Type Brains started
        self.arBrain = ARBrain(type: self.typeSelected!, view: self)
        
        // start Single AR Brain
        self.singleARBrain = SingleARBrains(sceneView, self)
        self.singleARBrain!.mapSelected = self.mapSelected
        
        // defines the AR Delegates
        self.defineARDelegates()
        
        // setup the AR Experience
        self.singleARBrain?.setupView()
        
        // show feedback to move the camera
        self.showFeedback(text: "Move your device to detect the plane to place your AR map!")
        
    }
    
    // Starts AR Session as Multi Player Mode
    func multiPlayerSelected() {
        // sets the selected type
        self.typeSelected = TypeSelected.MultiPlayer.rawValue
        
        // Type Brains started
        self.arBrain = ARBrain(type: self.typeSelected!, view: self)
        
        // start Multi AR Brain
        
        // defines the AR Delegates
        self.defineARDelegates()
    }
    
    // Starts AR Session as RC Mode
    func rcModeSelected() {
        // sets the selected type
        self.typeSelected = TypeSelected.RCMode.rawValue
        
        // Type Brains started
        self.arBrain = ARBrain(type: self.typeSelected!, view: self)
        
        // start RC Brain
        self.rcBrains = RCBrains(sceneView, self)
        
        // defines the AR Delegates
        self.defineARDelegates()
        
        // setup the AR Experience
        self.rcBrains!.setupView()
        
        // show feedback to move the camera
        self.showFeedback(text: "Move your device to detect the plane to place your RC car!")
    }
    
    // starts the delegates
    func defineARDelegates() {
        // setup delegate
        self.sceneView.delegate = self
        
        if self.typeSelected == TypeSelected.SinglePlayer.rawValue ||
            self.typeSelected == TypeSelected.MultiPlayer.rawValue{
            // setup contact delegate
            self.sceneView.scene.physicsWorld.contactDelegate = self
        }
    }
    
    // resets the delegates
    func resetDelegates() {
        self.sceneView.delegate = nil
        
        if self.typeSelected == TypeSelected.SinglePlayer.rawValue ||
            self.typeSelected == TypeSelected.MultiPlayer.rawValue{
            
            self.sceneView.scene.physicsWorld.contactDelegate = nil
        }
    }
    
    // hide all buttons with alpha = 0
    func hideUI() {
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
        self.feedbackLabel.alpha = 0
        self.timerLabel.alpha = 0
        
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
    
    //MARK: - Segues
    
    // Prepare segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToType" {
            let destinationVC = segue.destination as! OptionsViewController
            destinationVC.delegate = self
        }
        else if segue.identifier == "GoToMaps" {
            let destinationVC = segue.destination as! MapsViewController
            destinationVC.delegate = self
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        // calls the handler for the start button
        self.arBrain.startButtonPressed()
        
        // removes feedback label
        self.hideFeedback()
        
        // hides the button
        self.hideStartButton()
        
    }
    
    @IBAction func accPressed(_ sender: UIButton) {
        self.arBrain.accPressed()
        self.accButtonBackground.alpha = 0.8
    }
    @IBAction func accReleased(_ sender: UIButton) {
        self.arBrain.accReleased()
        self.accButtonBackground.alpha = 1.0
    }
    @IBAction func brakePressed(_ sender: UIButton) {
        self.arBrain.brakePressed()
        self.brakeButtonBackground.alpha = 0.8
    }
    @IBAction func breakReleased(_ sender: UIButton) {
        self.arBrain.brakeReleased()
        self.brakeButtonBackground.alpha = 1.0
    }
    @IBAction func turnRightPressed(_ sender: UIButton) {
        self.arBrain.turnRightPressed()
        self.turnRightButtonBackground.alpha = 0.8
    }
    @IBAction func turnRightReleased(_ sender: UIButton) {
        self.arBrain.turnRightReleased()
        self.turnRightButtonBackground.alpha = 1.0
    }
    @IBAction func turnLeftPressed(_ sender: UIButton) {
        self.arBrain.turnLeftPressed()
        self.turnLeftButtonBackground.alpha = 0.8
    }
    @IBAction func turnLeftReleased(_ sender: UIButton) {
        self.arBrain.turnLeftReleased()
        self.turnLeftButtonBackground.alpha = 1.0
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.arBrain.resetExperience()
    }
}