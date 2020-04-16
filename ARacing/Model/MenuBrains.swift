//
//  MenuBrains.swift
//  ARacing
//
//  Created by Everton Cardoso on 03/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import Foundation
import AVFoundation

struct MenuBrains {
    
    //MARK: - Global Variables
    var player: AVAudioPlayer!
    
    //MARK: - Functions
    
    // Starts playing the background music
    mutating func playIntroMusic() {
        let url = Bundle.main.url(forResource: "Intro", withExtension: "m4a")
        self.player = try! AVAudioPlayer(contentsOf: url!)
        self.player.play()
    }
    
    // Stops the background music
    mutating func stopIntroMusic() {
        self.player.stop()
    }
    
}
