//
//  Timer.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 22/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import UIKit

class LapTimer {
     
    //MARK: - Variables and Constants
    
    // time elapsed in seconds
    var counter:Double = 0.0
    
    // timer elapsed in minutes
    var minutes:Int = 0
    
    // timer instance
    var timer = Timer()
    
    // if the timer is running
    var isPlaying = false
    
    // label
    var timerLabel: UILabel
    
    //MARK: - Functions
    
    init(timerLabel: UILabel) {
        self.timerLabel = timerLabel
    }
    
    // start the timer
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isPlaying = true
    }
    
    // updates de counter
    @objc func updateTimer() {
        self.counter += 0.1
        self.updateLabel()
    }
    
    // Updates the label with the current elapsed time in minutes, seconds and 1/10 sec
    func updateLabel() {
        DispatchQueue.main.async {
            let counterInt = Int(self.counter)
            if counterInt >= 60{
                self.counter = 0.0
                self.minutes += 1
            }
            let text = "\(self.minutes)m" + String(format: "%.1f", self.counter) + "s"
            self.timerLabel.text = text
        }
    }
    
    // stops the timer
    func stopTimer() {
        self.timer.invalidate()
        self.isPlaying = false
    }
    
    // resets the timer
    func resetTimer() {
        self.counter = 0.0
        self.minutes = 0
        self.timer = Timer()
    }
    
}
