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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start Single AR Brain
        singleARBrain = SingleARBrains(sceneView)
        
        // setup delegate
        self.sceneView.delegate = self
        
        // hide all the UI
        self.hideButtons()
        
    }
    
    func hideButtons() {
        self.startButton.alpha = 0
        self.startButtonBackground.alpha = 0
        self.accButton.alpha = 0
        self.turnRightButton.alpha = 0
        self.turnLeftButton.alpha = 0
        self.turnLeftButton.alpha = 0
        self.accButtonBackground.alpha = 0
        self.brakeButtonBackground.alpha = 0
        self.turnLeftButtonBackground.alpha = 0
        self.turnRightButtonBackground.alpha = 0
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
    }
    @IBAction func accPressed(_ sender: UIButton) {
    }
    @IBAction func brakePressed(_ sender: UIButton) {
    }
    @IBAction func turnRightPressed(_ sender: UIButton) {
    }
    @IBAction func turnLeftPressed(_ sender: UIButton) {
    }
    
}
