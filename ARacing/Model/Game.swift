//
//  Game.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 05/05/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import UIKit
import ARKit

// Controlls all game parameters and variables
class Game {
    //MARK: - Game Controlls Variables
    
    // Game Type Selected
    var gameTypeSelected:Int
    
    //MARK: - Map Controlls and Resources
    
    // Map selected
    var mapSelected:Int
    
    // Map Resources Addresses
    let mapResourcesAddresses:[String] = ["NO MAP",
                                        MapsResources.Map1.rawValue,
                                        MapsResources.Map2.rawValue,
                                        MapsResources.Map3.rawValue,
                                        MapsResources.Map4.rawValue]
    
    //MARK: - Vehicle Controlls and Resources
    
    // Vehicle Selected
    var vehicleSelected:Int
    
    // Single and Multi Player Vehicles Resources Addresses
    let vehicleSmallResourcesAddresses:[String] = [VehicleResources.Vehicle1_small.rawValue, VehicleResources.Vehicle2_small.rawValue,
                                              VehicleResources.Vehicle3_small.rawValue, VehicleResources.Vehicle4_small.rawValue,
                                              VehicleResources.Vehicle5_small.rawValue, VehicleResources.Vehicle6_small.rawValue,
                                              VehicleResources.Vehicle7_small.rawValue, VehicleResources.Vehicle8_small.rawValue,
                                              VehicleResources.Vehicle9_small.rawValue, VehicleResources.Vehicle10_small.rawValue,
                                              VehicleResources.Vehicle11_small.rawValue, VehicleResources.Vehicle12_small.rawValue,
                                              VehicleResources.Vehicle13_small.rawValue, VehicleResources.Vehicle14_small.rawValue,
                                              VehicleResources.Vehicle15_small.rawValue, VehicleResources.Vehicle16_small.rawValue]
    
    // RC Vehicles Resources Address
    let vehicleNormalResourcesAddresses:[String] = [VehicleResources.Vehicle1_normal.rawValue, VehicleResources.Vehicle2_normal.rawValue,
                                                    VehicleResources.Vehicle3_normal.rawValue, VehicleResources.Vehicle4_normal.rawValue,
                                                    VehicleResources.Vehicle5_normal.rawValue, VehicleResources.Vehicle6_normal.rawValue,
                                                    VehicleResources.Vehicle7_normal.rawValue, VehicleResources.Vehicle8_normal.rawValue,
                                                    VehicleResources.Vehicle9_normal.rawValue, VehicleResources.Vehicle10_normal.rawValue,
                                                    VehicleResources.Vehicle11_normal.rawValue, VehicleResources.Vehicle12_normal.rawValue,
                                                    VehicleResources.Vehicle13_normal.rawValue, VehicleResources.Vehicle14_normal.rawValue,
                                                    VehicleResources.Vehicle15_normal.rawValue, VehicleResources.Vehicle16_normal.rawValue]
    
    // Vehicle Spawn Positions per map
    let vehicleSpawnPosition:[SCNVector3] = [SCNVector3Zero,
                                             SCNVector3(-0.8, 0.4, 0.8),
                                             SCNVector3(-0.4, 0.4, 0.4),
                                             SCNVector3(-0.8, 0.4, 0.8),
                                             SCNVector3(-0.4, 0.4, 0.4)]
    
    // Vehicles Images Resources
    let vehiclesImagesResources = [VehicleImages.Vehicle1.rawValue,
                                   VehicleImages.Vehicle2.rawValue,
                                   VehicleImages.Vehicle3.rawValue,
                                   VehicleImages.Vehicle4.rawValue,
                                   VehicleImages.Vehicle5.rawValue,
                                   VehicleImages.Vehicle6.rawValue,
                                   VehicleImages.Vehicle7.rawValue,
                                   VehicleImages.Vehicle8.rawValue,
                                   VehicleImages.Vehicle9.rawValue,
                                   VehicleImages.Vehicle10.rawValue,
                                   VehicleImages.Vehicle11.rawValue,
                                   VehicleImages.Vehicle12.rawValue,
                                   VehicleImages.Vehicle13.rawValue,
                                   VehicleImages.Vehicle14.rawValue,
                                   VehicleImages.Vehicle15.rawValue,
                                   VehicleImages.Vehicle16.rawValue]
    
    //MARK: - Checkpoints Controlls and Resources
    
    // Map 1 Coordinates
    let map1CheckpointsCoordinates:[SCNVector3] = [SCNVector3(0.8, 0.25, -0.8),
                                                   SCNVector3(-0.8, 0.25, 0.0),
                                                   SCNVector3(0.8, 0.25, 0.8)]
    
    // Map 1 rotations
    let map1CheckpointsRotations:[SCNVector3] = [SCNVector3(Float(45.degreesToRadians), 0, Float(90.degreesToRadians)),
                                                 SCNVector3(0, 0, Float(90.degreesToRadians)),
                                                 SCNVector3(-Float(45.degreesToRadians), 0, Float(90.degreesToRadians))]
    
