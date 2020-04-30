//
//  ViewController.swift
//  ARacing
//
//  Created by Everton Cardoso on 02/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    //MARK: - Global IBOutlets and Variables
    
    @IBOutlet weak var backgroundGame: UIImageView!
    @IBOutlet weak var backgroundSplash: UIImageView!
    @IBOutlet weak var logoARacing: UIImageView!
    @IBOutlet weak var backgroundButtonStart: UIImageView!
    @IBOutlet weak var buttonStart: UIButton!
    
    // Menu Brains
    var menuBrains = MenuBrains()
    
    //MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide all the initial UI
        self.hideInitialUI()
        
        // Start playing background music
        menuBrains.playIntroMusic()
        
        // Animate the intro
        animateIntro()
    }
    
    // changes the alphas of all the initial UI to 0
    func hideInitialUI() {
        backgroundGame.alpha = 0.0
        backgroundButtonStart.alpha = 0.0
        buttonStart.alpha = 0.0
    }
    
    // Initial animation
    func animateIntro() {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
            self.backgroundSplash.alpha = 0.0
            self.backgroundGame.alpha = 1.0
        }) { ( success ) in
            self.animateIntro2()
        }
    }
    
    // Continuation to the animation
    func animateIntro2() {
        UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
            self.logoARacing.center.y -= UIScreen.main.bounds.height/4
            self.backgroundButtonStart.alpha = 1.0
            self.buttonStart.alpha = 1.0
            self.logoARacing.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { ( success ) in
            
        }
    }
    
    // Prepare segue to OptionsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAR" {
            let destinationVC = segue.destination as! ARViewController
            destinationVC.menuBrains = menuBrains
        }
    }
    
    //MARK: - IBActions

    // Start segue to OptionViewController
    @IBAction func startButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToAR", sender: self)
    }
}

