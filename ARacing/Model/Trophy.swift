//
//  Trophy.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 20/05/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import ARKit

struct Trophy {
    // creates the trophy SCN Node
    static func getTrophy() -> SCNNode {
        let trophyScene = SCNScene(named: TrophyResources.Trophy.rawValue)
        let trophyNode = (trophyScene?.rootNode.childNode(withName: "Trophy", recursively: false))!
        
        trophyNode.position = SCNVector3(0, 0.6, 0)
        
        trophyNode.name = "Trophy"
        
        let spinAnimation = SCNAction.repeat(.rotate(by: .pi, around: SCNVector3(0, 1, 0), duration: 3), count: 3)
        trophyNode.runAction(spinAnimation)
        
        return trophyNode
    }
}
