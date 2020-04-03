//
//  OptionsViewController.swift
//  ARacing
//
//  Created by Everton Cardoso on 03/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var singlePlayerButton: UIButton!
    @IBOutlet weak var multiPlayerButton: UIButton!
    
    
    var menuBrains:MenuBrains!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func singlePlayerPressed(_ sender: UIButton) {
        menuBrains.stopIntroMusic()
        self.performSegue(withIdentifier: "goToSingleAR", sender: self)
    }
    
    
    @IBAction func multiPlayerPressed(_ sender: UIButton) {
    }
    

}
