//
//  Game.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 05/05/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import UIKit
import ARKit

// Controls all game parameters and variables
class Game {
    //MARK: - Game Controls Variables
    
    // Game Type Selected
    var gameTypeSelected:Int
    
    //MARK: - Map Controls and Resources
    
    // Map selected
    var mapSelected:Int
    
    // Map Resources Addresses
    let mapResourcesAddresses:[String] = [MapsResources.Map1.rawValue,
                                          MapsResources.Map2.rawValue,
                                          MapsResources.Map3.rawValue,
                                          MapsResources.Map4.rawValue]
    
    // Map Images Resources
    let mapImagesResources:[String] = [MapsImages.Map1.rawValue,
                                       MapsImages.Map2.rawValue,
                                       MapsImages.Map3.rawValue,
                                       MapsImages.Map4.rawValue]
    
    // Map Names
    let mapNames:[String] = [MapsNames.Map1.rawValue,
                             MapsNames.Map2.rawValue,
                             MapsNames.Map3.rawValue,
                             MapsNames.Map4.rawValue]
    
    //MARK: - Vehicle Controls and Resources
    
    // Vehicle Selected
    var vehicleSelected:Int
    
    // Single and Multi Player Vehicles Resources Addresses
    let vehicleSmallResourcesAddresses:[String] = [VehicleResources.Vehicle1_small.rawValue,
                                                   VehicleResources.Vehicle2_small.rawValue,
                                                   VehicleResources.Vehicle3_small.rawValue,
                                                   VehicleResources.Vehicle4_small.rawValue,
                                                   VehicleResources.Vehicle5_small.rawValue,
                                                   VehicleResources.Vehicle6_small.rawValue,
                                                   VehicleResources.Vehicle7_small.rawValue,
                                                   VehicleResources.Vehicle8_small.rawValue,
                                                   VehicleResources.Vehicle9_small.rawValue,
                                                   VehicleResources.Vehicle10_small.rawValue,
                                                   VehicleResources.Vehicle11_small.rawValue,
                                                   VehicleResources.Vehicle12_small.rawValue,
                                                   VehicleResources.Vehicle13_small.rawValue,
                                                   VehicleResources.Vehicle14_small.rawValue,
                                                   VehicleResources.Vehicle15_small.rawValue,
                                                   VehicleResources.Vehicle16_small.rawValue]
    
    // RC Vehicles Resources Address
    let vehicleNormalResourcesAddresses:[String] = [VehicleResources.Vehicle1_normal.rawValue,
                                                    VehicleResources.Vehicle2_normal.rawValue,
                                                    VehicleResources.Vehicle3_normal.rawValue,
                                                    VehicleResources.Vehicle4_normal.rawValue,
                                                    VehicleResources.Vehicle5_normal.rawValue,
                                                    VehicleResources.Vehicle6_normal.rawValue,
                                                    VehicleResources.Vehicle7_normal.rawValue,
                                                    VehicleResources.Vehicle8_normal.rawValue,
                                                    VehicleResources.Vehicle9_normal.rawValue,
                                                    VehicleResources.Vehicle10_normal.rawValue,
                                                    VehicleResources.Vehicle11_normal.rawValue,
                                                    VehicleResources.Vehicle12_normal.rawValue,
                                                    VehicleResources.Vehicle13_normal.rawValue,
                                                    VehicleResources.Vehicle14_normal.rawValue,
                                                    VehicleResources.Vehicle15_normal.rawValue,
                                                    VehicleResources.Vehicle16_normal.rawValue]
    
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
    
    // Single Player Vehicle Spawn Positions per map
    let vehicleSpawnPosition:[SCNVector3] = [SCNVector3(-0.8, 0.4, 0.8),
                                             SCNVector3(0.0, 0.4, 0.0),
                                             SCNVector3(-0.8, 0.4, 0.8),
                                             SCNVector3(-0.4, 0.4, 0.4)]
    
