//
//  Utilities.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 20/05/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

//MARK: - Extension to Int
extension Int {
    
    var degreesToRadians: Double { return Double(self) * .pi/180 }
}


//MARK: - Overload +
func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