    // Map 2 Coordinates
    let map2CheckpointsCoordinates:[SCNVector3] = [SCNVector3(0.8, 0.25, -0.8),
                                                   SCNVector3(-0.8, 0.25, 0.0),
                                                   SCNVector3(0.8, 0.25, 0.8)]
    
    // Map 2 rotations
    let map2CheckpointsRotations:[SCNVector3] = [SCNVector3(Float(45.degreesToRadians), 0, Float(90.degreesToRadians)),
                                                 SCNVector3(0, 0, Float(90.degreesToRadians)),
                                                 SCNVector3(-Float(45.degreesToRadians), 0, Float(90.degreesToRadians))]
    
    // Map 3 Coordinates
    let map3CheckpointsCoordinates:[SCNVector3] = [SCNVector3(0.8, 0.25, -0.8),
                                                   SCNVector3(-0.8, 0.25, 0.0),
                                                   SCNVector3(0.8, 0.25, 0.8)]
    
    // Map 3 rotations
    let map3CheckpointsRotations:[SCNVector3] = [SCNVector3(Float(45.degreesToRadians), 0, Float(90.degreesToRadians)),
                                                 SCNVector3(0, 0, Float(90.degreesToRadians)),
                                                 SCNVector3(-Float(45.degreesToRadians), 0, Float(90.degreesToRadians))]
    
    // Map 4 Coordinates
    let map4CheckpointsCoordinates:[SCNVector3] = [SCNVector3(0.8, 0.25, -0.8),
                                                   SCNVector3(-0.8, 0.25, 0.0),
                                                   SCNVector3(0.8, 0.25, 0.8)]
    
    // Map 4 rotations
    let map4CheckpointsRotations:[SCNVector3] = [SCNVector3(Float(45.degreesToRadians), 0, Float(90.degreesToRadians)),
                                                 SCNVector3(0, 0, Float(90.degreesToRadians)),
                                                 SCNVector3(-Float(45.degreesToRadians), 0, Float(90.degreesToRadians))]
    
    //MARK: - Brains
    
    // ARBrains
    var arBrain:ARBrain!
    
    //MARK: - Inits
    
    // Dummy init just to access the parameters
    init() {
        self.gameTypeSelected = 0
        self.mapSelected = 0
        self.vehicleSelected = 0
    }
    
    //MARK: - Map functions
    
    // return the resources address for the Selected Map
    func mapAddress() -> String {
        return self.mapResourcesAddresses[self.mapSelected]
    }
    
    //MARK: - Vehicle Functions
    
    // return the position for the vehicle in the Selected Map
    func vehiclePosition() -> SCNVector3 {
        return self.vehicleSpawnPosition[self.mapSelected]
    }
    
    // return the resources for the vehicle in the game mode and map selected
    func vehicleResource() -> String {
        if self.gameTypeSelected == GameMode.SinglePlayer.rawValue || self.gameTypeSelected == GameMode.MultiPlayer.rawValue {
            return self.vehicleSmallResourcesAddresses[self.vehicleSelected]
        }
        else {
            return self.vehicleNormalResourcesAddresses[self.vehicleSelected]
        }
    }
    
    //MARK: - Checkpoint Functions
    
    // return the quantity of checkpoints in the selected map
    func checkpointsQuantity() -> Int {
        switch self.mapSelected {
        case MapSelected.Map1.rawValue:
            return self.map1CheckpointsCoordinates.count
            
        case MapSelected.Map2.rawValue:
            return self.map2CheckpointsCoordinates.count
            
        case MapSelected.Map3.rawValue:
            return self.map3CheckpointsCoordinates.count
            
        case MapSelected.Map4.rawValue:
            return self.map4CheckpointsCoordinates.count
            
        default:
            return 0
        }
    }
    
    // return the coordinate list of checkpoints in the selected map
    func checkpointsCoordinates() -> [SCNVector3] {
        switch self.mapSelected {
        case MapSelected.Map1.rawValue:
            return self.map1CheckpointsCoordinates
            
        case MapSelected.Map2.rawValue:
            return self.map2CheckpointsCoordinates
            
        case MapSelected.Map3.rawValue:
            return self.map3CheckpointsCoordinates
            
        case MapSelected.Map4.rawValue:
            return self.map4CheckpointsCoordinates
            
        default:
            return [SCNVector3Zero]
        }
    }
    
    // return the rotation list of checkpoints in the selected map
    func checkpointsRotations() -> [SCNVector3] {
        switch self.mapSelected {
        case MapSelected.Map1.rawValue:
            return self.map1CheckpointsRotations
            
        case MapSelected.Map2.rawValue:
            return self.map2CheckpointsRotations
            
        case MapSelected.Map3.rawValue:
            return self.map3CheckpointsRotations
            
        case MapSelected.Map4.rawValue:
            return self.map4CheckpointsRotations
            
        default:
            return [SCNVector3Zero]
        }
    }
}