    // Multi Player Vehicle Spawns Positions per map - each row is a map; each column is a initial spawn
    let listVehiclesSpawn:[[SCNVector3]] = [[SCNVector3(-0.8, 0.4, 0.8), SCNVector3(-0.7, 0.4, 0.8),
                                             SCNVector3(-0.8, 0.4, 0.8), SCNVector3(-0.8, 0.4, 0.8),
                                             SCNVector3(-0.8, 0.4, 0.8), SCNVector3(-0.8, 0.4, 0.8),
                                             SCNVector3(-0.8, 0.4, 0.8), SCNVector3(-0.8, 0.4, 0.8)],
                                            [SCNVector3(-0.8, 0.4, 0.8), SCNVector3(-0.8, 0.4, 0.8),
                                             SCNVector3(-0.8, 0.4, 0.8), SCNVector3(-0.8, 0.4, 0.8),
                                             SCNVector3(-0.8, 0.4, 0.8), SCNVector3(-0.8, 0.4, 0.8),
                                             SCNVector3(-0.8, 0.4, 0.8), SCNVector3(-0.8, 0.4, 0.8)],
                                            [SCNVector3(-0.8, 0.4, 0.8), SCNVector3(-0.8, 0.4, 0.8),
                                             SCNVector3(-0.8, 0.4, 0.8), SCNVector3(-0.8, 0.4, 0.8),
                                             SCNVector3(-0.8, 0.4, 0.8), SCNVector3(-0.8, 0.4, 0.8),
                                             SCNVector3(-0.8, 0.4, 0.8), SCNVector3(-0.8, 0.4, 0.8)],
                                            [SCNVector3(-0.8, 0.4, 0.8), SCNVector3(-0.8, 0.4, 0.8),
                                             SCNVector3(-0.8, 0.4, 0.8), SCNVector3(-0.8, 0.4, 0.8),
                                             SCNVector3(-0.8, 0.4, 0.8), SCNVector3(-0.8, 0.4, 0.8),
                                             SCNVector3(-0.8, 0.4, 0.8), SCNVector3(-0.8, 0.4, 0.8)]]
    
    //MARK: - Checkpoints Controls and Resources
    
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
    
    // Control variable for random checkpoint spawns
    var randomCheckpointSpawn:[Int] = []
    
    //MARK: - Multipeer Resources
    
    // Multipeer type of connection selected
    var multipeerConnectionSelected:Int
    
    //MARK: - Multiplayer Control Variables
    
    // Quantity of peers in the session
    var peersQuantity:Int
    
    // Peers Hash IDs - the first is always the host
    var peersHashIDs:[Int]
    
    // Selected Vehicles list
    var listSelectedVehicles:[Int]
    
    // Peers ready
    var peersReady:[Bool]
    
    //MARK: - User Defaults
    
    // User Defaults
    let defaults = UserDefaults.standard
    
    // Map 1 Record
    var map1Record:Double = 99999999.9
    
    // Map 2 Record
    var map2Record:Double = 99999999.9
    
    // Map 3 Record
    var map3Record:Double = 99999999.9
    
    // Map 4 Record
    var map4Record:Double = 99999999.9
    
    //MARK: - Brains
    
    // ARBrains
    var arBrain:ARBrain!
    
    //MARK: - Inits
    
    // Dummy init just to access the parameters
    init() {
        self.gameTypeSelected = 0
        self.mapSelected = 0
        self.vehicleSelected = 0
        self.multipeerConnectionSelected = 0
        self.peersQuantity = 0
        self.peersHashIDs = [0]
        self.listSelectedVehicles = [0]
        self.peersReady = [true]
        self.loadUserDefaults()
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
        if self.gameTypeSelected == GameMode.SinglePlayer.rawValue {
            return self.vehicleSmallResourcesAddresses[self.vehicleSelected]
        }
        else {
            return self.vehicleNormalResourcesAddresses[self.vehicleSelected]
        }
    }
    
    // return the resources for the vehicle in the game mode and map selected
    func vehicleResourceWithIndex(index:Int) -> String {
        
        return self.vehicleSmallResourcesAddresses[self.listSelectedVehicles[index]]
        
    }
    
    //MARK: - Audio Functions
    
    // plays the correct music
    func playMapMusic() {
        switch self.mapSelected {
        case MapSelected.Map1.rawValue:
            self.arBrain.arViewController.sounds.playMountainMusic()
            
        case MapSelected.Map2.rawValue:
            self.arBrain.arViewController.sounds.playSnowMusic()
            
        case MapSelected.Map3.rawValue:
            self.arBrain.arViewController.sounds.playSpaceMusic()
            
        case MapSelected.Map4.rawValue:
            self.arBrain.arViewController.sounds.playMountainMusic()
            
        default:
            break
        }
    }
    
