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
    
    // ARSCNView
    @IBOutlet weak var sceneView: ARSCNView!
    // UIButtons
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var accButton: UIButton!
    @IBOutlet weak var brakeButton: UIButton!
    @IBOutlet weak var turnRightButton: UIButton!
    @IBOutlet weak var turnLeftButton: UIButton!
    @IBOutlet weak var beginHostingButton: UIButton!
    //UIImageViews
    @IBOutlet weak var startButtonBackground: UIImageView!
    @IBOutlet weak var accButtonBackground: UIImageView!
    @IBOutlet weak var brakeButtonBackground: UIImageView!
    @IBOutlet weak var pauseButtonBackground: UIImageView!
    @IBOutlet weak var turnLeftButtonBackground: UIImageView!
    @IBOutlet weak var turnRightButtonBackground: UIImageView!
    @IBOutlet weak var trackingFeedbackImage: UIImageView!
    @IBOutlet weak var beginHostingBackground: UIImageView!
    // UILabels
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var trackingStatusLabel: UILabel!
    @IBOutlet weak var connectedWithLabel: UILabel!
    
    
    
    
    
    //MARK: - Brains
    
    // Single AR Brain
    var singleARBrain: SingleARBrains?
    
    // Multi AR Brain
    var multiARBrain: MultiARBrains?
    
    // RC Brain
    var rcBrains: RCBrains?
    
    // Menu Brains
    var menuBrains: MenuBrains!
    
    // Type Brain
    var arBrain: ARBrain!
    
    //MARK: - Constants and Variables
    
    // Initially dummy Game
    var game:Game!
    
    //MARK: - View overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Prevents screen from sleeping
        UIApplication.shared.isIdleTimerDisabled = true
        
        // hide all the UI
        self.hideUI()
        
        // Starts the Game Class in dummy way
        self.game = Game()
        
        // Starts the AR view with temporary configuration
        let tempConfig = ARWorldTrackingConfiguration()
        self.sceneView.session.run(tempConfig)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.goToOptionsViewController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's AR session.
        self.sceneView.session.pause()
    }
    
    //MARK: - Segue functions
    
    // perform segue to OptionsViewController
    func goToOptionsViewController() {
        // perform segue to options controller
        performSegue(withIdentifier: "GoToType", sender: self)
    }
    
    // perform segue to MapsViewController
    func goToMapsViewController() {
        // perform segue to maps controller
        performSegue(withIdentifier: "GoToMaps", sender: self)
    }
    
    // perform segue to VehicleSelectionViewController
    func goToVehicleSelectionViewController() {
        // perform segue to vehicle controller
        performSegue(withIdentifier: "GoToVehicleSelection", sender: self)
    }
    
    // perform segue to MultiPeerViewController
    func goToMultiPeerViewController() {
        // perform segue to multipeer controller
        performSegue(withIdentifier: "GoToMultipeer", sender: self)
    }
    
    // Prepare segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToType" {
            let destinationVC = segue.destination as! OptionsViewController
            destinationVC.delegate = self
        }
        else if segue.identifier == "GoToMaps" {
            let destinationVC = segue.destination as! MapsViewController
            destinationVC.delegate = self
            destinationVC.game = self.game
        }
        else if segue.identifier == "GoToVehicleSelection" {
            let destinationVC = segue.destination as! VehicleSelectionViewController
            destinationVC.delegate = self
            destinationVC.game = self.game
        }
        else if segue.identifier == "GoToMultipeer" {
            let destinationVC = segue.destination as! MultiPeerViewController
            destinationVC.delegate = self
        }
    }
    
    //MARK: - Setup Modes Functions
    
    // Setups Single Player Mode
    func singlePlayerSelected() {
        // sets the selected type
        self.game.gameTypeSelected = GameMode.SinglePlayer.rawValue
        
        // Type Brains started
        self.arBrain = ARBrain(game:self.game, view: self)
        
        // start Single AR Brain
        self.singleARBrain = SingleARBrains(self.sceneView, self, self.arBrain.game)
        
    }
    
    // Starts the Single Player Mode
    func startSinglePlayer() {
        // defines the AR Delegates
        self.defineARDelegates()
        
        // setup the AR Experience
        self.singleARBrain?.setupView()
    }
    
    // Setups Multi Player Mode
    func multiPlayerSelected() {
        // sets the selected type
        self.game.gameTypeSelected = GameMode.MultiPlayer.rawValue
        
        // Type Brains started
        self.arBrain = ARBrain(game:self.game, view: self)
        
        // start Multi AR Brain
        self.multiARBrain = MultiARBrains(self.sceneView, self, self.arBrain.game)
    }
    
    // Starts the Single Player Mode
    func startMultiPlayer() {
        // defines the AR Delegates
        self.defineARDelegates()
        
        // setup the AR Experience
        self.multiARBrain?.setupView()
        
    }
    
    // Starts the RC Mode
    func rcModeSelected() {
        // sets the selected type
        self.game.gameTypeSelected = GameMode.RCMode.rawValue
        
        // Type Brains started
        self.arBrain = ARBrain(game:self.game, view: self)
        
        // start RC Brain
        self.rcBrains = RCBrains(self.sceneView, self, self.arBrain.game)
    }
    
    // Starts the SRC Mode
    func startRC() {
        // defines the AR Delegates
        self.defineARDelegates()
        
        // setup the AR Experience
        self.rcBrains!.setupView()
    }
    
    //MARK: - Delegate handlers functions
    
    // starts the delegates
    func defineARDelegates() {
        // setup delegate
        self.sceneView.delegate = self
        
        // AR session delegate
        self.sceneView.session.delegate = self
        
        if self.game.gameTypeSelected == GameMode.SinglePlayer.rawValue || self.game.gameTypeSelected == GameMode.MultiPlayer.rawValue{
            // setup contact delegate
            self.sceneView.scene.physicsWorld.contactDelegate = self
        }
    }
    
    // resets the delegates
    func resetDelegates() {
        self.sceneView.delegate = nil
        self.sceneView.session.delegate = nil
        
        if self.game.gameTypeSelected == GameMode.SinglePlayer.rawValue || self.game.gameTypeSelected == GameMode.MultiPlayer.rawValue{
            
            self.sceneView.scene.physicsWorld.contactDelegate = nil
        }
    }
    
    //MARK: - UI Functions
    
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
        self.recordLabel.alpha = 0
        self.trackingStatusLabel.alpha = 0
        self.connectedWithLabel.alpha = 0
        self.trackingFeedbackImage.alpha = 0
        self.pauseButtonBackground.alpha = 0
        self.beginHostingButton.alpha = 0
        self.beginHostingBackground.alpha = 0
        
        // disables all buttons
        self.startButton.isEnabled = false
        self.accButton.isEnabled = false
        self.turnRightButton.isEnabled = false
        self.turnLeftButton.isEnabled = false
        self.brakeButton.isEnabled = false
        self.beginHostingButton.isEnabled = false
    }
    
    // enables and changes alpha to 1 for the startButton
    func showStartButton() {
        DispatchQueue.main.async {
            self.startButton.isEnabled = true
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
                self.startButton.alpha = 1
                self.startButtonBackground.alpha = 1
            })
        }
    }
    
    // Show the Begin Hosting button
    func showBeginHostingButton() {
        self.beginHostingButton.isEnabled = true
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            self.beginHostingBackground.alpha = 1.0
            self.beginHostingButton.alpha = 1.0
        })
    }
    
    // Hides the Begin Hosting button
    func hideBeginHostingButton() {
        self.beginHostingButton.isEnabled = false
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            self.beginHostingBackground.alpha = 0.0
            self.beginHostingButton.alpha = 0.0
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
    
    // Connected with feedback
    func connectedWith(message:String) {
        UIView.animate(withDuration: 1.0, animations: {
            self.connectedWithLabel.alpha = 1.0
            self.connectedWithLabel.text = message
        }) { ( success ) in
            UIView.animate(withDuration: 1.0, delay: 5.0, animations: {
                self.connectedWithLabel.alpha = 0
            })
        }
    }
    
    // Tracking feedback
    func showTrackingFeedback(message:String) {
        UIView.animate(withDuration: 1.0, animations: {
            self.trackingStatusLabel.alpha = 1.0
            self.trackingStatusLabel.text = message
        })
    }
    
    // Hide tracking status label
    func hideTrackingFeedback() {
        UIView.animate(withDuration: 1.0, animations: {
            self.trackingStatusLabel.alpha = 0.0
            self.trackingStatusLabel.text = ""
        })
    }
    
    // enables driving buttons
    func showDrivingUI() {
        // enables all buttons
        self.accButton.isEnabled = true
        self.turnRightButton.isEnabled = true
        self.turnLeftButton.isEnabled = true
        self.brakeButton.isEnabled = true
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
            
        })
    }
    
    // Show tracking quality label
    func showTrackingQualityFeedback() {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
            self.trackingStatusLabel.alpha = 1.0
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
    @IBAction func beginHostingPressed(_ sender: UIButton) {
        self.arBrain.beginHostingPressed()
        self.hideBeginHostingButton()
    }
}
