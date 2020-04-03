//
//  SingleARViewController.swift
//  ARacing
//
//  Created by Everton Cardoso on 03/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import UIKit
import RealityKit

class SingleARViewController: UIViewController {

    @IBOutlet weak var arView: ARView!
    
    var singleARBrain: SingleARBrains!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singleARBrain = SingleARBrains(arView: arView)

        singleARBrain.loadFase1()
    }
    
    @IBAction func test(_ sender: UIButton) {
        singleARBrain.showExperience()
        
    }

}
