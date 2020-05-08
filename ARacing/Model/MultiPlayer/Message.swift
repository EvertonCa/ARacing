//
//  Message.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 07/05/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation

struct Message: Codable {
    var peerHashID:Int
    var name: String
    var number:Double
    var trueOrFalse:Bool
}
