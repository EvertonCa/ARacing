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
    
    // Single AR Brain
    var singleARBrain: SingleARBrains!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start Single AR Brain
        singleARBrain = SingleARBrains(sceneView)
        
        // setup delegate
        self.sceneView.delegate = self
        
    }
    
    @IBAction func test(_ sender: UIButton) {
        
        
    }

}
