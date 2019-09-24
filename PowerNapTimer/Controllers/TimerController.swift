//
//  TimerController.swift
//  PowerNapTimer
//
//  Created by Bethany Wride on 9/24/19.
//  Copyright © 2019 Bethany Wride. All rights reserved.
//

import Foundation

// Step 1
protocol TimerDelegate: class {
    func timerSecondTicked()
    func timerCompleted()
    func timerStopped()
}

class TimerController {
    
    // Source of truth - Timer and TimeInterval are built in classes
    var timer: Timer?
    var timeRemaining: TimeInterval?
    
    // Step 2: Declared delegate to get access to protocol methods
    weak var delegate: TimerDelegate?
    
    var isOn: Bool {
        return timeRemaining != nil ? true : false
    }
    
    func secondTick() {
        guard let timeRemaining = timeRemaining else { return }
        if timeRemaining > 0 {
            self.timeRemaining = timeRemaining - 1
            // Implement timerSecondTicked on the ViewController
            delegate?.timerSecondTicked()
        } else {
            timer?.invalidate()
            self.timeRemaining = nil
            // Timer at 0, implement timerCompleted method
            delegate?.timerCompleted()
        }
    }
    
    // The underscore tells the method you don't need to print the parameter name before the type
    func startTimerWith(time: TimeInterval){
        if isOn == false {
            timeRemaining = time
           // Run consecutively on the queue
            DispatchQueue.main.async {
//                self.secondTick()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                    self.secondTick()
                })
            }
        }
    }
    
    func stopTimer() {
        if isOn == true {
            // Set to nil so that it can fall through the guard let statement in secondTick()
            timeRemaining = nil
            timer?.invalidate()
            delegate?.timerStopped()
        }
    }
}
