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

// Game Mode
enum GameMode: Int {
    case SinglePlayer = 1
    case MultiPlayer = 2
    case RCMode = 3
}

// Maps Resources
enum MapsResources: String {
    case Map1 = "3D Models.scnassets/Tracks/Track1.scn"
    case Map2 = "3D Models.scnassets/Tracks/Test_Ice.scn"
    case Map3 = "3D Models.scnassets/Tracks/Track3.scn"
}

// Checkpoints Resources
enum CheckpointsResources: String {
    case Checkpoint = "3D Models.scnassets/Checkpoint Assets/CheckPoint.scn"
    case CheckpointFire1 = "3D Models.scnassets/Checkpoint Assets/Fire.scnp"
    case CheckpointFire2 = "3D Models.scnassets/Checkpoint Assets/Fire2.scnp"
}

// Vehicle Resources
enum VehicleResources: String {
    case PlaceholderRC = "3D Models.scnassets/Vehicles Assets/RCPlaceholder.scn"
    case PlaceholderSingle = "3D Models.scnassets/Vehicles Assets/SinglePlaceholder.scn"
    case Z3 = "3D Models.scnassets/Vehicles Assets/Z3.scn"
    case BugattiSmall = "3D Models.scnassets/Vehicles Assets/BugattiSmall.scn"
    case BugattiRC = "3D Models.scnassets/Vehicles Assets/BugattiRC.scn"
}

// Vehicle Names
enum VehicleNames: Int {
    case Chiron = 0
    case Corvette = 1
    case LancerEvo = 2
    case Placeholder1 = 3
    case Placeholder2 = 4
}

// Particles Resources
enum ParticlesResources: String {
    case VehicleExplosion1 = "3D Models.scnassets/Vehicles Assets/Explosion.scnp"
    case VehicleExplosion2 = "3D Models.scnassets/Vehicles Assets/Explosion2.scnp"
}


