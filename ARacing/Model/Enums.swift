//
//  Enums.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 30/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation

//MARK: - Maps Enums

// map selected enum
enum MapSelected: Int {
    case Map1 = 0
    case Map2 = 1
    case Map3 = 2
    case Map4 = 3
}

// Maps Resources
enum MapsResources: String {
    case Map1 = "3D Models.scnassets/Maps/Track1.scn"
    case Map2 = "3D Models.scnassets/Maps/Test_Ice.scn"
    case Map3 = "3D Models.scnassets/Maps/Track3.scn"
    case Map4 = "3D Models.scnassets/Maps/Map4.scn"
}

// Maps Images
enum MapsImages: String {
    case Map1 = "Map1Icon"
    case Map2 = "Map2Icon"
    case Map3 = "Map3Icon"
    case Map4 = "Map4Icon"
}

// Maps Names
enum MapsNames: String {
    case Map1 = "Map1"
    case Map2 = "Map2"
    case Map3 = "Map3"
    case Map4 = "Map4"
}

//MARK: - Vehicles Enums

// Vehicle Resources
enum VehicleResources: String {
    case Vehicle1_small = "3D Models.scnassets/Vehicles Assets/BugattiSmall.scn"
    case Vehicle1_normal = "3D Models.scnassets/Vehicles Assets/BugattiNormal.scn"
    case Vehicle2_small = "3D Models.scnassets/Vehicles Assets/SinglePlaceholder.scn"
    case Vehicle2_normal = "3D Models.scnassets/Vehicles Assets/BrabusNormal.scn"
    case Vehicle3_small = "3D Models.scnassets/Vehicles Assets/PlaceholderSmall2.scn"
    case Vehicle3_normal = "3D Models.scnassets/Vehicles Assets/PlaceholderNormal2.scn"
    case Vehicle4_small = "3D Models.scnassets/Vehicles Assets/PlaceholderSmall3.scn"
    case Vehicle4_normal = "3D Models.scnassets/Vehicles Assets/PlaceholderNormal3.scn"
    case Vehicle5_small = "3D Models.scnassets/Vehicles Assets/PlaceholderSmall4.scn"
    case Vehicle5_normal = "3D Models.scnassets/Vehicles Assets/PlaceholderNormal4.scn"
    case Vehicle6_small = "3D Models.scnassets/Vehicles Assets/PlaceholderSmall5.scn"
    case Vehicle6_normal = "3D Models.scnassets/Vehicles Assets/PlaceholderNormal5.scn"
    case Vehicle7_small = "3D Models.scnassets/Vehicles Assets/PlaceholderSmall6.scn"
    case Vehicle7_normal = "3D Models.scnassets/Vehicles Assets/PlaceholderNormal6.scn"
    case Vehicle8_small = "3D Models.scnassets/Vehicles Assets/PlaceholderSmall7.scn"
    case Vehicle8_normal = "3D Models.scnassets/Vehicles Assets/PlaceholderNormal7.scn"
    case Vehicle9_small = "3D Models.scnassets/Vehicles Assets/PlaceholderSmall8.scn"
    case Vehicle9_normal = "3D Models.scnassets/Vehicles Assets/PlaceholderNormal8.scn"
    case Vehicle10_small = "3D Models.scnassets/Vehicles Assets/PlaceholderSmall9.scn"
    case Vehicle10_normal = "3D Models.scnassets/Vehicles Assets/PlaceholderNormal9.scn"
    case Vehicle11_small = "3D Models.scnassets/Vehicles Assets/PlaceholderSmall10.scn"
    case Vehicle11_normal = "3D Models.scnassets/Vehicles Assets/PlaceholderNormal10.scn"
    case Vehicle12_small = "3D Models.scnassets/Vehicles Assets/PlaceholderSmall11.scn"
    case Vehicle12_normal = "3D Models.scnassets/Vehicles Assets/PlaceholderNormal11.scn"
    case Vehicle13_small = "3D Models.scnassets/Vehicles Assets/PlaceholderSmall12.scn"
    case Vehicle13_normal = "3D Models.scnassets/Vehicles Assets/PlaceholderNormal12.scn"
    case Vehicle14_small = "3D Models.scnassets/Vehicles Assets/PlaceholderSmall13.scn"
    case Vehicle14_normal = "3D Models.scnassets/Vehicles Assets/PlaceholderNormal13.scn"
    case Vehicle15_small = "3D Models.scnassets/Vehicles Assets/PlaceholderSmall14.scn"
    case Vehicle15_normal = "3D Models.scnassets/Vehicles Assets/PlaceholderNormal14.scn"
    case Vehicle16_small = "3D Models.scnassets/Vehicles Assets/PlaceholderSmall15.scn"
    case Vehicle16_normal = "3D Models.scnassets/Vehicles Assets/PlaceholderNormal15.scn"
}

