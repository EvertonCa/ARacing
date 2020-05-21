//
//  Sounds.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 21/05/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import ARKit

struct Sounds {
    
    //MARK: - Variables
    
    // Audio player
    var player: AVAudioPlayer!
    
    // go text sound
    var goTextAudioResource = SCNAudioSource()
    
    // engine sound
    var engineAudioResource = SCNAudioSource()
    
    // crash sound
    var crashAudioResource = SCNAudioSource()
    
    // ready text sound
    var readyTextAudioResource = SCNAudioSource()
    
    // acceleration sound
    var accelerationAudioResource = SCNAudioSource()
    
    // reduction sound
    var reductionAudioResource = SCNAudioSource()
    
    // ambient sound mountain
    var mountainAmbientResource = SCNAudioSource()
    
    // snow sound mountain
    var snowAmbientResource = SCNAudioSource()
    
    //MARK: - Init
    
    init() {
        self.loadGoTextAudio()
        self.loadEngineAudio()
        self.loadCrashAudio()
        self.loadReadyTextAudio()
        self.loadAccelerationAudio()
        self.loadReductionAudio()
        self.loadSnowAmbientAudio()
        self.loadMountainAmbientAudio()
    }
    
    //MARK: - Functions
    
    // Starts playing the background music
    mutating func playIntroMusic() {
        let path = Bundle.main.path(forResource: SoundsResources.Intro.rawValue, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        self.player = try! AVAudioPlayer(contentsOf: url)
        self.player.volume = 0.2
        self.player.play()
    }
    
    // Starts playing the mountain music
    mutating func playMountainMusic() {
        let path = Bundle.main.path(forResource: SoundsResources.MusicMountain.rawValue, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        self.player = try! AVAudioPlayer(contentsOf: url)
        self.player.volume = 0.2
        self.player.play()
    }
    
    // Starts playing the snow music
    mutating func playSnowMusic() {
        let path = Bundle.main.path(forResource: SoundsResources.MusicSnow.rawValue, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        self.player = try! AVAudioPlayer(contentsOf: url)
        self.player.volume = 0.2
        self.player.play()
    }
    
    // Starts playing the space music
    mutating func playSpaceMusic() {
        let path = Bundle.main.path(forResource: SoundsResources.MusicSpace.rawValue, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        self.player = try! AVAudioPlayer(contentsOf: url)
        self.player.volume = 0.2
        self.player.play()
    }
    
    // Stops the background music
    mutating func stopMusic() {
        self.player.stop()
    }
    
    // loads the go text audio
    mutating func loadGoTextAudio() {
        let path = Bundle.main.path(forResource: SoundsResources.Go.rawValue, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        self.goTextAudioResource = SCNAudioSource(url: url)!
        self.goTextAudioResource.load()
    }
    
    // loads the engine audio
    mutating func loadEngineAudio() {
        let path = Bundle.main.path(forResource: SoundsResources.Engine.rawValue, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        self.engineAudioResource = SCNAudioSource(url: url)!
        self.engineAudioResource.load()
    }
    
    // loads the crash audio
    mutating func loadCrashAudio() {
        let path = Bundle.main.path(forResource: SoundsResources.Crash.rawValue, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        self.crashAudioResource = SCNAudioSource(url: url)!
        self.crashAudioResource.load()
    }
    
    // loads the ready text audio
    mutating func loadReadyTextAudio() {
        let path = Bundle.main.path(forResource: SoundsResources.Ready.rawValue, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        self.readyTextAudioResource = SCNAudioSource(url: url)!
        self.readyTextAudioResource.load()
    }
    
    // loads the acceleration audio
    mutating func loadAccelerationAudio() {
        let path = Bundle.main.path(forResource: SoundsResources.Acceleration.rawValue, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        self.accelerationAudioResource = SCNAudioSource(url: url)!
        self.accelerationAudioResource.load()
    }
    
    // loads the reduction audio
    mutating func loadReductionAudio() {
        let path = Bundle.main.path(forResource: SoundsResources.Reduction.rawValue, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        self.reductionAudioResource = SCNAudioSource(url: url)!
        self.reductionAudioResource.load()
    }
    
    // loads the mountain ambient audio
    mutating func loadMountainAmbientAudio() {
        let path = Bundle.main.path(forResource: SoundsResources.AmbientMountain.rawValue, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        self.mountainAmbientResource = SCNAudioSource(url: url)!
        self.mountainAmbientResource.loops = true
        self.mountainAmbientResource.load()
    }
    
    // loads the mountain ambient audio
    mutating func loadSnowAmbientAudio() {
        let path = Bundle.main.path(forResource: SoundsResources.AmbientSnow.rawValue, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        self.snowAmbientResource = SCNAudioSource(url: url)!
        self.snowAmbientResource.loops = true
        self.snowAmbientResource.load()
    }
    
}