    // play the correct ambient sound
    func playAmbientSound() -> SCNAudioPlayer {

        switch self.mapSelected {
        case MapSelected.Map1.rawValue:
            return SCNAudioPlayer(source: self.arBrain.arViewController.sounds.mountainAmbientResource)
            
        case MapSelected.Map2.rawValue:
            return SCNAudioPlayer(source: self.arBrain.arViewController.sounds.snowAmbientResource)
            
        case MapSelected.Map3.rawValue:
            return SCNAudioPlayer(source: self.arBrain.arViewController.sounds.mountainAmbientResource)
            
        case MapSelected.Map4.rawValue:
            return SCNAudioPlayer(source: self.arBrain.arViewController.sounds.mountainAmbientResource)
            
        default:
            return SCNAudioPlayer(source: self.arBrain.arViewController.sounds.mountainAmbientResource)
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
        
        if self.gameTypeSelected == GameMode.MultiPlayer.rawValue {
            switch self.mapSelected {
            case MapSelected.Map1.rawValue:
                var tempList:[SCNVector3] = []
                for index in self.randomCheckpointSpawn {
                    tempList.append(self.map1CheckpointsCoordinates[index])
                }
                return tempList
                
            case MapSelected.Map2.rawValue:
                var tempList:[SCNVector3] = []
                for index in self.randomCheckpointSpawn {
                    tempList.append(self.map2CheckpointsCoordinates[index])
                }
                return tempList
                
            case MapSelected.Map3.rawValue:
                var tempList:[SCNVector3] = []
                for index in self.randomCheckpointSpawn {
                    tempList.append(self.map3CheckpointsCoordinates[index])
                }
                return tempList
                
            case MapSelected.Map4.rawValue:
                var tempList:[SCNVector3] = []
                for index in self.randomCheckpointSpawn {
                    tempList.append(self.map4CheckpointsCoordinates[index])
                }
                return tempList
                
            default:
                return [SCNVector3Zero]
            }
        }
        else {
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
    }
    
    // return the rotation list of checkpoints in the selected map
    func checkpointsRotations() -> [SCNVector3] {
        
        if self.gameTypeSelected == GameMode.MultiPlayer.rawValue {
            switch self.mapSelected {
            case MapSelected.Map1.rawValue:
                var tempList:[SCNVector3] = []
                for index in self.randomCheckpointSpawn {
                    tempList.append(self.map1CheckpointsRotations[index])
                }
                return tempList
                
            case MapSelected.Map2.rawValue:
                var tempList:[SCNVector3] = []
                for index in self.randomCheckpointSpawn {
                    tempList.append(self.map2CheckpointsRotations[index])
                }
                return tempList
                
            case MapSelected.Map3.rawValue:
                var tempList:[SCNVector3] = []
                for index in self.randomCheckpointSpawn {
                    tempList.append(self.map3CheckpointsRotations[index])
                }
                return tempList
                
            case MapSelected.Map4.rawValue:
                var tempList:[SCNVector3] = []
                for index in self.randomCheckpointSpawn {
                    tempList.append(self.map4CheckpointsRotations[index])
                }
                return tempList
                
            default:
                return [SCNVector3Zero]
            }
        }
        else {
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
    
    // creates the list with random checkpoint spawns
    func randomizeCheckpointsSpawns() {
        self.randomCheckpointSpawn = []
        switch self.mapSelected {
        case MapSelected.Map1.rawValue:
            for i in 0..<self.map1CheckpointsCoordinates.count {
                self.randomCheckpointSpawn.append(i)
            }
            
        case MapSelected.Map2.rawValue:
            for i in 0..<self.map2CheckpointsCoordinates.count {
                self.randomCheckpointSpawn.append(i)
            }
            
        case MapSelected.Map3.rawValue:
            for i in 0..<self.map3CheckpointsCoordinates.count {
                self.randomCheckpointSpawn.append(i)
            }
            
        case MapSelected.Map4.rawValue:
            for i in 0..<self.map4CheckpointsCoordinates.count {
                self.randomCheckpointSpawn.append(i)
            }
            
        default:
            break
        }
        
        self.randomCheckpointSpawn.shuffle()
    }
    
    // returns the selected map record time
    func checkRecord() -> Double {
        switch self.mapSelected {
        case MapSelected.Map1.rawValue:
            return self.map1Record
            
        case MapSelected.Map2.rawValue:
            return self.map2Record
            
        case MapSelected.Map3.rawValue:
            return self.map3Record
            
        case MapSelected.Map4.rawValue:
            return self.map4Record
            
        default:
            return 0.0
        }
    }
    
    // Loads User Defaults
    func loadUserDefaults() {
        let temp1 = defaults.double(forKey: MapRecord.Map1.rawValue)
        let temp2 = defaults.double(forKey: MapRecord.Map2.rawValue)
        let temp3 = defaults.double(forKey: MapRecord.Map3.rawValue)
        let temp4 = defaults.double(forKey: MapRecord.Map4.rawValue)
        
        if temp1 != 0 {
            self.map1Record = temp1
        }
        if temp2 != 0 {
            self.map2Record = temp2
        }
        if temp3 != 0 {
            self.map3Record = temp3
        }
        if temp4 != 0 {
            self.map4Record = temp4
        }
    }
    
    // Saves to User Defaults the new record on the selected map
    func saveRecord(record:Double) {
        switch self.mapSelected {
        case MapSelected.Map1.rawValue:
            self.map1Record = record
            defaults.set(record, forKey: MapRecord.Map1.rawValue)
            
        case MapSelected.Map2.rawValue:
            self.map2Record = record
            defaults.set(record, forKey: MapRecord.Map2.rawValue)
            
        case MapSelected.Map3.rawValue:
            self.map3Record = record
            defaults.set(record, forKey: MapRecord.Map3.rawValue)
            
        case MapSelected.Map4.rawValue:
            self.map4Record = record
            defaults.set(record, forKey: MapRecord.Map4.rawValue)
            
        default:
            break
        }
    }
}