// Vehicle Names
enum VehicleNames: Int {
    case Vehicle1 = 0
    case Vehicle2 = 1
    case Vehicle3 = 2
    case Vehicle4 = 3
    case Vehicle5 = 4
    case Vehicle6 = 5
    case Vehicle7 = 6
    case Vehicle8 = 7
    case Vehicle9 = 8
    case Vehicle10 = 9
    case Vehicle11 = 10
    case Vehicle12 = 11
    case Vehicle13 = 12
    case Vehicle14 = 13
    case Vehicle15 = 14
    case Vehicle16 = 15
}

// Vehicle Images
enum VehicleImages: String {
    case Vehicle1 = "Vehicle1Icon"
    case Vehicle2 = "Vehicle2Icon"
    case Vehicle3 = "Vehicle3Icon"
    case Vehicle4 = "Vehicle4Icon"
    case Vehicle5 = "Vehicle5Icon"
    case Vehicle6 = "Vehicle6Icon"
    case Vehicle7 = "Vehicle7Icon"
    case Vehicle8 = "Vehicle8Icon"
    case Vehicle9 = "Vehicle9Icon"
    case Vehicle10 = "Vehicle10Icon"
    case Vehicle11 = "Vehicle11Icon"
    case Vehicle12 = "Vehicle12Icon"
    case Vehicle13 = "Vehicle13Icon"
    case Vehicle14 = "Vehicle14Icon"
    case Vehicle15 = "Vehicle15Icon"
    case Vehicle16 = "Vehicle16Icon"
}

//MARK: - Text Enum

// Text Resources
enum TextResources: String {
    case Ready = "3D Models.scnassets/Text Assets/ReadyText.scn"
    case Set = "3D Models.scnassets/Text Assets/SetText.scn"
    case Go = "3D Models.scnassets/Text Assets/GoText.scn"
}

//MARK: - Collision Enums

// collision enum
enum BitMaskCategory: Int {
    case Vehicle = 4
    case Checkpoint = 8
}

//MARK: - Game Mode Enums

// Game Mode
enum GameMode: Int {
    case SinglePlayer = 1
    case MultiPlayer = 2
    case RCMode = 3
}

//MARK: - Checkpoints Enums

// Checkpoints Resources
enum CheckpointsResources: String {
    case Checkpoint = "3D Models.scnassets/Checkpoint Assets/CheckPoint.scn"
}

//MARK: - Particles Enums

// Particles Resources
enum ParticlesResources: String {
    case VehicleExplosion1 = "3D Models.scnassets/Particles/Explosion.scnp"
    case VehicleExplosion2 = "3D Models.scnassets/Particles/Explosion2.scnp"
    case CheckpointFire1 = "3D Models.scnassets/Particles/Fire.scnp"
    case CheckpointFire2 = "3D Models.scnassets/Particles/Fire2.scnp"
    case ConfettiText = "3D Models.scnassets/Particles/Confetti.scnp"
}

//MARK: - User Defaults Enums

// Map Records Keys
enum MapRecord: String {
    case Map1 = "map1Record"
    case Map2 = "map2Record"
    case Map3 = "map3Record"
    case Map4 = "map4Record"
}

//MARK: - Multipeer Enums

// Type of connection selected
enum Connection: Int {
    case Host = 1
    case Join = 2
}

//MARK: - Tracking UI Enum
enum TrackingUI: String {
    case mapped = "Mapped"
    case extending = "Extending"
    case limited = "Limited"
    case notAvailable = "NotAvailable"
}

//MARK: - Messages Enums
enum MessageType: Int {
    case ARWorldMapAndTransformMatrix = 1
    case SelectedVehicle = 2
    case StartGame = 3
}
