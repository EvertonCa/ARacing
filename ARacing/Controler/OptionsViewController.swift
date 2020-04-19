//
//  OptionsViewController.swift
//  ARacing
//
//  Created by Everton Cardoso on 03/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    //MARK: - Global IBOutlets and Variables
    
    @IBOutlet weak var singlePlayerButton: UIButton!
    @IBOutlet weak var multiPlayerButton: UIButton!
    @IBOutlet weak var rcModeButton: UIButton!
    
    // Menu Brains
    var menuBrains:MenuBrains!
    
    //MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - IBActions
    
    // Stops the music and segue to SingleARViewController
    @IBAction func singlePlayerPressed(_ sender: UIButton) {
        menuBrains.stopIntroMusic()
        self.performSegue(withIdentifier: "goToSingleAR", sender: self)
    }
    
    
    @IBAction func multiPlayerPressed(_ sender: UIButton) {
        menuBrains.stopIntroMusic()
        self.performSegue(withIdentifier: "goToMultiAR", sender: self)
    }
    
    @IBAction func rcModePressed(_ sender: UIButton) {
        menuBrains.stopIntroMusic()
        self.performSegue(withIdentifier: "goToRC", sender: self)
    }
    
}
