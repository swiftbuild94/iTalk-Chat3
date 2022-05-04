//
//  TimerManager.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 03/05/2022.
//

import SwiftUI

class TimerManager: ObservableObject {
    @Published var secondsElapsed = 0.0
    private var timer = Timer()
    
    func startTimer() {
       timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
            self.secondsElapsed += 0.1
        })
    }
    
    func stopTimer() {
        timer.invalidate()
        secondsElapsed = 0
    }
}
