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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadFase1()
    }
    
    var fase1: ARacing.Fase1!
    
    
    func loadFase1() {
        ARacing.loadFase1Async { [weak self] result in
            switch result {
            case .success(let anchor):
                guard let self = self else { return }
                print("LOADED")
                
                anchor.generateCollisionShapes(recursive: true)
                
                self.fase1 = anchor
            
            case .failure(let error):
            print("Unable to load the game with error: \(error.localizedDescription)")
            }
        }
    }
    
    func showExperience() {
        self.arView.scene.anchors.append(fase1)
    }
    
    @IBAction func test(_ sender: UIButton) {
        showExperience()
        var animations = self.fase1.car1?.availableAnimations
        
    }

}
