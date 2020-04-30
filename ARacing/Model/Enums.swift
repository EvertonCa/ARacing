//
//  Enums.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 30/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation

// type selected enum
enum TypeSelected: Int {
    case SinglePlayer = 1
    case MultiPlayer = 2
    case RCMode = 3
}

// map selected enum
enum MapSelected: Int {
    case Map1 = 1
    case Map2 = 2
    case Map3 = 3
}

// collision enum
enum BitMaskCategory: Int {
    case Vehicle = 4
    case Checkpoint = 8
}
