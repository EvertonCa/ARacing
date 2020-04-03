//
//  SingleARBrains.swift
//  ARacing
//
//  Created by Everton Cardoso on 03/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import RealityKit

class SingleARBrains {
    
    var arView: ARView!
    
    var fase1: ARacing.Fase1!
    
    init(arView: ARView) {
        self.arView = arView
    }
    
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
    
}
