//
//  Message.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 07/05/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import ARKit
import UIKit

struct Message: Codable {
    var peerHashID:Int
    var messageType:Int
    var transform:[[Float]]?
    var arWorldMapData:Data?
    var selectedVehicle:Int?
    var peersQuantity:Int?
    var peersHashID:[Int]?
    var listSelectedVehicles:[Int]?
    var vehicleTransformMatrix:[[Float]]?
}
